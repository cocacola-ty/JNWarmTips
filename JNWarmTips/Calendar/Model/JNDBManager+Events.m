//
//  JNDBManager+Events.m
//  JNWarmTips
//
//  Created by 冯天宇 on 2018/5/13.
//  Copyright © 2018年 fengtianyu. All rights reserved.
//

#import "JNDBManager+Events.h"
#import "JNDBManager.h"
#import "FMDB.h"
#import "JNEventModel.h"
#import "JNEventTypeModel.h"

@implementation JNDBManager (Events)

- (NSArray<NSString *> *)getAllEventsDate {

    NSMutableArray *result = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"select show_date from %@", kJNDBEventsTable];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            NSString *date = [resultSet stringForColumnIndex:0];
            [result addObject:date];
        }
    }];
    return result;
}
- (NSArray<JNEventModel *> *)getAllSortEvents {

    NSString *sql = [NSString stringWithFormat:@"select * from %@ order by show_date", kJNDBEventsTable];
    NSMutableArray *result = [NSMutableArray array];

    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *queryResult = [db executeQuery:sql];
        while ([queryResult next]) {
            JNEventModel *eventModel = [JNEventModel new];
            eventModel.eventId = [queryResult longLongIntForColumn:@"event_id"];
            eventModel.content = [queryResult stringForColumn:@"CONTENT"];
            eventModel.startTime = [queryResult longLongIntForColumn:@"START_TIME"];
            eventModel.endTime = [queryResult longLongIntForColumn:@"END_TIME"];
            eventModel.showDate = [queryResult stringForColumn:@"SHOW_DATE"];
        }
    }];
    return result;
}

- (NSArray<JNEventModel *> *)getAllEventsOfDay:(NSString *)day {

    NSMutableArray *result = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT EVENT_ID, CONTENT, START_TIME, END_TIME FROM %@ WHERE SHOW_DATE = '%@'", kJNDBEventsTable, day];
    [self.dbQueue inTransaction:^(FMDatabase *_Nonnull db, BOOL *_Nonnull rollback) {
        FMResultSet *queryResult = [db executeQuery:sql];
        while ([queryResult next]) {
            JNEventModel *eventModel = [JNEventModel new];
            eventModel.eventId = [queryResult longLongIntForColumn:@"EVENT_ID"];
            eventModel.content = [queryResult stringForColumn:@"CONTENT"];
            eventModel.startTime = [queryResult longLongIntForColumn:@"START_TIME"];
            eventModel.endTime = [queryResult longLongIntForColumn:@"END_TIME"];
            eventModel.showDate = day;
            [result addObject:eventModel];
        };

    }];
    return result;
}

- (void) deleteEvent:(long long)eventId {
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where event_id = '%lld'", kJNDBEventsTable, eventId];
        [db executeUpdate:sql];
    }];
}

#pragma mark - 查询事件类型

- (NSArray *)getAllEventTypes {
    NSString *sql = [NSString stringWithFormat:@"select * from %@", kJNDBEventTypeTable];
    NSMutableArray *result = [NSMutableArray array];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            JNEventTypeModel *eventTypeModel = [JNEventTypeModel new];
            eventTypeModel.typeName = [resultSet stringForColumn:@"event_type_name"];
            eventTypeModel.typeId = [resultSet stringForColumn:@"event_type_id"];
            eventTypeModel.typeColor = [resultSet stringForColumn:@"color"];
            [result addObject:eventTypeModel];
        }
    }];
    return result;

}

#pragma mark - 添加事件

- (void)addEventContent:(nonnull NSString *)content AndShowDate:(nonnull NSString *)showDate {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@('CONTENT', 'SHOW_DATE') VALUES('%@', '%@')", kJNDBEventsTable, content, showDate];
    [self addEvent:sql];
}

- (void)addEventContent:(nonnull NSString *)content AndShowDate:(nonnull NSString *)showDate AndStartTime:(long long)startTime AndEndTime:(long long)endTime AndNotification:(BOOL)notification AndFinished:(BOOL)finished {
    NSString *sql = [NSString stringWithFormat:@""];
    [self addEvent:sql];
}

- (void)addEvent:(NSString *)sql {
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:sql];
    }];
}


@end

