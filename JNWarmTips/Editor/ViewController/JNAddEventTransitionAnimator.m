//
// Created by fengtianyu on 4/7/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNAddEventTransitionAnimator.h"
#import "JNWarmTipsPublicFile.h"

@interface JNAddEventTransitionAnimator() <CAAnimationDelegate>
@property(nonatomic, assign) JNTransitionType transitionType;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation JNAddEventTransitionAnimator {
}

- (instancetype) initWithType:(JNTransitionType) transitionType {
    self = [super init];
    if (self) {
        self.transitionType = transitionType;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.transitionType == JNTransitionTypePresent) {
        [self presentTransition:transitionContext];
    } else if(self.transitionType == JNTransitionTypeDismiss) {
        [self dismissTransition:transitionContext];
    }
}

- (void) presentTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;

    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];

    [containerView addSubview:toView];

    // 起始位置 和 发布按钮位置一致

    CGFloat startX = SCREEN_WIDTH - 20 - 30; // 20右侧边距 30发布按钮宽度一半
    CGFloat startY = SCREEN_HEIGHT - 49 - 60 - 30;
    CGRect startRect = CGRectMake(startX, startY, 1, 1);
    CGFloat radius = sqrt(SCREEN_WIDTH * SCREEN_WIDTH + SCREEN_HEIGHT * SCREEN_HEIGHT);
    CGRect endRect = CGRectInset(startRect, -radius, -radius);
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:startRect];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor redColor].CGColor;
    maskLayer.path = startPath.CGPath;
    toView.layer.mask = maskLayer;

    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.fromValue = (__bridge id __nullable )(startPath.CGPath);
    basicAnimation.toValue = (__bridge id __nullable) (endPath.CGPath);
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.duration = 0.5;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.delegate = self;
    [maskLayer addAnimation:basicAnimation forKey:nil];

}

- (void) dismissTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;

    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    toView = toVc.view;
    UIView *containerView = [transitionContext containerView];

    [containerView addSubview:toView];
    toView.layer.opacity = 0;

    [UIView animateWithDuration:0.35 animations:^{
        toView.layer.opacity = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.transitionContext completeTransition:YES];
}

@end