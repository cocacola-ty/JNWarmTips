//
// Created by fengtianyu on 28/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDatabase.h>
#import "JNDBManager+Items.h"
#import "JNItemModel.h"


@implementation JNDBManager (Items)

- (void)addCategory:(NSString *)categoryName InGroup:(NSString *)groupId {

    NSString *sql = [NSString stringWithFormat:@"insert into %@ (category_name, group_id) values ('%@', %@)", kJNDBCategoryTable, categoryName, groupId];

    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:sql];
    }];
}

- (NSArray *)getAllCategoryInGroup:(NSString *)groupId {
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where group_id = %@", kJNDBCategoryTable, groupId];
    NSMutableArray *result = [NSMutableArray array];

    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            NSString *categoryName = [resultSet stringForColumn:@"category_name"];
            NSString *categoryId = [resultSet stringForColumn:@"category_id"];
            NSDictionary *dict = @{
                    @"categoryName" : categoryName,
                    @"categoryId" : categoryId
            };
            [result addObject:dict];
        }
    }];
    return result;
}

/*获取该小组内的所有分类*/
- (NSArray *)getAllSectionsInGroup:(NSString *)groupId {
    NSMutableArray *result = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"select category_id, category_name from %@ where group_id = %@ group by category_id", kJNDBListTable, groupId];

    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *resultSet = [db executeQuery:sql];

        while ([resultSet next]) {
            NSString *categoryName = [resultSet stringForColumn:@"category_name"];
            NSString *categoryId = [resultSet stringForColumn:@"category_id"];
            if (categoryId != nil && categoryName != nil) {
                NSDictionary *dict = @{
                        @"categoryName" : categoryName,
                        @"categoryId" : categoryId
                };
                [result addObject:dict];
            }
        };
    }];
    return result;
}

#pragma mark - Item Method

- (NSMutableDictionary<NSString *, NSMutableArray<JNItemModel *> *> *)getAllItemsInGroup:(NSString *)groupId {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where group_id = %@", kJNDBListTable, groupId];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            JNItemModel *itemModel = [JNItemModel new];
            itemModel.itemId = [resultSet intForColumn:@"item_id"];
            itemModel.content = [resultSet stringForColumn:@"content"];
            itemModel.groupId = [resultSet longLongIntForColumn:@"group_id"];
            itemModel.categoryId = [resultSet intForColumn:@"category_id"];
            itemModel.categoryName = [resultSet stringForColumn:@"category_name"];
            itemModel.startTime = [resultSet longLongIntForColumn:@"start_time"];
            itemModel.notification = [resultSet boolForColumn:@"notification"];
            itemModel.finished = [resultSet boolForColumn:@"finished"];

            if ([[result allKeys] containsObject:itemModel.categoryName]) {
                NSMutableArray *list = [result valueForKey:itemModel.categoryName];
                [list addObject:itemModel];
            } else {
                NSMutableArray *list = [NSMutableArray array];
                [list addObject:itemModel];
                [result setValue:list forKey:itemModel.categoryName];
            }
        }
    }];
    return result;
}

- (void) addItem:(JNItemModel *)itemModel {

    NSString *startTime = [NSString stringWithFormat:@"%lld", itemModel.startTime];
    NSString *endTime = [NSString stringWithFormat:@"%lld", itemModel.endTime];
    NSString *groupId = [NSString stringWithFormat:@"%lld", itemModel.groupId];
    NSString *notification = [NSString stringWithFormat:@"%d", itemModel.notification];
    NSString *finish = [NSString stringWithFormat:@"%d", itemModel.finished];
    NSString *categoryId = [NSString stringWithFormat:@"%d", itemModel.categoryId];

    NSString *sql = [NSString stringWithFormat:@"insert into %@(content, start_time, end_time, group_id, category_id, category_name, notification, finished) values ('%@', %@, %@, %@, %@, '%@', %@, %@)", kJNDBListTable, itemModel.content, startTime, endTime, groupId, categoryId, itemModel.categoryName, notification, finish];
    NSString *updateGroupSql = [NSString stringWithFormat:@"update %@ set group_first_content = '%@' where group_id='%@'", kJNDBGroupTable, itemModel.content, groupId];

    NSLog(@"sql = %@", sql);
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
