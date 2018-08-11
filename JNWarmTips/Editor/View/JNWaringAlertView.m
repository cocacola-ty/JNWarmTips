//
// Created by fengtianyu on 4/7/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNWaringAlertView.h"
#import "JNWarmTipsPublicFile.h"
#import <Masonry/Masonry.h>

@interface JNWaringAlertView()
@property (nonatomic, strong) UILabel *waringLabel;
@end

@implementation JNWaringAlertView {

}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 5;
        
        self.backgroundColor = [UIColor whiteColor];

        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"warning"];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(70);
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(15);
        }];

        UIButton *confirmBtn = [[UIButton alloc] init];
        confirmBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_WAWA size:14.0];
        [confirmBtn setTitle:@"不要啦" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmBtn];
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_centerY);
            make.width.mas_equalTo(80);
        }];
        UIButton *cancleBtn = [[UIButton alloc] init];
        cancleBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_WAWA size:14.0];
        [cancleBtn setTitle:@"我再想想" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:GRAY_TEXT_COLOR forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancleBtn];
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_centerY);
            make.width.mas_equalTo(80);
        }];

        UIView *vLine = [UIView new];
        vLine.backgroundColor = RGB(245, 245, 245);
        [self addSubview:vLine];
        [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(confirmBtn.mas_left);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.mas_equalTo(1);
        }];

        UIView *hLine = [UIView new];
        hLine.backgroundColor = RGB(245, 245, 245);
        [self addSubview:hLine];
        [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cancleBtn.mas_bottom);
            make.left.equalTo(cancleBtn.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(1);
        }];

        self.waringLabel = [UILabel new];
        self.waringLabel.textColor = [UIColor blackColor];
        self.waringLabel.font = [UIFont systemFontOfSize:20.];
        self.waringLabel.text = @"要不要记下来呢?";
        [self addSubview:self.waringLabel];
        [self.waringLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(10);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

- (void)cancleAction {
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}

- (void)confirmAction {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

- (void)setAlertText:(NSString *)alertText {
    _alertText = alertText;

    self.waringLabel.text = alertText;
}

@end
