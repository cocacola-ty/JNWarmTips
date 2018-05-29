//
// Created by fengtianyu on 28/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JNItemModel : NSObject
@property(nonatomic, assign) NSInteger itemId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *showDate;
@property(nonatomic, assign) long long startTime;
@property(nonatomic, assign) long long endTime;
@property(nonatomic, assign) NSInteger groupId;
@property(nonatomic, assign) NSInteger categoryId;
@property(nonatomic, assign) BOOL finished;
@property(nonatomic, assign) BOOL notification;

@end