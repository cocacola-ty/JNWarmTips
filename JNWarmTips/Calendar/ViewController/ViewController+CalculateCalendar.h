//
// Created by fengtianyu on 17/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

@interface ViewController (CalculateCalendar)
- (NSMutableArray *) getAllDaysOfMonth:(NSInteger)month InYear:(NSInteger)year;
- (NSString *) getLastMonth:(NSInteger)currentMonth currentYear:(NSInteger)currentYear;
- (NSString *) getNextMonth:(NSInteger)currentMonth currentYear:(NSInteger)currentYear;
@end