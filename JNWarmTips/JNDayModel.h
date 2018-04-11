//
// Created by fengtianyu on 10/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JNDayModel : NSObject
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *year;
@property(nonatomic, assign) BOOL isCurrentDay;
@property(nonatomic, assign) BOOL needShowFlag;
@property(nonatomic, assign) BOOL isCurrentMonth;
@property(nonatomic, assign) BOOL isToday;
@end