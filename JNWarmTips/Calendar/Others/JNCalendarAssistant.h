//
// Created by fengtianyu on 10/6/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JNCalendarAssistant : NSObject
@property (nonatomic, strong) NSCalendar *calendar;
@property(nonatomic, assign, readonly) int currentMonth;
@property(nonatomic, assign, readonly) int currentDay;
@property(nonatomic, assign, readonly) int currentYear;
@property (nonatomic, strong, readonly) NSString *currentDate;

+ (instancetype) shareInstance;
- (NSDateComponents *) getCurrentDay;
/*获取每月1号在一周的第几天 周日是第一天*/
- (NSInteger) getMonthFirstDayInWeek:(int)month InYear:(int)year;
@end