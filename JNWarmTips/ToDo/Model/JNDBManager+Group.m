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
        NSString *sql = [NSString stringWithFormat:@"select * from %@", kJNDBGroupTable];
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
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(GROUP_NAME) VALUES('%@')", kJNDBGroupTable, groupModel.groupName];
        result = [db executeUpdate:sql];

        if (!result) {
            rollback = YES;
        }
    }];
    return result;
}

- (void)deleteGroup:(JNGroupModel *)groupModel {
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        /*将所有属于该表的item的group_id更新为0*/
        NSString *updateListSql = [NSString stringWithFormat:@"update %@ set group_id='0', CATEGORY_ID=null where group_id = '%@' ", kJNDBListTable, groupModel.groupId];
        [db executeUpdate:updateListSql];

        NSString *deleteCategorySql = [NSString stringWithFormat:@"delete from %@ where group_id='%@'", kJNDBCategoryTable, groupModel.groupId];
        [db executeUpdate:deleteCategorySql];

        NSString *deleteGroupSql = [NSString stringWithFormat:@"delete from %@ where group_id = '%@'", kJNDBGroupTable, groupModel.groupId];
        [db executeUpdate:deleteGroupSql];
    }];
}

@end