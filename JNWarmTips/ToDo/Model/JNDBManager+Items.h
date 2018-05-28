//
// Created by fengtianyu on 28/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JNDBManager.h"

@interface JNDBManager (Items)
- (NSArray *) getAllItemsByShowDate:(NSString *)showDate;
- (NSArray *) getAllDateSection ;
@end