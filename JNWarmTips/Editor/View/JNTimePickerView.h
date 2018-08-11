//
// Created by fengtianyu on 3/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger , JNTimeType) {
    JNTimeTypeDuration = 1,
    JNTimeTypeTime = 2,
};

@interface JNTimePickerView : UIView

- (void)changeType:(JNTimeType)type;

@property(nonatomic, copy) void (^closeBlock)();
@property(nonatomic, copy) void (^doneBlock)(NSString *startTime, NSString *endTiem);
@end