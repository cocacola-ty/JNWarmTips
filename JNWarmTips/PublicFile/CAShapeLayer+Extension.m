//
// Created by fengtianyu on 3/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "CAShapeLayer+Extension.h"
#import "UIColor+Extension.h"


@implementation CAShapeLayer (Extension)

+ (CAShapeLayer *)closeLayerWithWidth:(CGFloat)width {

    CGPoint centerPoint = CGPointMake(width / 2, width / 2);
    CGFloat step = 5;
    CGPoint point1 = CGPointMake(centerPoint.x - step, centerPoint.y - step);
    CGPoint point2 = CGPointMake(centerPoint.x + step, centerPoint.y + step);
    CGPoint point3 = CGPointMake(centerPoint.x - step, centerPoint.y + step);
    CGPoint point4 = CGPointMake(centerPoint.x + step, centerPoint.y - step);

    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:point1];
    [bezierPath addLineToPoint:point2];
    [bezierPath moveToPoint:point3];
    [bezierPath addLineToPoint:point4];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor colorWithHexString:@"C4c4c4"].CGColor;
    shapeLayer.lineWidth = 2;

    return shapeLayer;
}

+ (CAShapeLayer *)rightLayerWithWidth:(CGFloat)width WithHeight:(CGFloat)height {

    CGFloat midX = width / 2;
    CGFloat midY = height / 2;
    CGFloat stepX = width / 5 ;
    CGFloat stepY = height / 5 ;

    CGPoint startPoint = CGPointMake(midX - stepX, midY);
    CGPoint midPoint = CGPointMake(midX, midY + stepY);
    CGPoint endPoint = CGPointMake(midX + stepX, midY - stepY);

    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:startPoint];
    [bezierPath addLineToPoint:midPoint];
    [bezierPath addLineToPoint:endPoint];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.lineWidth = 2;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;

    return shapeLayer;
}
@end