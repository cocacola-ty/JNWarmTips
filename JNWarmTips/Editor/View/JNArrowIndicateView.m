//
// Created by fengtianyu on 30/7/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNArrowIndicateView.h"
#import "UIColor+Extension.h"

static const int kTimeIndicateWH = 22;  // 是否显示事件视图指示器的宽高

static const double kAnimationDuration = 0.35;

@interface JNArrowIndicateView()
@property (nonatomic, strong) UIBezierPath *timeIndicateBeginPath;
@property (nonatomic, strong) UIBezierPath *timeIndicateEndPath;
@property (nonatomic, strong) CAShapeLayer *timeIndicateLayer;
@end

@implementation JNArrowIndicateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.timeIndicateLayer];
    }
    return self;
}

- (void)setArrowColor:(UIColor *)arrowColor {
    _arrowColor = arrowColor;
    self.timeIndicateLayer.strokeColor = arrowColor.CGColor;
}

- (CAShapeLayer *)timeIndicateLayer {
    if (!_timeIndicateLayer) {
        _timeIndicateLayer = [CAShapeLayer layer];
        _timeIndicateLayer.path =self.timeIndicateBeginPath.CGPath;
        _timeIndicateLayer.lineWidth = 2;
        _timeIndicateLayer.strokeColor = [UIColor colorWithHexString:@"919191"].CGColor;
        _timeIndicateLayer.fillColor = [UIColor clearColor].CGColor;
        _timeIndicateLayer.lineCap = kCALineCapRound;
        _timeIndicateLayer.lineJoin = kCALineJoinRound;
    }
    return _timeIndicateLayer;
}

- (UIBezierPath *)timeIndicateBeginPath {
    if (!_timeIndicateBeginPath) {
        _timeIndicateBeginPath = [UIBezierPath bezierPath];
        CGFloat length = 6;  // 三角形的高为3
        CGFloat baseX = kTimeIndicateWH / 2;  // 基准点X坐标
        CGFloat baseY = kTimeIndicateWH / 2 - length / 2; // 基准点Y坐标
        CGPoint startPoint = CGPointMake(baseX - length, baseY);
        CGPoint vertexPoint = CGPointMake(baseX, baseY + length); // 顶点坐标
        CGPoint endPoint = CGPointMake(baseX + length, baseY);

        [_timeIndicateBeginPath moveToPoint:startPoint];
        [_timeIndicateBeginPath addLineToPoint:vertexPoint];
        [_timeIndicateBeginPath addLineToPoint:endPoint];
    }
    return _timeIndicateBeginPath;
}

- (UIBezierPath *)timeIndicateEndPath {
    if (!_timeIndicateEndPath) {
        _timeIndicateEndPath = [UIBezierPath bezierPath];
        CGFloat length = 6;  // 三角形的高为3
        CGFloat baseX = kTimeIndicateWH / 2;  // 基准点X坐标
        CGFloat baseY = kTimeIndicateWH / 2 + length / 2; // 基准点Y坐标
        CGPoint startPoint = CGPointMake(baseX - length, baseY);
        CGPoint vertexPoint = CGPointMake(baseX, baseY - length); // 顶点坐标
        CGPoint endPoint = CGPointMake(baseX + length, baseY);

        [_timeIndicateEndPath moveToPoint:startPoint];
        [_timeIndicateEndPath addLineToPoint:vertexPoint];
        [_timeIndicateEndPath addLineToPoint:endPoint];
    }
    return _timeIndicateEndPath;
}

- (void)open {
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = kAnimationDuration;
    basicAnimation.fromValue = (__bridge id) self.timeIndicateEndPath.CGPath;
    basicAnimation.toValue = (__bridge id) self.timeIndicateBeginPath.CGPath;
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.removedOnCompletion = NO;
    [self.timeIndicateLayer addAnimation:basicAnimation forKey:nil];
}

- (void)close {
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = kAnimationDuration;
    basicAnimation.fromValue = (__bridge id) self.timeIndicateBeginPath.CGPath;
    basicAnimation.toValue = (__bridge id) self.timeIndicateEndPath.CGPath;
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.removedOnCompletion = NO;
    [self.timeIndicateLayer addAnimation:basicAnimation forKey:nil];
}

@end