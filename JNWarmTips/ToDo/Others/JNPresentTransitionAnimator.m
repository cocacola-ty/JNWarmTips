//
// Created by fengtianyu on 27/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNPresentTransitionAnimator.h"
#import "JNToDoGroupListViewController.h"
#import "JNToDoListViewController.h"
#import "JNWarmTipsPublicFile.h"
#import "View+MASAdditions.h"


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
    return 0.7;
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
    // 拿到转场前后的两个控制器
     UITabBarController *fromVcs = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
     JNToDoGroupListViewController *fromVc= fromVcs.childViewControllers.lastObject;
    JNToDoListViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    // 拿到转场之后的界面，并将大小和位置设置为和转场前的cell一样

    UITableViewCell *cell = [fromVc.tableView cellForRowAtIndexPath:fromVc.currentSelectIndexPath];
    UIView *contentView = cell.subviews.firstObject;
    UIView *realCellView = contentView.subviews.firstObject;
    CGRect realFrame = [contentView convertRect:realCellView.frame toView:fromVc.tableView];

    toVc.view.hidden = YES;

    // 做一个和转场前cell一样的视图
    UIView *animateView = [UIView new];
    animateView.layer.cornerRadius = 8;
    animateView.layer.masksToBounds = YES;
    animateView.backgroundColor = [UIColor whiteColor];
    animateView.frame = realFrame;

    UIImageView *topView = [UIImageView new];
    [animateView addSubview:topView];
    topView.contentMode = UIViewContentModeScaleAspectFill;
    topView.layer.masksToBounds = YES;
    topView.image = fromVc.cellBackGroundImage;
    topView.frame = CGRectMake(0, 0, realFrame.size.width, 70);

    // 拿到执行转场动画的容器视图
    UIView *containerView = [transitionContext containerView];
    // 将转场开始时视图添加到容器中
    [containerView addSubview:animateView];
    // 将转场结束后的视图添加到容器中
    [containerView addSubview:toVc.view];

    CGFloat endWidth = SCREEN_WIDTH - 16;
    CGFloat endHeight = SCREEN_HEIGHT - 140;
    [UIView animateWithDuration:0.4 animations:^{
        animateView.frame = CGRectMake(8, 70, endWidth, endHeight);
        topView.frame = CGRectMake(0, 0, endWidth, 100);
    } completion:^(BOOL finished) {
        toVc.view.hidden = NO;
        [transitionContext completeTransition:YES];

        /*
        animateView.backgroundColor = [UIColor clearColor];

        UIBezierPath *endPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, endWidth, endHeight)];
        UIBezierPath *startPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 0, endHeight)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = animateView.bounds;
        layer.path = startPath.CGPath;
        layer.fillColor = [UIColor greenColor].CGColor;
        animateView.layer.mask = layer;

        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.beginTime = CACurrentMediaTime();
        animation.fromValue = [NSValue valueWithPointer:startPath.CGPath];
        animation.toValue = [NSValue valueWithPointer:endPath.CGPath];
        animation.fillMode = kCAFillModeForwards;
        animation.duration = 0.3;
        animation.removedOnCompletion = NO;
        [layer addAnimation:animation forKey:@"maskAnimation"];

        dispatch_after(0.3, dispatch_get_main_queue(), ^{
            [transitionContext completeTransition:YES];
        });
         */
    }];

}

/*当dismiss时候的转场动画*/
- (void) dismissTransion:(id <UIViewControllerContextTransitioning>)transitionContext  {

}

@end