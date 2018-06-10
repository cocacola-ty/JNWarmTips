//
// Created by fengtianyu on 10/6/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JNCalendarAssistant : NSObject
@property (nonatomic, strong) NSCalendar *calendar;
@property(nonatomic, assign, readonly) int currentMonth;

+ (instancetype) shareInstance;
- (NSDateComponents *) getCurrentDay;
@end