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

@implementation JNDBManager (Events)

- (NSArray *) getAllEventsOfDay:(NSString *)day {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT EVENT_ID, CONTENT, START_TIME, END_TIME FROM %@ WHERE SHOW_DATA = %@", kJNDBEventsTable, day];
    [self.dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        FMResultSet *queryResult = [db executeQuery:sql];
    }];
    return nil;
}

@end
