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
    show_date ：该事件的日期。清单中无该字段。清单向日历同步时该字段为清单的start_time中的日期
    开始时间 ：时间戳。用于显示时间段
    结束时间 ：时间戳
    标签id ：
    分组id ：
    是否完成：默认为0
    是否需要通知：默认为0
 
 * 分组表
    分组名不可重复
 */

static NSString *const kJNDBListTable = @"list_table";

static NSString *const kJNDBEventsTable = @"events_table";

static NSString *const kJNDBGroupTable = @"group_table";

static NSString *const kJNDBCategoryTable = @"category_table";

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
    
    // 小组表
    if (![self tableExist:kJNDBGroupTable]) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXIST %@ (GROUP_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, GROUP_NAME TEXT NOT NULL)", kJNDBGroupTable];
            BOOL result = [db executeUpdate:sql];
            NSAssert(!result, @"小组表创建失败");
        }];
    }
    
    // 分类表
    if (![self tableExist:kJNDBCategoryTable]) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXIST %@ (CATEGORY_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, CATEGORY_NAME TEXT NOT NULL , GROUP_ID INTEGER, FOREIGN KEY(GROUP_ID) REFERENCES %@(GROUP_ID))", kJNDBCategoryTable, kJNDBGroupTable];
            BOOL result = [db executeUpdate:sql];
             NSAssert(!result, @"分类表创建失败");
        }];
    }

    // 清单表
    if (![self tableExist:kJNDBListTable]) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXIST %@ (ITEM_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, CONTENT TEXT NOT NULL, START_TIME INTEGER DEFAULT NULL, END_TIME INTEGER DEFAULT NULL, TAG_ID INTEGER, CATEGORY_ID INTEGER , NOTIFICATION INTEGER DEFAULT 0, FINISHED INTEGER DEFAULT 0, FOREIGN KEY(GROUP_ID) REFERENCES %@(GROUP_ID), FOREIGN KEY(CATEGORY_ID) REFERENCES %@(CATEGORY_ID))", kJNDBListTable, kJNDBGroupTable, kJNDBCategoryTable];
            BOOL result = [db executeUpdate:sql];
            NSAssert(!result, @"清单表创建失败");
        }];
    }

    // 事件表
    if (![self tableExist:kJNDBEventsTable]) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXIST %@ (EVENT_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, CONTENT TEXT NOT NULL, SHOW_DATE DATE NOT NULL, START_TIME INTEGER DEFAULT NULL, END_TIME INTEGER DEFAULT NULL, TAG_ID INTEGER, CATEGORY_ID INTEGER , NOTIFICATION INTEGER DEFAULT 0, FINISHED INTEGER DEFAULT 0, FOREIGN KEY(GROUP_ID) REFERENCES %@(GROUP_ID), FOREIGN KEY(CATEGORY_ID) REFERENCES %@(CATEGORY_ID))", kJNDBListTable, kJNDBGroupTable, kJNDBCategoryTable];
            BOOL result = [db executeUpdate:sql];
            NSAssert(!result, @"事件表创建失败");
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
