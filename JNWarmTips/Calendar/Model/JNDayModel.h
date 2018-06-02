//
// Created by fengtianyu on 10/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JNDayModel : NSObject
@property (nonatomic, assign) int day;
@property (nonatomic, assign) int month;
@property (nonatomic, assign) int year;
@property(nonatomic, assign) BOOL needShowFlag;
@property(nonatomic, assign) BOOL isCurrentMonth;
@property(nonatomic, assign) BOOL isToday;
@end
