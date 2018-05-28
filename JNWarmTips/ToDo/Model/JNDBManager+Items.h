//
// Created by fengtianyu on 28/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JNDBManager.h"

@class JNItemModel;

@interface JNDBManager (Items)
- (NSArray *) getAllItemsByShowDate:(NSString *)showDate;
- (NSArray *) getAllDateSection ;
- (void) addItem:(JNItemModel *)itemModel ;
- (void) updateFinishStatus:(BOOL) finished withItemId:(NSInteger)itemId ;
@end