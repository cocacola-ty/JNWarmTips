//
//  JNDBManager+Events.h
//  JNWarmTips
//
//  Created by 冯天宇 on 2018/5/13.
//  Copyright © 2018年 fengtianyu. All rights reserved.
//

#import "JNDBManager.h"
@class JNEventModel;

@interface JNDBManager (Events)

- (NSArray<JNEventModel *> *) getAllEventsOfDay:(NSString *)day;

/*获取所有有事件的日期*/
- (NSArray<NSString *> *)getAllEventsDate ;

/*获取按照时间排序后的所有事件*/
- (NSArray<JNEventModel *> *)getAllSortEvents;

/*删除事件*/
- (void)deleteEvent:(long long)eventId;

/*添加事件*/
- (void)addEventContent:(nonnull NSString *)content AndShowDate:(nonnull NSString *)showDate ;
@end
