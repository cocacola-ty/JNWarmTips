//
// Created by fengtianyu on 22/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNAlertAssistant.h"
#import "UIColor+Extension.h"


@implementation JNAlertAssistant

+ (void) alertWarningInfo:(NSString *)warningInfo {

    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;

    UIView *alertView = [UIView new];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 5;
    alertView.layer.shadowColor = [UIColor blackColor].CGColor;
    alertView.layer.shadowOffset = CGSizeMake(0, 0);
    alertView.layer.shadowOpacity = 0.6;
    [keyWindow addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(keyWindow.mas_centerX);
        make.centerY.equalTo(keyWindow.mas_centerY);
    }];


    UIImageView *iconImageView = [UIImageView new];
    iconImageView.image = [UIImage imageNamed:@"warning_icon"];
    [alertView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alertView.mas_left).offset(10);
        make.width.height.mas_equalTo(32);
        make.top.equalTo(alertView.mas_top).offset(8);
        make.bottom.equalTo(alertView.mas_bottom).offset(-8);
    }];

    UILabel *infoLabel = [UILabel new];
    infoLabel.textColor = [UIColor colorWithRed:105/ 255.0 green:105/ 255.0 blue:105/ 255.0 alpha:0.8];
    infoLabel.font = [UIFont systemFontOfSize:16.0];
    infoLabel.text = warningInfo;
    [alertView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(10);
        make.centerY.equalTo(iconImageView.mas_centerY);
        make.right.equalTo(alertView.mas_right).offset(-12);
    }];

    [UIView animateWithDuration:0.25 animations:^{

    }completion:^(BOOL complete){

    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertView removeFromSuperview];
    });

}

+ (void) alertDoneMessage:(NSString *)message {

    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;

    UIView *alertView = [UIView new];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 8;
    alertView.layer.shadowColor = [UIColor colorWithHexString:@"9c9c9c"].CGColor;
    alertView.layer.shadowOffset = CGSizeMake(0, 0);
    alertView.layer.shadowOpacity = 0.3;
    [keyWindow addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(keyWindow.mas_centerX);
        make.centerY.equalTo(keyWindow.mas_centerY);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(100);
    }];

    UIView *iconView = [UIView new];
    [alertView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(32);
        make.top.equalTo(alertView.mas_top).offset(15);
        make.centerX.equalTo(alertView.mas_centerX);
    }];

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(8, 20)];
    [path addLineToPoint:CGPointMake(16, 28)];
    [path addLineToPoint:CGPointMake(28, 8)];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 2;
//    [iconView.layer addSublayer:shapeLayer];

    UILabel *infoLabel = [UILabel new];
    infoLabel.textColor = [UIColor blackColor];
    infoLabel.font = [UIFont fontWithName:@"HannotateSC-W5" size:14.0];
    infoLabel.text = message;
    [alertView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView.mas_centerX);
        make.top.equalTo(iconView.mas_bottom).offset(15);
    }];

    alertView.alpha = 0;
    alertView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.25 animations:^{
        alertView.alpha = 1;
        alertView.transform = CGAffineTransformIdentity;
    }completion:^(BOOL complete){
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 0.75;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [shapeLayer addAnimation:pathAnimation forKey:@""];
        [iconView.layer addSublayer:shapeLayer];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertView removeFromSuperview];
        });
    }];

}

@end