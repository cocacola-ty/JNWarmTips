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
@end