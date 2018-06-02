//
// Created by fengtianyu on 17/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

@interface ViewController (CalculateCalendar)
- (NSMutableArray *) getAllDaysOfMonth:(int)month InYear:(int)year;
- (NSString *) getLastMonth:(int)currentMonth currentYear:(int)currentYear;
- (NSString *) getNextMonth:(int)currentMonth currentYear:(int)currentYear;
@end
