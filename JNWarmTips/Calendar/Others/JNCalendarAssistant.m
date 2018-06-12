//
// Created by fengtianyu on 10/6/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNCalendarAssistant.h"
#import "JNWarmTipsPublicFile.h"

@interface JNCalendarAssistant()
@property (nonatomic, strong) NSMutableDictionary *cacheFirstDayInWeek;
/*缓存每个月的天数*/
@property (nonatomic, strong) NSMutableDictionary *cacheCountOfDays;
/*缓存距离当前日期n个月的日期*/
@property (nonatomic, strong) NSMutableDictionary<NSArray *, NSString *> *cacheAwayMonth;
@end

@implementation JNCalendarAssistant {

}
@synthesize currentMonth = _currentMonth;
@synthesize currentDay = _currentDay;
@synthesize currentYear = _currentYear;
@synthesize currentDateStr = _currentDateStr;
@synthesize currentDate = _currentDate;

- (instancetype) init {
    self = [super init];
    if (self) {
        NSDateComponents *dateComponents = [self getCurrentDay];
        _currentMonth = dateComponents.month;
        _currentDay = dateComponents.day;
        _currentYear = dateComponents.year;
        _currentDateStr = [JNWarmTipsPublicFile dateStringFormat:_currentYear month:_currentMonth day:_currentDay];
        [self getDateAwayCurrentDate:-10];
    }
    return self;
}

+ (instancetype) shareInstance {
    static JNCalendarAssistant *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSDateComponents *) getCurrentDay {
    NSDate *date = [NSDate date];
    NSDateComponents *dateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    return dateComponents;
}

- (NSInteger) getMonthFirstDayInWeek:(int)month InYear:(int)year {

    NSString *firstDayStr = [JNWarmTipsPublicFile dateStringFormat:year month:month day:1];
    id cacheResult = [self.cacheFirstDayInWeek valueForKey:firstDayStr];

    if (!cacheResult) {
        // 如果没有缓存 计算并缓存
        NSDate *firstDay = [self.dateFormatter dateFromString:firstDayStr];
        // 获取该日期是一周的第几天 周日为第一天
        NSDateComponents *weekComponents = [self.calendar components:NSCalendarUnitWeekday fromDate:firstDay];
        int result = (int)weekComponents.weekday;
        [self.cacheFirstDayInWeek setValue:@(result) forKey:firstDayStr];
        return result;
    } else {
        // 直接返回缓存
        return [cacheResult intValue];
    }
}

- (int) getCountOfDayInMonth:(int)month InYear:(int)year {
    NSString *firstDayStr = [JNWarmTipsPublicFile dateStringFormat:year month:month day:1];
    id cacheResult = [self.cacheCountOfDays valueForKey:firstDayStr];
    if (cacheResult) {
        return [cacheResult intValue];
    } else {
        NSDate *date = [self.dateFormatter dateFromString:firstDayStr];
        NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
        [self.cacheCountOfDays setValue:@(range.length) forKey:firstDayStr];
        return range.length;
    }
}

- (NSArray *) getDateAwayCurrentDate:(int)awayLength {

    NSString *key = [NSString stringWithFormat:@"%d", awayLength];
    NSArray *cacheResult = [self.cacheAwayMonth valueForKey:key];
    if (cacheResult) {
        return cacheResult;
    } else {
        NSDateComponents *adComponents = [[NSDateComponents alloc] init];
        [adComponents setYear:0];
        [adComponents setMonth:awayLength];
        [adComponents setDay:0];

        NSDate *dateResult = [self.calendar dateByAddingComponents:adComponents toDate:[NSDate date] options:0];
        NSDateComponents *dateComponents = [self.calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateResult];
        int month = dateComponents.month;
        int year = dateComponents.year;

        NSArray *result = @[@(year), @(month)];

        [self.cacheAwayMonth setValue:result forKey:key];

        return result;
    }

}

#pragma mark - Getter & Setter

- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}

- (NSMutableDictionary *)cacheFirstDayInWeek {
    if (!_cacheFirstDayInWeek) {
        _cacheFirstDayInWeek = [NSMutableDictionary dictionary];
    }
    return _cacheFirstDayInWeek;
}

- (NSMutableDictionary *)cacheCountOfDays {
    if (!_cacheCountOfDays) {
        _cacheCountOfDays = [NSMutableDictionary dictionary];
    }
    return _cacheCountOfDays;
}

- (NSMutableDictionary *)cacheAwayMonth {
    if (!_cacheAwayMonth) {
        _cacheAwayMonth = [NSMutableDictionary dictionary];
    }
    return _cacheAwayMonth;
}

- (int)currentMonth {
    return _currentMonth;
}

- (int)currentDay {
    return _currentDay;
}

- (int)currentYear {
    return _currentYear;
}

@end