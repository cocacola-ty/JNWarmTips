//
// Created by fengtianyu on 28/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDatabase.h>
#import "JNDBManager+Items.h"
#import "JNItemModel.h"


@implementation JNDBManager (Items)

- (NSArray *) getAllItemsByShowDate:(NSString *)showDate {
    NSString *date = showDate == nil ? @"NULL" : [NSString stringWithFormat:@"'%@'", showDate];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where show_date = %@", kJNDBListTable, date];

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

- (NSArray *) getAllDateSection {
    NSString *sql = [NSString stringWithFormat:@"select show_date, count(show_date) as count from %@ group by show_date order by show_date", kJNDBListTable];
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

- (void) addItem:(JNItemModel *)itemModel {

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:itemModel.startTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    NSString *show_date = (itemModel.startTime == nil || itemModel.startTime == 0) ? @"''" : dateString;
    NSString *startTime = (itemModel.startTime == nil || itemModel.startTime == 0) ? @"NULL" : [NSString stringWithFormat:@"%lld", itemModel.startTime];
    NSString *endTime = (itemModel.endTime == nil || itemModel.endTime == 0) ? @"NULL" : [NSString stringWithFormat:@"%lld", itemModel.endTime];
    NSString *groupId = [NSString stringWithFormat:@"%d", itemModel.groupId];
    NSString *notification = [NSString stringWithFormat:@"%d", itemModel.notification];
    NSString *finish = [NSString stringWithFormat:@"%d", itemModel.finished];

    NSString *sql = [NSString stringWithFormat:@"insert into %@(content, show_date, start_time, end_time, group_id, NOTIFICATION, finished) values ('%@', %@, %@, %@, %@, %@, %@)", kJNDBListTable, itemModel.content, show_date, startTime, endTime, groupId, notification, finish];

    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:sql];
    }];
}

- (void) updateFinishStatus:(BOOL) finished withItemId:(NSInteger)itemId {
    NSString *sql = [NSString stringWithFormat:@"update %@ set finished = %d where item_id = %d", kJNDBListTable, finished, itemId];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:sql];
    }];
}
@end