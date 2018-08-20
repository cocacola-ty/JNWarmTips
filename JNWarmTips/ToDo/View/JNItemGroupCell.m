//
// Created by fengtianyu on 18/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNItemGroupCell.h"
#import "JNWarmTipsPublicFile.h"
#import "UIColor+Extension.h"

static const int kDefaultMargin = 20;

@interface JNItemGroupCell()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *groupNameLabel;

@property(nonatomic, assign) CGFloat containerViewWidth;
@property(nonatomic, assign) CGFloat containerViewHeight;
@end

@implementation JNItemGroupCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.containerViewWidth = frame.size.width - kDefaultMargin * 2;
    self.containerViewHeight = frame.size.height - kDefaultMargin * 2;

    if (self) {

        [self.contentView addSubview:self.shadowView];
        [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(kDefaultMargin);
            make.left.equalTo(self.contentView.mas_left).offset(kDefaultMargin);
            make.right.equalTo(self.contentView.mas_right).offset(-kDefaultMargin);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kDefaultMargin);
        }];

        [self.contentView addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(kDefaultMargin);
            make.left.equalTo(self.contentView.mas_left).offset(kDefaultMargin);
            make.right.equalTo(self.contentView.mas_right).offset(-kDefaultMargin);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kDefaultMargin);
        }];

        [self.containerView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView.mas_left);
            make.right.equalTo(self.containerView.mas_right);
            make.top.equalTo(self.containerView.mas_top);
            make.bottom.equalTo(self.containerView.mas_bottom).offset(-40);
        }];

        [self.containerView addSubview:self.groupNameLabel];
        [self.groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.containerView.mas_centerX);
            make.top.equalTo(self.imageView.mas_bottom).offset(10);
        }];
    }
    return self;
}

#pragma mark - Getter & Setter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 5;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [UIView new];
        _shadowView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        _shadowView.layer.shadowOffset = CGSizeMake(0.5, 2);
        _shadowView.layer.shadowColor = GRAY_TEXT_COLOR.CGColor;
        _shadowView.layer.shadowOpacity = 0.5;
    }
    return _shadowView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            int num = arc4random() % 8 + 1;
            NSString *imageName = [NSString stringWithFormat:@"group_bg%d.jpg", num];
            UIImage *image = [UIImage imageNamed:imageName];
            dispatch_async(dispatch_get_main_queue(), ^{
                _imageView.image = image;
            });
        });
    }
    return _imageView;
}

- (UILabel *)groupNameLabel {
    if (!_groupNameLabel) {
        _groupNameLabel = [UILabel new];
        _groupNameLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _groupNameLabel.text = @"ALL";
    }
    return _groupNameLabel;
}
@end
