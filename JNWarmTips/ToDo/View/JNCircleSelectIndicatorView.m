//
// Created by fengtianyu on 22/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNCircleSelectIndicatorView.h"
#import "JNWarmTipsPublicFile.h"
#import "UIColor+Extension.h"

static const int kCircleViewWh = 14;

@interface JNCircleSelectIndicatorView() {
    CGFloat kInnerCircleWH;
}
@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UIView *innerCircleView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation JNCircleSelectIndicatorView 

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    kInnerCircleWH = kCircleViewWh / 2;
    if (self) {
        [self addSubview:self.circleView];
        [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left);
            make.width.height.mas_equalTo(kCircleViewWh);
        }];

        [self.circleView addSubview:self.innerCircleView];
        [self.innerCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.circleView.mas_centerX);
            make.centerY.equalTo(self.circleView.mas_centerY);
            make.width.height.mas_equalTo(kInnerCircleWH);
        }];

        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.circleView.mas_right).offset(10);
            make.right.equalTo(self.mas_right);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor colorWithHexString:@"222222"];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        _titleLabel.text = @"添加分类";
    }
    return _titleLabel;
}

- (UIView *)circleView {
    if (!_circleView) {
        _circleView = [UIView new];
        _circleView.layer.cornerRadius = kCircleViewWh / 2;
        _circleView.layer.borderWidth = 1;
        _circleView.layer.borderColor = GRAY_TEXT_COLOR.CGColor;
        _circleView.backgroundColor = [UIColor clearColor];
    }
    return _circleView;
}

- (UIView *)innerCircleView {
    if (!_innerCircleView) {
        _innerCircleView = [UIView new];
        _innerCircleView.backgroundColor = MAIN_COLOR;
        _innerCircleView.layer.cornerRadius = kInnerCircleWH / 2;
    }
    return _innerCircleView;
}
@end