//
// Created by fengtianyu on 27/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNPresentTransitionAnimator.h"


@implementation JNPresentTransitionAnimator {
    JNPresentTransitionType _type;
}

- (instancetype)initWithType:(JNPresentTransitionType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

/*转场动画执行时间*/
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

/*转场动画的动画过程*/
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {

    // 根据当前操作类型执行不同的转场动画
    if (_type == JNPresentTransitionTypePresent) {
        [self presentTransition:transitionContext];

    } else if (_type == JNPresentTransitionTypeDismiss) {
        [self dismissTransion:transitionContext];
    }
}

/*当present时候的转场动画*/
- (void) presentTransition:(id <UIViewControllerContextTransitioning>)transitionContext  {

}

/*当dismiss时候的转场动画*/
- (void) dismissTransion:(id <UIViewControllerContextTransitioning>)transitionContext  {

}

@end