//
// Created by fengtianyu on 18/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNDBManager+Group.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "JNGroupModel.h"


@implementation JNDBManager (Group)

- (NSArray *)getAllGroups {

    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select t1.group_id, t1.group_name, t2.content from %@ as t1, %@ as t2, (select max(item_id) as id, group_id from %@ group by group_id) as temp where temp.id=t2.item_id and t1.group_id=temp.group_id", kJNDBGroupTable,kJNDBListTable,kJNDBListTable];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            JNGroupModel *model = [JNGroupModel new];
            model.groupName = [resultSet stringForColumn:@"group_name"];
            model.groupId = [resultSet stringForColumn:@"group_id"];
        }
    }];
}
@end