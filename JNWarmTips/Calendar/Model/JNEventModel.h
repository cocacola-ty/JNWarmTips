//
//  JNEventModel.h
//  JNWarmTips
//
//  Created by 冯天宇 on 2018/5/13.
//  Copyright © 2018年 fengtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNEventModel : NSObject

@property (nonatomic,assign) long long eventId;
@property (nonatomic,strong) NSString *showDate;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,assign) long long startTime;
@property (nonatomic,assign) long long endTime;
@property (nonatomic, strong) NSString *eventTypeId;
@property (nonatomic, strong) NSString *color;
@property(nonatomic, assign) BOOL needNotification;
@property(nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) long long updateTime;

@end
