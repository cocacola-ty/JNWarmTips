//
// Created by fengtianyu on 1/7/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNButtonTagView.h"
#import "JNWarmTipsPublicFile.h"


static const int kCircleViewWH = 4;

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

        // test
//        [self setupTagName:@"个人" AndColor:[UIColor redColor]];
    }
    return self;
}

- (void) setupTagName:(NSString *)tagName AndColor:(UIColor *)tagColor {
    self.selectColor = tagColor;

    self.circleView.backgroundColor = tagColor;
    self.textLabel.text = tagName;
    [self.textLabel sizeToFit];

    CGFloat titleLabelW = self.textLabel.frame.size.width;
    CGFloat titleLabelH = self.textLabel.frame.size.height;
    CGFloat titleLabelX = kDefaultLeftMargin + kDefaultInsets;

    CGFloat borderViewH = titleLabelH + kDefaultInsets * 2;
    CGFloat borderViewW = titleLabelX + titleLabelW + kDefaultInsets * 2;

    CGFloat width = borderViewW + kCircleViewWH + kDefaultLeftMargin;

    self.bounds = CGRectMake(0, 0, width, borderViewH);
    NSLog(@"width = %f", width);
    NSLog(@"borderViewH = %f", borderViewH);
    self.textLabel.frame = CGRectMake(titleLabelX, kDefaultInsets, titleLabelW, titleLabelH);
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
    self.shapeLayer = shapeLayer;
    shapeLayer.path = borderPath.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = GRAY_TEXT_COLOR.CGColor;
    shapeLayer.lineWidth = 1;
    shapeLayer.borderColor = [UIColor redColor].CGColor;
    [self.borderView.layer addSublayer:shapeLayer];

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
        _textLabel.font = [UIFont systemFontOfSize:12.0];
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