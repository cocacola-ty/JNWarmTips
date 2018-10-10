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
@end

@implementation JNMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView *menuView = [UIView new];
    menuView.backgroundColor = [UIColor colorWithHexString:@"ADD8E6"];
    menuView.alpha = 0.8;
    menuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:menuView];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, SCREEN_HEIGHT)];
    [path addLineToPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    [path addLineToPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT - 30)];
    [path addQuadCurveToPoint:CGPointMake(SCREEN_WIDTH/2 - 30, 0) controlPoint:CGPointMake(SCREEN_WIDTH/2-40, (SCREEN_HEIGHT)-200)];
    [path closePath];
    maskLayer.path = path.CGPath;
    maskLayer.fillColor = [UIColor redColor].CGColor;
    
    menuView.layer.mask = maskLayer;
    
    menuView.transform = CGAffineTransformMakeTranslation(-SCREEN_WIDTH, 0);
    [UIView animateWithDuration:0.5 delay:1.25 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
        menuView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
}

@end
