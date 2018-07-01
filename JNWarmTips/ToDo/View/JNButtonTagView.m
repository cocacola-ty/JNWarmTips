//
// Created by fengtianyu on 1/7/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNButtonTagView.h"
#import "JNWarmTipsPublicFile.h"


static const int kCircleViewWH = 4;

@interface JNButtonTagView()
@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UIButton *button;
@end

@implementation JNButtonTagView {
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.circleView];
        [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(kCircleViewWH);
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left);
        }];
        self.circleView.layer.cornerRadius = kCircleViewWH / 2;

        [self addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.circleView.mas_right).offset(5);
            make.centerY.equalTo(self.circleView.mas_centerY);
        }];

        // test
        [self setupTagName:@"  个人" AndColor:[UIColor redColor]];
    }
    return self;
}

- (void) setupTagName:(NSString *)tagName AndColor:(UIColor *)tagColor {

    [self.button setTitle:tagName forState:UIControlStateNormal];
    self.circleView.backgroundColor = tagColor;

    // 设置button样式
    self.button.layer.borderWidth = 1;
    self.button.layer.borderColor = [[UIColor redColor] CGColor];

}

- (UIView *)circleView {
    if (!_circleView) {
        _circleView = [UIView new];
    }
    return _circleView;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton new];
        _button.titleLabel.textColor = [UIColor blackColor];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_button setTitleColor:GRAY_TEXT_COLOR forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:10.0];
    }
    return _button;
}

@end