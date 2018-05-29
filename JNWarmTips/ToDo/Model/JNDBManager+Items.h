//
// Created by fengtianyu on 28/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JNDBManager.h"

@class JNItemModel;

@interface JNDBManager (Items)
/*获取指定小组内指定日期下的所有item*/
- (NSArray *)getAllItemsByShowDate:(NSString *)showDate WithGroupId:(NSString *)groupId ;
/*获取指定小组的所有日期分类*/
- (NSArray *) getAllDateSectionInGroup:(NSString *)groupId ;

- (void) addItem:(JNItemModel *)itemModel ;
- (void) updateFinishStatus:(BOOL) finished withItemId:(NSInteger)itemId ;
@end