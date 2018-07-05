//
// Created by fengtianyu on 4/7/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger , JNTransitionType) {
    JNTransitionTypePresent,
    JNTransitionTypeDismiss,
};

@interface JNAddEventTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithType:(JNTransitionType)transitionType;

@end