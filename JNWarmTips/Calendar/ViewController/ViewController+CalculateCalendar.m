//
// Created by fengtianyu on 17/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "ViewController+CalculateCalendar.h"
#import "JNDayModel.h"
#import "JNWarmTipsPublicFile.h"
#import "JNDBManager.h"
#import "JNDBManager+Events.h"


@implementation ViewController (CalculateCalendar)

- (NSMutableArray<JNDayModel *> *) getAllDaysOfMonth:(int)month InYear:(int)year{
    /*
     * 检查缓存中是否有，如果没有日算对应月份所有日期
     */
    NSString *key = [JNWarmTipsPublicFile dateStringFormat:year month:month day:0];
    id value = [self.cacheList objectForKey:key];
    if (value) {
        return nil;
    }

    NSArray *allEventsDate = [[JNDBManager shareInstance] getAllEventsDate];
    NSLog(@"allEventsDate = %@", allEventsDate);
    NSCalendar *calendar = [NSCalendar currentCalendar];

    // 获取本月1号是周几
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *firstDayStr = [JNWarmTipsPublicFile dateStringFormat:year month:month day:1];
    NSDate *firstDay = [dateFormatter dateFromString:firstDayStr];
    NSDateComponents *weekComponents = [calendar components:NSCalendarUnitWeekday fromDate:firstDay];
    int firstDayInWeek = (int)weekComponents.weekday;

    // 获取当前月有多少天
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:firstDay];

    // 获取上一个月有多少天
    int lastMonthInt = month - 1;
    int lastMonthInYear = year;
    if (month == 1) {
        lastMonthInYear = year - 1;
        lastMonthInt = 12;
    }
    NSString *lastMonthStr = [JNWarmTipsPublicFile dateStringFormat:lastMonthInYear month:lastMonthInt day:1];
    NSDate *lastMonth = [dateFormatter dateFromString:lastMonthStr];
    NSRange lastMonthRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:lastMonth];
    int daysOflastMonth = (int)lastMonthRange.length;

    // 排列本月所有日期
    NSMutableArray *days = [NSMutableArray array];
    // 需要显示的上个月的天数
    for (int index = 1; index < firstDayInWeek; index++) {
        JNDayModel *dayModel = [JNDayModel new];
        dayModel.day =  (daysOflastMonth - firstDayInWeek + index + 1);
        dayModel.month = lastMonthInt;
        dayModel.year =  lastMonthInYear;
        dayModel.needShowFlag = [allEventsDate containsObject:[JNWarmTipsPublicFile dateStringFormat:dayModel.year month:dayModel.month day:dayModel.day]];
        dayModel.isCurrentMonth = NO;
        dayModel.isCurrentMonth = NO;
        dayModel.isToday = NO;
        [days addObject:dayModel];
    }
    // 本月的天数
    for (int i = 1; i <= range.length; i++) {
        JNDayModel *dayModel = [JNDayModel new];
        dayModel.day = i;
        dayModel.month = month;
        dayModel.year = year;
        dayModel.needShowFlag = [allEventsDate containsObject:[JNWarmTipsPublicFile dateStringFormat:dayModel.year month:dayModel.month day:dayModel.day]];
        dayModel.isCurrentMonth = YES;
        dayModel.isToday = (i == self.currentDay && month == self.currentMonth && year == self.currentYear);
        [days addObject:dayModel];
    }
    // 下个月的天数
    int nextMonthInt = month + 1;
    int nextMonthInYear = year;
    if (month == 12) {
        nextMonthInt = 1;
        nextMonthInYear = year + 1;
    }
    if (days.count < 42) {
        NSInteger nextDays = 42 - days.count;
        for (int i = 1; i <= nextDays; i++) {
            JNDayModel *dayModel = [JNDayModel new];
            dayModel.day = i;
            dayModel.month = nextMonthInt;
            dayModel.year = nextMonthInYear;
            dayModel.needShowFlag = [allEventsDate containsObject:[JNWarmTipsPublicFile dateStringFormat:dayModel.year month:dayModel.month day:dayModel.day]];
            dayModel.isCurrentMonth = NO;
            [days addObject:dayModel];
        }

    }
    return days;
}

- (NSString *) getLastMonth:(int)currentMonth currentYear:(int)currentYear{

    int lastMonth = currentMonth - 1;
    int lastYear = currentYear;
    if (currentMonth == 1) {
        lastMonth = 12;
        lastYear = currentYear - 1;
    }

    return [JNWarmTipsPublicFile dateStringFormat:lastYear month:lastMonth day:0];
}

- (NSString *) getNextMonth:(int)currentMonth currentYear:(int)currentYear{

    int nextMonth = currentMonth + 1;
    int nextYear = currentYear;

    if (currentMonth == 12) {
        nextMonth = 1;
        nextYear = currentYear + 1;
    }
    return [JNWarmTipsPublicFile dateStringFormat:nextYear month:nextMonth day:0];

}
@end
