//
// Created by fengtianyu on 10/6/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNCalendarAssistant.h"


@implementation JNCalendarAssistant {

}
@synthesize currentMonth = _currentMonth;
@synthesize currentDay = _currentDay;
@synthesize currentYear = _currentYear;

- (instancetype) init {
    self = [super init];
    if (self) {
        NSDateComponents *dateComponents = [self getCurrentDay];
        _currentMonth = dateComponents.month;
        _currentDay = dateComponents.day;
        _currentYear = dateComponents.year;
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

- (NSInteger) getFirstDayInWeek {

}

#pragma mark - Getter & Setter

- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
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