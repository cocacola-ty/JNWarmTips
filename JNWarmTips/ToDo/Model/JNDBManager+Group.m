//
// Created by fengtianyu on 18/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNDBManager+Group.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "JNGroupModel.h"


@implementation JNDBManager (Group)

- (NSArray<JNGroupModel *> *)getAllGroups {

    NSMutableArray *resultArray = [NSMutableArray array];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where deleted = 0", kJNDBGroupTable];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            JNGroupModel *model = [JNGroupModel new];
            model.groupName = [resultSet stringForColumn:@"group_name"];
            model.groupId = [resultSet stringForColumn:@"group_id"];
            model.firstItemContent = [resultSet stringForColumn:@"GROUP_FIRST_CONTENT"];
            model.itemCount = [resultSet intForColumn:@"GROUP_ITEM_COUNT"];
            [resultArray addObject:model];
        }
    }];
    return resultArray;
}

- (BOOL) addGroup:(JNGroupModel *)groupModel {
    __block BOOL result;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        long long timestamp = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(GROUP_ID, GROUP_NAME, update_time) VALUES(%@, '%@', %lli)", kJNDBGroupTable, groupModel.groupId, groupModel.groupName, timestamp];
        result = [db executeUpdate:sql];

        if (!result) {
            *rollback = YES;
        }
    }];
    return result;
}

- (void)deleteGroup:(JNGroupModel *)groupModel {
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {

        // 删除所有属于这个小组的事项
        NSString *deleteItemsSql = [NSString stringWithFormat:@"update %@ set deleted = 1 where group_id = %@", kJNDBListTable, groupModel.groupId];
        [db executeUpdate:deleteItemsSql];

        // 删除所有属于这个小组的分类
        NSString *deleteCategorySql = [NSString stringWithFormat:@"update %@ set deleted = 1 where group_id='%@'", kJNDBCategoryTable, groupModel.groupId];
        [db executeUpdate:deleteCategorySql];

        NSString *deleteGroupSql = [NSString stringWithFormat:@"update %@ set deleted = 1 where group_id = '%@'", kJNDBGroupTable, groupModel.groupId];
        [db executeUpdate:deleteGroupSql];
    }];
}

@end
