//
// Created by fengtianyu on 3/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "CAShapeLayer+Extension.h"
#import "UIColor+Extension.h"


@implementation CAShapeLayer (Extension)

+ (CAShapeLayer *) closeLayerWithWidth:(CGFloat)width {

    CGPoint centerPoint = CGPointMake(width/ 2, width / 2);
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
@end