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
//        NSString *sql = [NSString stringWithFormat:@"select t1.group_id, t1.group_name, t2.content, temp.count from %@ as t1, %@ as t2, (select max(item_id) as id, group_id, sum(group_id) as count from %@ group by group_id) as temp where temp.id=t2.item_id and t1.group_id=temp.group_id", kJNDBGroupTable,kJNDBListTable,kJNDBListTable];
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
@end