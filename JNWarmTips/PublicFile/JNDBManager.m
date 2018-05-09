//
// Created by fengtianyu on 7/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNDBManager.h"
#import <fmdb/FMDB.h>

static NSString *const kJNDBListTable = @"list_table";

static NSString *const kJNDBEventsTable = @"events_table";

static NSString *const kJNDBGroupTable = @"group_table";

static NSString *const kJNDBCategoryTable = @"category_table";

@implementation JNDBManager {

}

+ (instancetype) shareInstance {
    static JNDBManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(onceToken, ^{
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

    if (![self tableExist:kJNDBListTable]) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXIST %@ (ITEM_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, CONTENT TEXT DEFAULT '', DATE TEXT DEFAULT '', TIME TEXT DEFAULT '', TAG TEXT DEFAULT '', CATEGORY TEXT DEFAULT '', NOTIFICATION INTEGER DEFAULT 0, FINISHED INTEGER DEFAULT 0 )", kJNDBListTable];
            BOOL result = [db executeUpdate:sql];
            if (!result) {
                NSLog(@"list表创建失败");
            }
        }];
    }

    if (![self tableExist:kJNDBEventsTable]) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXIST %@ (EVENT_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, CONTENT TEXT DEFAULT '', DATE TEXT DEFAULT '', TIME TEXT DEFAULT '', TAG TEXT DEFAULT '', CATEGORY TEXT DEFAULT '', NOTIFICATION INTEGER DEFAULT 0, FINISHED INTEGER DEFAULT 0 )", kJNDBEventsTable];
            BOOL result = [db executeUpdate:sql];
            if (!result) {
                NSLog(@"list表创建失败");
            }
        }];
    }

    if (![self tableExist:kJNDBGroupTable]) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXIST %@ (GROUP_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, GROUP_NAME TEXT DEFAULT '')", kJNDBGroupTable];
            BOOL result = [db executeUpdate:sql];
            if (!result) {
                NSLog(@"list表创建失败");
            }
        }];
    }

    if (![self tableExist:kJNDBCategoryTable]) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXIST %@ (CATEGORY_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, CATEGORY_NAME TEXT DEFAULT '', FOREIGN KEY(GROUP_ID) REFERENCES %@(GROUP_ID))", kJNDBCategoryTable, kJNDBGroupTable];
            BOOL result = [db executeUpdate:sql];
            if (!result) {
                NSLog(@"list表创建失败");
            }
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