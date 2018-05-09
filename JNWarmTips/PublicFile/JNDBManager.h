//
// Created by fengtianyu on 7/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;

@interface JNDBManager : NSObject
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@end