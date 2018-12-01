//
// Created by fengtianyu on 7/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNDBManager.h"
#import <fmdb/FMDB.h>

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

- (void)createTables {
    BOOL dbOpenResult = [self createDataBase];
    NSAssert(dbOpenResult, @"数据库创建失败");

    // 小组表  待办事项的小组  (小组id, 小组名, 小组的第一条内容, 小组中事项数量)
    if (![self tableExist:kJNDBGroupTable]) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ ("
                                                        "group_id integer primary key autoincrement not null, "
                                                        "group_name text not null, "
                                                        "group_first_content text default '该小组目前空空如也~', "
                                                        "group_item_count integer default 0,"
                                                        "deleted integer default 0,"
                                                        "update_time integer"
                                                        ")",
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
    
    // 分类表 (待办事项的分类 分类id，分类名，分类所属于的小组)
    if (![self tableExist:kJNDBCategoryTable]) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ ("
                                                       "category_id integer primary key autoincrement not null, "
                                                       "category_name text not null , "
                                                       "group_id integer default 0, "
                                                        "deleted integer default 0,"
                                                        "update_time integer,"
                                                       "foreign key(group_id) references %@(group_id))",
                                                       kJNDBCategoryTable, kJNDBGroupTable];
            BOOL result = [db executeUpdate:sql];
             NSAssert(result, @"分类表创建失败");
        }];
    }

    // 待办清单表  (事项id，事项内容，事项的日期，事项的开始时间，事项的结束时间，事项所属于的小组id，事项所属于的分类id，是否提醒，是否完成)
    if (![self tableExist:kJNDBListTable]) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ ("
                                                       "item_id integer primary key autoincrement not null, "
                                                       "content text not null, "
                                                       "start_time integer default 0, "
                                                       "end_time integer default 0, "
                                                       "group_id integer, "
                                                       "category_id integer default -100, "
                                                       "category_name text default NULL, "
                                                       "notification integer default 0, "
                                                       "finished integer default 0, "
                                                        "deleted integer default 0,"
                                                        "update_time integer,"
                                                       "foreign key(group_id) references %@(group_id), "
                                                       "foreign key(category_id) references %@(category_id))",
                                                       kJNDBListTable, kJNDBGroupTable, kJNDBCategoryTable];
            BOOL result = [db executeUpdate:sql];
            NSAssert(result, @"清单表创建失败");
        }];
    }


    // 事件类型表 （事件类型id，事件类型名，事件类型的颜色）
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

    // 事件表 （事件id，事件内容，事件日期，事件类型，事件类型颜色，开始时间，结束时间，是否提醒）
    if (![self tableExist:kJNDBEventsTable]) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ ("
                                                       "event_id integer primary key autoincrement not null, "
                                                       "content text not null, "
                                                       "show_date date not null, "
                                                       "event_type_id integer not null, "
                                                       "event_type_color varchar(10), "
                                                       "start_time integer default 0, "
                                                       "end_time integer default 0, "
                                                       "notification integer default 0,"
                                                        "deleted integer default 0,"
                                                        "update_time integer"
                                                        ")",
                                                       kJNDBEventsTable];
            BOOL result = [db executeUpdate:sql];
            NSAssert(result, @"事件表创建失败");
        }];
    }

}


/**
 修改表结构，增加字段
 */
- (void)alterTable {
    
    NSArray *tables = @[kJNDBGroupTable, kJNDBCategoryTable, kJNDBListTable, kJNDBEventsTable];
    for (NSString *tableName in tables) {
        [self.dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
            NSString *addDeletedSql = [NSString stringWithFormat:@"alter table %@ add column deleted integer default 0", tableName];
            NSString *addUpdateTimeSql = [NSString stringWithFormat:@"alter table %@ add column update_time integer", tableName];
            [db executeUpdate:addDeletedSql];
            [db executeUpdate:addUpdateTimeSql];
        }];
    }
}

- (BOOL)tableExist:(NSString *)tableName {
    __block BOOL exist = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db tableExists:tableName];
    }];
    return exist;
}

@end
