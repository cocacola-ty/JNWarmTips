//
// Created by fengtianyu on 5/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNAddEventCellView.h"
#import "UIColor+Extension.h"
#import "JNWarmTipsPublicFile.h"


static const int kLeftMargin = 35;

@interface JNAddEventCellView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation JNAddEventCellView

- (instancetype)initWithTitle:(NSString *)title WithIconImageName:(NSString *)imageName {
    self = [super init];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.bottomLine];
        [self addSubview:self.iconImageView];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left).offset(kLeftMargin);
        }];

        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left).offset(kLeftMargin);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(1);
        }];

        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(20);
            make.left.equalTo(self.mas_left);
            make.centerY.equalTo(self.mas_centerY);
        }];

        self.titleLabel.text = title;
        self.iconImageView.image = [UIImage imageNamed:imageName];
    }
    return self;
}

#pragma mark - Getter & Setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _titleLabel.textColor = [UIColor colorWithHexString:@"c8c8c8"];
        _titleLabel.textColor = MAIN_COLOR;
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = GRAY_BACKGROUND_COLOR;
    }
    return _bottomLine;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}
@end