//
// Created by fengtianyu on 1/7/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNButtonTagView.h"
#import "JNWarmTipsPublicFile.h"


static const int kCircleViewWH = 4;

static const int kButtonLeftMargin = 12;

static const int kDefaultLeftMargin = 5;

static const int kDefaultInsets = 2;

@interface JNButtonTagView()
@property (nonatomic, strong) UIView *circleView;
//@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *borderView;
@end

@implementation JNButtonTagView {
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.circleView];
        self.circleView.layer.cornerRadius = kCircleViewWH / 2;

        [self addSubview:self.borderView];
        [self.borderView addSubview:self.titleLabel];

        // test
        [self setupTagName:@"个人" AndColor:[UIColor redColor]];
    }
    return self;
}

- (void) setupTagName:(NSString *)tagName AndColor:(UIColor *)tagColor {

    self.circleView.backgroundColor = tagColor;
    self.titleLabel.text = tagName;
    [self.titleLabel sizeToFit];

    CGFloat titleLabelW = self.titleLabel.frame.size.width;
    CGFloat titleLabelH = self.titleLabel.frame.size.height;
    CGFloat titleLabelX = kDefaultLeftMargin + kDefaultInsets;

    CGFloat borderViewH = titleLabelH + kDefaultInsets * 2;
    CGFloat borderViewW = titleLabelX + titleLabelW + kDefaultInsets * 2;

    CGFloat width = borderViewW + kCircleViewWH + kDefaultLeftMargin;

    self.bounds = CGRectMake(0, 0, width, borderViewH);
    self.titleLabel.frame = CGRectMake(titleLabelX, kDefaultInsets, titleLabelW, titleLabelH);
    self.borderView.frame = CGRectMake(kDefaultLeftMargin + kCircleViewWH, 0, borderViewW, borderViewH);
    self.circleView.frame = CGRectMake(0, borderViewH / 2 - kCircleViewWH / 2, kCircleViewWH, kCircleViewWH);

    UIBezierPath *borderPath = [UIBezierPath bezierPath];
    [borderPath moveToPoint:CGPointMake(0, borderViewH / 2)];
    [borderPath addLineToPoint:CGPointMake(kDefaultLeftMargin, 0)];
    [borderPath addLineToPoint:CGPointMake(borderViewW, 0)];
    [borderPath addLineToPoint:CGPointMake(borderViewW, borderViewH)];
    [borderPath addLineToPoint:CGPointMake(kDefaultLeftMargin, borderViewH)];
    [borderPath closePath];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = borderPath.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = GRAY_TEXT_COLOR.CGColor;
    shapeLayer.lineWidth = 1;
    shapeLayer.borderColor = [UIColor redColor].CGColor;
    [self.borderView.layer addSublayer:shapeLayer];

}

- (UIView *)circleView {
    if (!_circleView) {
        _circleView = [UIView new];
    }
    return _circleView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:11.0];
        _titleLabel.textColor = GRAY_TEXT_COLOR;
    }
    return _titleLabel;
}

- (UIView *)borderView {
    if (!_borderView) {
        _borderView = [UIView new];
    }
    return _borderView;
}

@end