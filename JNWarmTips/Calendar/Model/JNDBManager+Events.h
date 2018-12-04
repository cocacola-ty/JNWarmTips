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


/**
 获取某天的所有事件
 */
- (NSArray<JNEventModel *> *) getAllEventsOfDay:(NSString *)day;

/**
 获取所有含有事件的日期
 */
- (NSArray<NSString *> *)getAllEventsDate ;

/**
 获取所有含有事件的日期及该事件的颜色
 */
- (NSDictionary *)getAllDateAndEventColor;

/**
 获取按照时间排序后的所有事件
 */
- (NSArray<JNEventModel *> *)getAllSortEvents;


/**
 获取所有未和服务端同步的数据
 */
- (NSMutableArray *) getAllUnSynchronizeEvents;

/**
 删除事件
 */
- (void)deleteEvent:(long long)eventId;

/**
 添加事件
 */
- (void)addEventContent:(nonnull NSString *)content AndShowDate:(nonnull NSString *)showDate AndEventTypeId:(NSString *)eventTypeId AndEventColor:(NSString *)color;

- (void)addEventWithModel:(JNEventModel *)eventModel;

/**
 获取所有事件类型
 */
- (NSArray *)getAllEventTypes ;

/**
 删除垃圾数据
 */
- (void)deleteRubbishData;
@end
