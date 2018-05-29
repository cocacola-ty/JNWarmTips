//
// Created by fengtianyu on 27/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNPresentTransitionAnimator.h"
#import "JNToDoGroupListViewController.h"
#import "JNToDoListViewController.h"
#import "JNWarmTipsPublicFile.h"
#import "View+MASAdditions.h"
#import "JNGroupModel.h"


static const double kAnimationDuration = 0.4;

static const int kTopImageViewExpansionHeight = 100;

static const int kTopImageViewReduceHeight = 70;

static const int kExpansionLeftAndRightMargin = 8;

static const int kExpansionTopAndBottomMargin = 70;

static const int kCornerRadius = 8;

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
    return kAnimationDuration;
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
    animateView.layer.cornerRadius = kCornerRadius;
    animateView.layer.masksToBounds = YES;
    animateView.backgroundColor = [UIColor whiteColor];
    animateView.frame = realFrame;

    UIImageView *topImageView = [UIImageView new];
    [animateView addSubview:topImageView];
    topImageView.contentMode = UIViewContentModeScaleAspectFill;
    topImageView.layer.masksToBounds = YES;
    topImageView.image = fromVc.cellBackGroundImage;
    topImageView.frame = CGRectMake(0, 0, realFrame.size.width, kTopImageViewReduceHeight);

    UILabel *titleLabel = [UILabel new];
    titleLabel.text = toVc.groupModel.groupName;
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    titleLabel.center = CGPointMake(realFrame.size.width / 2, kTopImageViewReduceHeight/2);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    [topImageView addSubview:titleLabel];


    // 拿到执行转场动画的容器视图
    UIView *containerView = [transitionContext containerView];
    // 将转场结束后的视图添加到容器中
   [containerView addSubview:toVc.view];
    // 将转场开始时视图添加到容器中
    [containerView addSubview:animateView];

    CGFloat endWidth = SCREEN_WIDTH - kExpansionLeftAndRightMargin * 2;
    CGFloat endHeight = SCREEN_HEIGHT - kExpansionTopAndBottomMargin * 2;

    [UIView animateWithDuration:kAnimationDuration animations:^{
        animateView.frame = CGRectMake(kExpansionLeftAndRightMargin, kExpansionTopAndBottomMargin, endWidth, endHeight);
        topImageView.frame = CGRectMake(0, 0, endWidth, kTopImageViewExpansionHeight);
        titleLabel.center = CGPointMake(endWidth / 2, kTopImageViewExpansionHeight/2);
    } completion:^(BOOL finished) {
        toVc.view.hidden = NO;
        [animateView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];

}

/*当dismiss时候的转场动画*/
- (void) dismissTransion:(id <UIViewControllerContextTransitioning>)transitionContext  {

    CGFloat expansionWidth = SCREEN_WIDTH - kExpansionLeftAndRightMargin * 2;
    CGFloat expansionHeight = SCREEN_HEIGHT - kExpansionTopAndBottomMargin * 2;

    // 拿到转场前后的两个控制器
    JNToDoListViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UITabBarController *toVcs = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    JNToDoGroupListViewController *toVc = toVcs.childViewControllers.lastObject;

    // 拿到要缩放到的cell
    UITableViewCell *cell = [toVc.tableView cellForRowAtIndexPath:toVc.currentSelectIndexPath];
    UIView *contentView = cell.subviews.firstObject;
    UIView *realCellView = contentView.subviews.firstObject;
    CGRect endFrame = [contentView convertRect:realCellView.frame toView:toVc.tableView];
    CGFloat reduceWidth = endFrame.size.width;

    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = GRAY_BACKGROUND_COLOR;

    UIView *animationView = [UIView new];
    animationView.layer.cornerRadius = kCornerRadius;
    animationView.layer.masksToBounds = YES;
    animationView.backgroundColor = [UIColor whiteColor];
    animationView.frame = CGRectMake(kExpansionLeftAndRightMargin, kExpansionTopAndBottomMargin, expansionWidth, expansionHeight);
    [containerView addSubview:animationView];

    UIImageView *topImageView = [UIImageView new];
    topImageView.frame = CGRectMake(0, 0, expansionWidth, kTopImageViewExpansionHeight);
    topImageView.image = toVc.cellBackGroundImage;
    topImageView.contentMode = UIViewContentModeScaleAspectFill;
    topImageView.layer.masksToBounds = YES;
    [animationView addSubview:topImageView];

    fromVc.view.hidden = YES;

    [UIView animateWithDuration:kAnimationDuration animations:^{
        animationView.frame = endFrame;
        topImageView.frame = CGRectMake(0, 0, reduceWidth, kTopImageViewReduceHeight);
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];

}
@end