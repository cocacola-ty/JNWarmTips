//
// Created by fengtianyu on 18/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JNDBManager.h"

@class JNGroupModel;

@interface JNDBManager (Group)
- (NSArray<JNGroupModel *> *)getAllGroups;

/*添加小组到数据库*/
- (BOOL) addGroup:(JNGroupModel *)groupModel;

/*删除小组*/
- (void)deleteGroup:(JNGroupModel *)groupModel;
@end