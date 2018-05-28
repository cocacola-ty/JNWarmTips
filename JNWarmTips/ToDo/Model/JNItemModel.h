//
// Created by fengtianyu on 28/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JNItemModel : NSObject
@property(nonatomic, assign) NSInteger itemId;
@property (nonatomic, strong) NSString *content;
@property(nonatomic, assign) BOOL finished;

@end