//
// Created by fengtianyu on 6/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNGroupListCell.h"
#import "JNWarmTipsPublicFile.h"
#import "View+MASAdditions.h"

static const int kCircleViewHeight = 10;

@interface JNGroupListCell()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomContainerView;
@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UIView *circleView;
@end

@implementation JNGroupListCell {

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontChange) name:FONT_DOWNLOAD_NOTIFICATION object:nil];

        [self.contentView addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.height.mas_equalTo(110);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        }];

        [self.containerView addSubview:self.bannerImageView];
        [self.bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView.mas_top);
            make.left.equalTo(self.containerView.mas_left);
            make.right.equalTo(self.containerView.mas_right);
            make.height.mas_equalTo(70);
        }];

        [self.bannerImageView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bannerImageView.mas_centerX);
            make.centerY.equalTo(self.bannerImageView.mas_centerY);
        }];

        [self.containerView addSubview:self.bottomContainerView];
        [self.bottomContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bannerImageView.mas_bottom);
            make.left.equalTo(self.containerView.mas_left);
            make.right.equalTo(self.containerView.mas_right);
            make.bottom.equalTo(self.containerView.mas_bottom);
        }];

        [self.bottomContainerView addSubview:self.itemLabel];
        [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.containerView.mas_right).offset(-10);
            make.left.equalTo(self.containerView.mas_left).offset(35);
            make.centerY.equalTo(self.bottomContainerView.mas_centerY);
        }];

        [self.bottomContainerView addSubview:self.circleView];
        [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(kCircleViewHeight);
            make.left.equalTo(self.containerView.mas_left).offset(15);
            make.centerY.equalTo(self.bottomContainerView.mas_centerY);
        }];

    }
    return self;
}

- (void) fontChange {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.itemLabel.font = [UIFont fontWithName:FONT_NAME_SHOUZHA size:15.0];
    });
}
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 8;
        _containerView.layer.masksToBounds = YES;
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
        _titleLabel.font = [UIFont fontWithName:FONT_NAME_SHOUZHA size:17.0];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"待办事项";
    }
    return _titleLabel;
}

- (UIView *)bottomContainerView {
    if (!_bottomContainerView) {
        _bottomContainerView = [UIView new];
        _bottomContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomContainerView;
}

- (UILabel *)itemLabel {
    if (!_itemLabel) {
        _itemLabel = [UILabel new];
        _itemLabel.text = @"这个标签下还没有东西";
        _itemLabel.font = [UIFont fontWithName:FONT_NAME_SHOUZHA size:14.0];
    }
    return _itemLabel;
}

- (UIView *)circleView {
    if (!_circleView) {
        _circleView = [UIView new];
        _circleView.backgroundColor = [UIColor whiteColor];
        _circleView.layer.borderColor = GRAY_TEXT_COLOR.CGColor;
        _circleView.layer.borderWidth = 1;
        _circleView.layer.cornerRadius = kCircleViewHeight/2;
    }
    return _circleView;
}
@end