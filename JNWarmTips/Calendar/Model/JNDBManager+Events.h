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
@end