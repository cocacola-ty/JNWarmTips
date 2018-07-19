//
// Created by fengtianyu on 19/7/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNSwitchView.h"
#import "JNWarmTipsPublicFile.h"
#import "UIColor+Extension.h"


@interface JNSwitchView()
@property (nonatomic, strong) UIView *circleView;
@property(nonatomic, assign) BOOL once;
@property(nonatomic, assign) CGFloat height;
@end
@implementation JNSwitchView {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _once = NO;
        self.circleView = [UIView new];
        self.circleView.backgroundColor = [UIColor colorWithHexString:@"919191"];
        self.circleView.alpha = 0.8;
        [self addSubview:self.circleView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!_once) {
        _height = self.frame.size.height;
        self.layer.cornerRadius = _height / 2;
        self.layer.borderWidth = 1;
        self.layer.borderColor = MAIN_COLOR.CGColor;
        self.backgroundColor = [UIColor clearColor];

        CGFloat circleViewWH = _height - 6;
        self.circleView.layer.cornerRadius = circleViewWH / 2;
        CGFloat leftMargin = self.on ? self.frame.size.width - circleViewWH - 5 : 5;
        [self.circleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(circleViewWH);
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(leftMargin);
        }];
    }
    _once = YES;
}

- (void)setOn:(BOOL)on {
    _on = on;

    CGFloat circleViewWH = _height - 6;

    self.circleView.layer.cornerRadius = circleViewWH / 2;
    self.layer.cornerRadius = _height / 2;
    if (on) {
        [self.circleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(circleViewWH);
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-5);
        }];

        [UIView animateWithDuration:0.35 animations:^{
            self.circleView.backgroundColor = MAIN_COLOR;
            [self setNeedsDisplay];
            [self layoutIfNeeded];
        }];
    } else {
        [self.circleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(circleViewWH);
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(5);
        }];
        [UIView animateWithDuration:0.35 animations:^{
            self.circleView.backgroundColor = [UIColor colorWithHexString:@"919191"];
            [self setNeedsDisplay];
            [self layoutIfNeeded];
        }];
    }
}

@end