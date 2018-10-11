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
@end

static CFTimeInterval const kAnimationDuration = 0.1;

@implementation JNMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.menuView.layer.mask = self.maskLayer;
    [self.view addSubview:self.menuView];

    // 出场动画
    self.menuView.transform = CGAffineTransformMakeTranslation(-SCREEN_WIDTH, 0);
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.menuView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dealloc {
    NSLog(@"menu vc dealloc");
}

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
        if (self.dissmisBlock) {
            self.dissmisBlock();
        }
    }];

}

#pragma mark - Getter & Setter

- (UIView *)menuView {
    if (!_menuView) {
        _menuView = [UIView new];
        _menuView.backgroundColor = [UIColor colorWithHexString:@"F08080"];
        _menuView.alpha = 0.9;
        _menuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _menuView;
}

- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(0, SCREEN_HEIGHT)];
        [path addLineToPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
        [path addLineToPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT - 30)];
        [path addQuadCurveToPoint:CGPointMake(SCREEN_WIDTH/2 - 30, 0) controlPoint:CGPointMake(SCREEN_WIDTH/2-40, (SCREEN_HEIGHT)-200)];
        [path closePath];
        
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.path = path.CGPath;
        _maskLayer.fillColor = [UIColor redColor].CGColor;
    }
    return _maskLayer;
}

@end
