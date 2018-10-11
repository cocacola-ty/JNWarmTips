//
//  JNMenuViewController.m
//  JNWarmTips
//
//  Created by fengtianyu on 10/10/2018.
//  Copyright © 2018 fengtianyu. All rights reserved.
//

#import "JNMenuViewController.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import "JNWarmTipsPublicFile.h"

@interface JNMenuViewController ()
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) UIBezierPath *fromPath;
@end

@implementation JNMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView *menuView = [UIView new];
    self.menuView = menuView;
    menuView.backgroundColor = [UIColor colorWithHexString:@"F08080"];
    menuView.alpha = 0.9;
    menuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:menuView];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    self.fromPath = path;
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, SCREEN_HEIGHT)];
    [path addLineToPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    [path addLineToPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT - 30)];
    [path addQuadCurveToPoint:CGPointMake(SCREEN_WIDTH/2 - 30, 0) controlPoint:CGPointMake(SCREEN_WIDTH/2-40, (SCREEN_HEIGHT)-200)];
    [path closePath];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    self.maskLayer = maskLayer;
    maskLayer.path = path.CGPath;
    maskLayer.fillColor = [UIColor redColor].CGColor;
    
    menuView.layer.mask = maskLayer;
    
    menuView.transform = CGAffineTransformMakeTranslation(-SCREEN_WIDTH, 0);
    [UIView animateWithDuration:kAnimationDuration delay:1.25 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
        menuView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
}

static CFTimeInterval const kAnimationDuration = 0.1;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
    
    self.view.userInteractionEnabled = NO;
    
    // 第一阶段动画
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, SCREEN_HEIGHT)];
    [path addLineToPoint:CGPointMake(100, SCREEN_HEIGHT)];
    [path addLineToPoint:CGPointMake(100, SCREEN_HEIGHT)];
    [path addQuadCurveToPoint:CGPointMake(SCREEN_WIDTH/2 - 30, 0) controlPoint:CGPointMake(SCREEN_WIDTH/2-40, (SCREEN_HEIGHT)-200)];
    [path closePath];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.toValue = (__bridge id _Nullable)(path.CGPath);
    animation.duration = kAnimationDuration;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.maskLayer addAnimation:animation forKey:nil];
    
    // 第二阶段动画
    UIBezierPath *secondPath = [UIBezierPath bezierPath];
    [secondPath moveToPoint:CGPointMake(0, 0)];
    [secondPath addLineToPoint:CGPointMake(0, SCREEN_HEIGHT)];
    [secondPath addLineToPoint:CGPointMake(0, SCREEN_HEIGHT)];
    [secondPath addLineToPoint:CGPointMake(0, SCREEN_HEIGHT)];
    [secondPath addQuadCurveToPoint:CGPointMake(SCREEN_WIDTH / 4, 0) controlPoint:CGPointMake(100, 150)];
    
    CABasicAnimation *secAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    secAnimation.toValue = (__bridge id _Nullable)secondPath.CGPath;
    secAnimation.beginTime = CACurrentMediaTime() + kAnimationDuration;
    secAnimation.duration = kAnimationDuration;
    secAnimation.fillMode = kCAFillModeForwards;
    secAnimation.removedOnCompletion = NO;
    [self.maskLayer addAnimation:secAnimation forKey:nil];
    
    [UIView animateWithDuration:0.1 delay:kAnimationDuration*2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.menuView.transform = CGAffineTransformMakeTranslation(-SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        
    }];
    
    /*
    // 第三阶段动画
    UIBezierPath *thirdPath = [UIBezierPath bezierPath];
    [thirdPath moveToPoint:CGPointMake(0, 0)];
    [thirdPath addLineToPoint:CGPointMake(0, 100)];
    [thirdPath addLineToPoint:CGPointMake(0, 100)];
    [thirdPath addLineToPoint:CGPointMake(0, 100)];
    [thirdPath addQuadCurveToPoint:CGPointMake(40, 0) controlPoint:CGPointMake(30, 70)];
    
    CABasicAnimation *thirdAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    thirdAnimation.toValue = (__bridge id _Nullable)thirdPath.CGPath;
    thirdAnimation.beginTime = CACurrentMediaTime() + kAnimationDuration * 2;
    thirdAnimation.duration = kAnimationDuration;
    thirdAnimation.fillMode = kCAFillModeForwards;
    thirdAnimation.removedOnCompletion = NO;
//    [self.maskLayer addAnimation:thirdAnimation forKey:nil];
   
    UIBezierPath *finalPath = [UIBezierPath bezierPath];
    [finalPath moveToPoint:CGPointMake(0, 0)];
    [finalPath addLineToPoint:CGPointMake(0, 5)];
    [finalPath addLineToPoint:CGPointMake(0, 5)];
    [finalPath addLineToPoint:CGPointMake(0, 5)];
    [finalPath addQuadCurveToPoint:CGPointMake(3, 0) controlPoint:CGPointMake(1, 2)];
    
    CABasicAnimation *finalAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    finalAnimation.toValue = (__bridge id _Nullable)finalPath.CGPath;
    finalAnimation.beginTime = CACurrentMediaTime() + kAnimationDuration * 3;
    finalAnimation.duration = 0.15;
    finalAnimation.fillMode = kCAFillModeForwards;
    finalAnimation.removedOnCompletion = NO;
//    [self.maskLayer addAnimation:finalAnimation forKey:nil];
     */
}
@end
