//
// Created by fengtianyu on 10/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JNDayModel : NSObject
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger year;
@property(nonatomic, assign) BOOL needShowFlag;
@property(nonatomic, assign) BOOL isCurrentMonth;
@property(nonatomic, assign) BOOL isToday;
@end
