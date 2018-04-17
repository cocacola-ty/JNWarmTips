//
// Created by fengtianyu on 17/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "ViewController+CalculateCalendar.h"
#import "JNDayModel.h"


@implementation ViewController (CalculateCalendar)

- (NSMutableArray *) getAllDaysOfMonth:(NSInteger)month InYear:(NSInteger)year{

    NSCalendar *calendar = [NSCalendar currentCalendar];

    // 获取本月1号是周几
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *firstDayStr = [NSString stringWithFormat:@"%ld-%ld-01",year,month];
    NSLog(@"%@",firstDayStr);
    NSDate *firstDay = [dateFormatter dateFromString:firstDayStr];
    NSDateComponents *weekComponents = [calendar components:NSCalendarUnitWeekday fromDate:firstDay];
    NSInteger firstDayInWeek = weekComponents.weekday;
    NSLog(@"weekComponents = %ld", weekComponents.weekday);

    // 获取当前月有多少天
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:firstDay];
    NSLog(@"range = %ld", range.length);

    // 获取上一个月有多少天
    NSInteger lastMonthInt = month - 1;
    NSInteger lastMonthInYear = year;
    if (month == 1) {
        lastMonthInYear = year - 1;
        lastMonthInt = 12;
    }
    NSString *lastMonthStr = [NSString stringWithFormat:@"%ld-%ld-01", lastMonthInYear, lastMonthInt];
    NSDate *lastMonth = [dateFormatter dateFromString:lastMonthStr];
    NSRange lastMonthRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:lastMonth];
    NSInteger daysOflastMonth = lastMonthRange.length;
    NSLog(@"lastMonthRange = %ld", lastMonthRange.length);

    // 排列本月所有日期
    NSMutableArray *days = [NSMutableArray array];
    // 需要显示的上个月的天数
    for (int index = 1; index < firstDayInWeek; index++) {
        JNDayModel *dayModel = [JNDayModel new];
        dayModel.day = [NSString stringWithFormat:@"%ld", (daysOflastMonth - firstDayInWeek + index + 1)];
        dayModel.month = [NSString stringWithFormat:@"%ld",lastMonthInt];
        dayModel.year = [NSString stringWithFormat:@"%ld", lastMonthInYear];
        dayModel.needShowFlag = NO;
        dayModel.isCurrentMonth = NO;
        dayModel.isCurrentMonth = NO;
        dayModel.isToday = NO;
        [days addObject:dayModel];
    }
    // 本月的天数
    for (int i = 1; i <= range.length; i++) {
        JNDayModel *dayModel = [JNDayModel new];
        dayModel.day = [NSString stringWithFormat:@"%i", i];
        dayModel.month = [NSString stringWithFormat:@"%ld", month];
        dayModel.year = [NSString stringWithFormat:@"%ld", year];
        dayModel.needShowFlag = NO;
        dayModel.isCurrentMonth = YES;
        dayModel.isToday = (i == self.currentDay && month == self.currentMonth && year == self.currentYear);
        [days addObject:dayModel];
    }
    // 下个月的天数
    NSInteger nextMonthInt = month + 1;
    NSInteger nextMonthInYear = year;
    if (month == 12) {
        nextMonthInt = 1;
        nextMonthInYear = year + 1;
    }
    if (days.count < 35) {
        NSInteger nextDays = 35 - days.count;
        for (int i = 1; i <= nextDays; i++) {
            JNDayModel *dayModel = [JNDayModel new];
            dayModel.day = [NSString stringWithFormat:@"%i", i];
            dayModel.month = [NSString stringWithFormat:@"%ld", nextMonthInt];
            dayModel.year = [NSString stringWithFormat:@"%ld", nextMonthInYear];
            dayModel.needShowFlag = NO;
            dayModel.isCurrentMonth = NO;
            [days addObject:dayModel];
        }

    }
    return days;
}

- (void) getLastMonth {

}

- (void) getNextMonth {

}
@end