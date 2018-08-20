//
// Created by fengtianyu on 28/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDatabase.h>
#import "JNDBManager+Items.h"
#import "JNItemModel.h"


@implementation JNDBManager (Items)

- (NSArray *)getAllItemsByShowDate:(NSString *)showDate WithGroupId:(NSString *)groupId {

    NSString *date = showDate == nil ? @"NULL" : [NSString stringWithFormat:@"'%@'", showDate];
    NSString *condition = @"";
    if (![groupId isEqualToString:@"0"]) {
        condition = [NSString stringWithFormat:@" and group_id = %@ ", groupId];
    }
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where show_date = %@%@", kJNDBListTable, date, condition];

    NSMutableArray *result = [NSMutableArray array];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            JNItemModel *itemModel = [JNItemModel new];
            itemModel.itemId = [resultSet intForColumn:@"item_id"];
            itemModel.content = [resultSet stringForColumn:@"content"];
            itemModel.finished = [resultSet boolForColumn:@"finished"];
            [result addObject:itemModel];
        }
    }];
    return result;
}

- (NSArray *) getAllDateSectionInGroup:(NSString *)groupId {
    NSString *condition = @"";
    if (![groupId isEqualToString:@"0"]) {
        condition = [NSString stringWithFormat:@"where group_id = %@ ", groupId];
    }
    NSString *sql = [NSString stringWithFormat:@"select show_date, count(show_date) as count from %@ %@group by show_date order by show_date", kJNDBListTable, condition];
    NSMutableArray *result = [NSMutableArray array];

    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            NSString *sectionName = [resultSet stringForColumn:@"show_date"];
            NSString *showName = sectionName.length == 0 ? @"未分类" : sectionName;
            NSInteger count = [resultSet intForColumn:@"count"];
            NSDictionary *dict = @{
                    @"name" : sectionName,
                    @"showName" : showName,
                    @"count": @(count)
            };
            [result addObject:dict];
        }
    }];
    return result;
}

/*获取该小组内的所有分类*/
- (NSArray *)getAllSectionsInGroup:(NSString *)groupId {

    NSMutableArray *result = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where groupId = %@", kJNDBCategoryTable, groupId];

    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *resultSet = [db executeQuery:sql];
    }];
    return result;
}

- (void) addItem:(JNItemModel *)itemModel {

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:itemModel.startTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    NSString *show_date = (itemModel.startTime == 0) ? @"''" : dateString;
    NSString *startTime = (itemModel.startTime == 0) ? @"NULL" : [NSString stringWithFormat:@"%lld", itemModel.startTime];
    NSString *endTime = (itemModel.endTime == 0) ? @"NULL" : [NSString stringWithFormat:@"%lld", itemModel.endTime];
    NSString *groupId = [NSString stringWithFormat:@"%lld", itemModel.groupId];
    NSString *notification = [NSString stringWithFormat:@"%d", itemModel.notification];
    NSString *finish = [NSString stringWithFormat:@"%d", itemModel.finished];

    NSString *sql = [NSString stringWithFormat:@"insert into %@(content, show_date, start_time, end_time, group_id, NOTIFICATION, finished) values ('%@', %@, %@, %@, %@, %@, %@)", kJNDBListTable, itemModel.content, show_date, startTime, endTime, groupId, notification, finish];
    NSString *updateGroupSql = [NSString stringWithFormat:@"update %@ set group_first_content = '%@' where group_id='%@'", kJNDBGroupTable, itemModel.content, groupId];

    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:sql];
        [db executeUpdate:updateGroupSql];
    }];
}

- (void) updateFinishStatus:(BOOL) finished withItemId:(long long)itemId {
    NSString *sql = [NSString stringWithFormat:@"update %@ set finished = %d where item_id = %lld", kJNDBListTable, finished, itemId];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:sql];
    }];
}

- (void) deleteItem:(long long)itemId {
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where item_id = %lld", kJNDBListTable, itemId];

    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:sql];
    }];
}
@end
