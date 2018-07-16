//
// Created by fengtianyu on 1/7/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNButtonTagView.h"
#import "JNWarmTipsPublicFile.h"


static const int kCircleViewWH = 6;

static const int kDefaultLeftMargin = 5;

static const int kDefaultInsets = 2;

@interface JNButtonTagView()
@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIView *borderView;

@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end

@implementation JNButtonTagView {
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.circleView];
        self.circleView.layer.cornerRadius = kCircleViewWH / 2;
        [self addSubview:self.borderView];
        [self.borderView addSubview:self.textLabel];

    }
    return self;
}

- (CGSize) setupTagName:(NSString *)tagName AndColor:(UIColor *)tagColor {

    CGRect rect = [tagName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:nil attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];

    CGFloat titleLabelW = ceilf(rect.size.width);
    CGFloat titleLabelH = ceilf([UIFont systemFontOfSize:14.0].lineHeight) + kDefaultInsets * 2;

    CGFloat titleLabelX =  titleLabelH / 2 + kDefaultInsets;  // label的x为箭头的宽度加一个边距

    CGFloat borderViewW = titleLabelX + titleLabelW + kDefaultInsets * 2; // border的宽度 = label的宽加左右留白

    CGFloat width = borderViewW + kCircleViewWH + kDefaultLeftMargin;

    return  [self setupTagName:tagName AndColor:tagColor WithWidth:width];

}

- (CGSize) setupTagName:(NSString *)tagName AndColor:(UIColor *)tagColor WithWidth:(CGFloat)width {
    self.selectColor = tagColor;

    self.circleView.backgroundColor = tagColor;
    self.textLabel.text = tagName;

    CGFloat fontHeight = ceilf([UIFont systemFontOfSize:14.0].lineHeight);
    CGFloat borderViewH = fontHeight + kDefaultInsets * 2;
    CGFloat borderViewW = width - kCircleViewWH - kDefaultLeftMargin;
    CGFloat arrowWidth = borderViewH / 2;  // 箭头的宽度

    CGFloat titleLabelH = borderViewH;
    CGFloat titleLabelX = arrowWidth + kDefaultInsets;
    CGFloat titleLabelW = borderViewW - titleLabelX - kDefaultInsets - kDefaultInsets;  // 左边间距为 margin + inset 右边间距为 inset + inset

    self.bounds = CGRectMake(0, 0, width, borderViewH);
    self.textLabel.frame = CGRectMake(titleLabelX, 0, titleLabelW, titleLabelH);
    self.borderView.frame = CGRectMake(kDefaultLeftMargin + kCircleViewWH, 0, borderViewW, borderViewH);
    self.circleView.frame = CGRectMake(0, borderViewH / 2 - kCircleViewWH / 2, kCircleViewWH, kCircleViewWH);

    self.textLabel.textAlignment = NSTextAlignmentCenter;

    UIBezierPath *borderPath = [UIBezierPath bezierPath];
    [borderPath moveToPoint:CGPointMake(0, borderViewH / 2)];
    [borderPath addLineToPoint:CGPointMake(arrowWidth, 0)];
    [borderPath addLineToPoint:CGPointMake(borderViewW, 0)];
    [borderPath addLineToPoint:CGPointMake(borderViewW, borderViewH)];
    [borderPath addLineToPoint:CGPointMake(arrowWidth, borderViewH)];
    [borderPath closePath];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    self.shapeLayer = shapeLayer;
    shapeLayer.path = borderPath.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = GRAY_TEXT_COLOR.CGColor;
    shapeLayer.lineWidth = 1;
    shapeLayer.borderColor = [UIColor redColor].CGColor;
    [self.borderView.layer addSublayer:shapeLayer];
    [self addScaleAnimation];

    return CGSizeMake(width, borderViewH);
}

- (void) addScaleAnimation {
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    basicAnimation.fromValue = [NSNumber numberWithFloat:1.2];
    basicAnimation.toValue = [NSNumber numberWithFloat:0.6];
    basicAnimation.duration = 0.7;
    basicAnimation.autoreverses = YES;
    basicAnimation.repeatCount = MAXFLOAT;
    [self.circleView.layer addAnimation:basicAnimation forKey:nil];
}

#pragma mark - Getter & Setter

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.textLabel.textColor = self.selectColor;
        self.shapeLayer.strokeColor = self.selectColor.CGColor;
    } else {
        self.textLabel.textColor = GRAY_TEXT_COLOR;
        self.shapeLayer.strokeColor = GRAY_TEXT_COLOR.CGColor;
    }
}

- (UIView *)circleView {
    if (!_circleView) {
        _circleView = [UIView new];
        _circleView.userInteractionEnabled = NO;
    }
    return _circleView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:14.0];
        _textLabel.textColor = GRAY_TEXT_COLOR;
    }
    return _textLabel;
}

- (UIView *)borderView {
    if (!_borderView) {
        _borderView = [UIView new];
        _borderView.userInteractionEnabled = NO;
    }
    return _borderView;
}

@end