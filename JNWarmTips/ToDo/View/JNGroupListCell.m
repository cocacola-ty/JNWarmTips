//
// Created by fengtianyu on 6/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNGroupListCell.h"
#import "JNWarmTipsPublicFile.h"
#import "View+MASAdditions.h"

static const int kCircleViewHeight = 14;

@interface JNGroupListCell()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UIView *circleView;
@end

@implementation JNGroupListCell {

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.height.mas_equalTo(70);
        }];

        [self.containerView addSubview:self.bannerImageView];
        [self.bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bannerImageView.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(30);
        }];

        [self.bannerImageView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bannerImageView.mas_centerX);
            make.centerY.equalTo(self.bannerImageView.mas_centerY);
        }];

        [self.containerView addSubview:self.itemLabel];
        [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bannerImageView.mas_bottom);
            make.right.equalTo(self.containerView.mas_right).offset(-10);
            make.height.mas_equalTo(30);
            make.left.equalTo(self.containerView.mas_left).offset(30);
        }];

        [self.containerView addSubview:self.circleView];
        [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(kCircleViewHeight);
            make.left.equalTo(self.containerView.mas_left).offset(8);
        }];

    }
    return self;
}
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIImageView *)bannerImageView {
    if (!_bannerImageView) {
        _bannerImageView = [UIImageView new];
        _bannerImageView.backgroundColor = RANDOM_COLOR;
    }
    return _bannerImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"待办事项";
    }
    return _titleLabel;
}

- (UILabel *)itemLabel {
    if (!_itemLabel) {
        _itemLabel = [UILabel new];
        _itemLabel.text = @"这个标签下还没有东西";
    }
    return _itemLabel;
}

- (UIView *)circleView {
    if (!_circleView) {
        _circleView = [UIView new];
        _circleView.backgroundColor = GRAY_BACKGROUND_COLOR;
        _circleView.layer.borderColor = [UIColor whiteColor].CGColor;
        _circleView.layer.borderWidth = 2;
        _circleView.layer.cornerRadius = kCircleViewHeight/2;
    }
    return _circleView;
}
@end