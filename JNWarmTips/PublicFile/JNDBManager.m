//
// Created by fengtianyu on 7/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNDBManager.h"
#import <fmdb/FMDB.h>

/*
 * 事件表和清单表的字段为
    id 
    内容 
    show_date ：该事件的日期。清单中该字段用于分类时使用，该字段为startTime格式化之后，没有选时间则该字段为null。日历中用于决定哪一天显示事件，事件表中该字段不能为空。
    开始时间 ：时间戳。用于显示时间段
    结束时间 ：时间戳
    标签id ：
    分组id ：
    是否完成：默认为0
    是否需要通知：默认为0

 *  小组表
 *      ID 小组名 小组第一条内容(默认为'该小组目前空空如也~') 小组内内容数量
 *      删除小组后 所有属于该小组的分组全部删除，属于该小组的item的group_id=0 category_id = null
 *
 * 分组表
 *      id 分组名 小组id(所属于的小组)
 *      分组名不可重复
 * 时间表
 *      id content(事件内容,必要) show_date(事件日期，必要) start_time(开始时间) end_time(结束时间) group_id(所属于小组，同步到清单中时需要) category_id(所属分类，同步到清单时需要) notification(是否需要通知 默认0 不需要) finished(是否完成 默认0 不需要)
 */

NSString *const kJNDBListTable = @"list_table";

NSString *const kJNDBEventsTable = @"events_table";

NSString *const kJNDBGroupTable = @"group_table";

NSString *const kJNDBCategoryTable = @"category_table";

NSString *const kJNDBEventTypeTable = @"event_type_table";

@implementation JNDBManager {

}

+ (instancetype) shareInstance {
    static JNDBManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (BOOL) createDataBase {
    NSString *dbPath = [NSString stringWithFormat:@"%@/Library/JN.db", NSHomeDirectory()];
    NSLog(@"ty==\t数据库路径:%@",dbPath);
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (self.dbQueue) {
        return YES;
    } else {
        return NO;
    }
}

- (void) closeDataBase {
    [self.dbQueue close];
    _dbQueue = nil;
}

- (void) createTables {
    BOOL dbOpenResult = [self createDataBase];
    NSAssert(dbOpenResult, @"数据库创建失败");

    // 小组表
    if (![self tableExist:kJNDBGroupTable]) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ ("
                                                       "group_id integer primary key autoincrement not null, "
                                                       "group_name text not null, "
                                                       "group_first_content text default '该小组目前空空如也~', "
                                                       "group_item_count integer default 0)",
                                                       kJNDBGroupTable];
            BOOL result = [db executeUpdate:sql];
            NSAssert(result, @"小组表创建失败");
            // 初始化第一条数据
            NSString *initSql = [NSString stringWithFormat:@"insert or ignore into %@"
                                                           "('group_id', 'group_name') "
                                                           "values (0,'ALL')",
                                                           kJNDBGroupTable];
            [db executeUpdate:initSql];
        }];
    }
    
    // 分类表
    if (![self tableExist:kJNDBCategoryTable]) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ ("
                                                       "category_id integer primary key autoincrement not null, "
                                                       "category_name text not null , "
                                                       "group_id integer default 0, "
                                                       "foreign key(group_id) references %@(group_id))",
                                                       kJNDBCategoryTable, kJNDBGroupTable];
            BOOL result = [db executeUpdate:sql];
             NSAssert(result, @"分类表创建失败");
        }];
    }

    // 清单表
    if (![self tableExist:kJNDBListTable]) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ ("
                                                       "item_id integer primary key autoincrement not null, "
                                                       "content text not null, "
                                                       "show_date date default '', "
                                                       "start_time integer default null, "
                                                       "end_time integer default null, "
                                                       "group_id integer, "
                                                       "category_id integer , "
                                                       "notification integer default 0, "
                                                       "finished integer default 0, "
                                                       "foreign key(group_id) references %@(group_id), "
                                                       "foreign key(group_id) references %@(category_id))",
                                                       kJNDBListTable, kJNDBGroupTable, kJNDBCategoryTable];
            BOOL result = [db executeUpdate:sql];
            NSAssert(result, @"清单表创建失败");
        }];
    }

    // 事件类型表
    if (![self tableExist:kJNDBEventTypeTable]) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ ("
                                                       "event_type_id integer primary key autoincrement not null, "
                                                       "event_type_name text not null, "
                                                       "color text not null)",
                                                       kJNDBEventTypeTable];
            BOOL result = [db executeUpdate:sql];
            NSAssert(result, @"事件类型表创建失败");

            NSString *initSql1 = [NSString stringWithFormat:@"insert or ignore into %@ ("
                                                            "'event_type_id','event_type_name', 'color') "
                                                            "values (0, '个人', 'FF364F')", kJNDBEventTypeTable];
            [db executeUpdate:initSql1];
            NSString *initSql2 = [NSString stringWithFormat:@"insert or ignore into %@ ("
                                                            "'event_type_id','event_type_name', 'color') "
                                                            "values (1, '工作', '00BFFF')", kJNDBEventTypeTable];
            [db executeUpdate:initSql2];
        }];
    }

    // 事件表
    if (![self tableExist:kJNDBEventsTable]) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ ("
                                                       "event_id integer primary key autoincrement not null, "
                                                       "content text not null, "
                                                       "show_date date not null, "
                                                       "start_time integer default null, "
                                                       "end_time integer default null, "
                                                       "group_id integer, "
                                                       "category_id integer , "
                                                       "notification integer default 0, "
                                                       "finished integer default 0, "
                                                       "foreign key(group_id) references %@(group_id), "
                                                       "foreign key(category_id) references %@(category_id))",
                                                       kJNDBEventsTable, kJNDBGroupTable, kJNDBCategoryTable];
            BOOL result = [db executeUpdate:sql];
            NSAssert(result, @"事件表创建失败");
        }];
    }

}

- (BOOL) tableExist:(NSString *)tableName {
    __block BOOL exist = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db tableExists:tableName];
    }];
    return exist;
}

@end
