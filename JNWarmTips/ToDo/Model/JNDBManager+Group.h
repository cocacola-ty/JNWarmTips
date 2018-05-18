//
// Created by fengtianyu on 18/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JNDBManager.h"

@class JNGroupModel;

@interface JNDBManager (Group)
- (NSArray<JNGroupModel *> *)getAllGroups;
@end