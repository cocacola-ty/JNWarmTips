//
// Created by fengtianyu on 28/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JNItemModel : NSObject
@property(nonatomic, assign) NSInteger itemId;
/*事件内容*/
@property (nonatomic, strong) NSString *content;
/*开始时间 默认值 0*/
@property(nonatomic, assign) long long startTime; // 默认值
/*事件结束时间 默认值 0*/
@property(nonatomic, assign) long long endTime;
/*事件所属小组 必填*/
@property(nonatomic, assign) long long groupId;
/*事件所属分类 默认值 -100*/
@property(nonatomic, assign) NSInteger categoryId;
/*事件所属分类名 默认值 未分类*/
@property(nonatomic, strong) NSString *categoryName;
/*事件是否完成*/
@property(nonatomic, assign) BOOL finished;
/*事件是否需要提醒*/
@property(nonatomic, assign) BOOL notification;

@end
