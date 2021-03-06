//
// Created by fengtianyu on 28/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JNDBManager.h"

@class JNItemModel;

@interface JNDBManager (Items)

/*添加一个分类*/
- (void)addCategory:(NSString *)categoryName InGroup:(NSString *)groupId;

- (void) addItem:(JNItemModel *)itemModel ;

/*获取小组内所有已经创建的分类*/
- (NSArray *)getAllCategoryInGroup:(NSString *)groupId;

/*获取该小组内的所有含有事项的分类*/
- (NSArray *)getAllSectionsInGroup:(NSString *)groupId;

/*获取该小组内所有的事项*/
- (NSMutableDictionary<NSString *, NSMutableArray<JNItemModel *> *> *)getAllItemsInGroup:(NSString *)groupId;

- (void) updateFinishStatus:(BOOL) finished withItemId:(long long)itemId ;

/*删除一条item*/
- (void) deleteItem:(long long)itemId ;

@end;
