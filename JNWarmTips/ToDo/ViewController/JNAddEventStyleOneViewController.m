//
//  JNAddEventStyleOneViewController.m
//  JNWarmTips
//
//  Created by fengtianyu on 17/7/18.
//  Copyright © 2018年 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNAddEventStyleOneViewController.h"
#import "JNWarmTipsPublicFile.h"
#import "UIColor+Extension.h"

static const int kTopImageViewHeight = 180;

static const int kStarImageViewWH = 40;

@interface JNAddEventStyleOneViewController ()
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *starImageView;

@property (nonatomic, strong) UIView *eventView;
@end

@implementation JNAddEventStyleOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self displaySubviews];
}

- (void) displaySubviews {
    [self.view addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(kTopImageViewHeight);
    }];

    [self.view addSubview:self.starImageView];
    [self.starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.centerY.equalTo(self.topImageView.mas_bottom);
        make.width.height.mas_equalTo(kStarImageViewWH);
    }];

    [self.view addSubview:self.eventView];
    [self.eventView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageView.mas_bottom).offset(60);
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(60);
    }];
}

#pragma mark - Getter & Setter

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [UIImageView new];
//        _topImageView.backgroundColor = MAIN_COLOR;

        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id) MAIN_COLOR.CGColor, (__bridge id)[UIColor colorWithHexString:@"F08080"].CGColor, (__bridge id) [UIColor colorWithHexString:@"FF4500"].CGColor];
        gradientLayer.locations = @[@0.3, @0.6, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1.0, 1.0);
        gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, kTopImageViewHeight);
        [_topImageView.layer addSublayer:gradientLayer];
    }
    return _topImageView;
}

- (UIImageView *)starImageView {
    if (!_starImageView) {
        _starImageView = [UIImageView new];
        _starImageView.image = [UIImage imageNamed:@"type"];
        _starImageView.layer.cornerRadius = kStarImageViewWH / 2;
        _starImageView.layer.borderWidth = 1;
        _starImageView.layer.borderColor = MAIN_COLOR.CGColor;
    }
    return _starImageView;
}

- (UIView *)eventView {
    if (!_eventView) {
        _eventView = [UIView new];
//        _eventView.backgroundColor = GRAY_BACKGROUND_COLOR;
        [self configCommonView:_eventView AndTitle:@"EVENT"];
        UITextField *inputField = [[UITextField alloc] init];
        [_eventView addSubview:inputField];
        [inputField mas_makeConstraints:^(MASConstraintMaker *make) {

        }];
    }
    return _eventView;
}

- (void) configCommonView:(UIView *)superView AndTitle:(NSString *)title{
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
    titleLabel.textColor = [UIColor colorWithHexString:@"c8c8c8"];
    [_eventView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top);
        make.left.equalTo(superView.mas_left).offset(35);
    }];

    UIView *line = [UIView new];
    line.backgroundColor = GRAY_BACKGROUND_COLOR;
    [_eventView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(superView.mas_left).offset(35);
        make.right.equalTo(superView.mas_right);
        make.bottom.equalTo(superView.mas_bottom);
    }];
}

@end
