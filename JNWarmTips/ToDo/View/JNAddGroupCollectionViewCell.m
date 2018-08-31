//
// Created by fengtianyu on 31/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNAddGroupCollectionViewCell.h"
#import "JNWarmTipsPublicFile.h"
#import "UIColor+Extension.h"

static const int kDefaultMargin = 20;

@interface JNAddGroupCollectionViewCell()
@property (nonatomic, strong) UIView *containerView;
@end

@implementation JNAddGroupCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.contentView.backgroundColor = RANDOM_COLOR;
        [self.contentView addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(kDefaultMargin);
            make.right.equalTo(self.contentView.mas_right).offset(-kDefaultMargin);
            make.top.equalTo(self.contentView.mas_top).offset(kDefaultMargin);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kDefaultMargin);
        }];
    }
    return self;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 4;

        _containerView.layer.shadowColor = GRAY_TEXT_COLOR.CGColor;
        _containerView.layer.shadowOpacity = 0.3;
        _containerView.layer.shadowOffset = CGSizeMake(0, 2);

        CGFloat containerWidth = self.frame.size.width - kDefaultMargin * 2;
        CGFloat containerHeight = self.frame.size.height- kDefaultMargin * 2;
        CGFloat centerY = containerHeight / 2;
        CGFloat centerX = containerWidth / 2;
        CGFloat length = 20;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(centerX - length, centerY)];
        [path addLineToPoint:CGPointMake(centerX + length, centerY)];
        [path moveToPoint:CGPointMake(centerX, centerY - length)];
        [path addLineToPoint:CGPointMake(centerX, centerY + length)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [UIColor colorWithHexString:@"9c9c9c"].CGColor;
        shapeLayer.lineWidth = 3;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineJoin = kCALineJoinRound;

        [_containerView.layer addSublayer:shapeLayer];
    }
    return _containerView;
}

@end