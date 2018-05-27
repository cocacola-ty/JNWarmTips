//
// Created by fengtianyu on 27/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

/*当前转场类型 present / dismiss */
typedef NS_OPTIONS(NSInteger , JNPresentTransitionType) {
    JNPresentTransitionTypePresent = 0,
    JNPresentTransitionTypeDismiss = 1,
};

@interface JNPresentTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
- (instancetype)initWithType:(JNPresentTransitionType)type ;
@end