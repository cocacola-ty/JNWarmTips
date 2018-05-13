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

@implementation JNDBManager (Events)

- (NSArray<JNEventModel *> *) getAllEventsOfDay:(NSString *)day {
    
    NSMutableArray *result = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT EVENT_ID, CONTENT, START_TIME, END_TIME FROM %@ WHERE SHOW_DATA = '%@'", kJNDBEventsTable, day];
    [self.dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
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

@end
