//
// Created by fengtianyu on 13/7/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNAddEventsViewController.h"
#import "UIColor+Extension.h"
#import "JNWarmTipsPublicFile.h"

static const int kBarButtonWH = 30;

@interface JNAddEventsViewController()
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIView *inputFieldLine;

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *doneBtn;
@end

@implementation JNAddEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = GRAY_BACKGROUND_COLOR;
    self.view.backgroundColor = [UIColor whiteColor];

    [self displaySubView];

}

#pragma mark - Private Method

- (void) displaySubView {

    [self.view addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(kBarButtonWH);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.view.mas_top).offset(30);
    }];

    [self.view addSubview:self.doneBtn];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kBarButtonWH);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.centerY.equalTo(self.closeBtn.mas_centerY);
    }];

    [self.view addSubview:self.inputField];
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.height.mas_equalTo(35);
    }];

    [self.view addSubview:self.inputFieldLine];
    [self.inputFieldLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputField.mas_bottom);
        make.left.equalTo(self.inputField.mas_left);
        make.right.equalTo(self.inputField.mas_right);
        make.height.mas_equalTo(1);
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Event Response

- (void) close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter & Setter

- (UITextField *)inputField {
    if (!_inputField) {
        _inputField = [UITextField new];
        _inputField.font = [UIFont fontWithName:FONT_NAME_WAWA size:16.0];
        _inputField.placeholder = @"记录每天小事件~";
    }
    return _inputField;
}

- (UIView *)inputFieldLine {
    if (!_inputFieldLine) {
        _inputFieldLine = [UIView new];
        _inputFieldLine.backgroundColor = GRAY_BACKGROUND_COLOR;
    }
    return _inputFieldLine;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];

        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(7, 7)];
        [path addLineToPoint:CGPointMake(23, 23)];
        [path moveToPoint:CGPointMake(7, 23)];
        [path addLineToPoint:CGPointMake(23, 7)];

        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = GRAY_TEXT_COLOR.CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineWidth = 2;
        [_closeBtn.layer addSublayer:shapeLayer];
    }
    return _closeBtn;
}

- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [UIButton new];

        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(5, 15)];
        [path addLineToPoint:CGPointMake(13, 23)];
        [path addLineToPoint:CGPointMake(25, 5)];

        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = GRAY_TEXT_COLOR.CGColor;
        shapeLayer.lineWidth = 2;
        [_doneBtn.layer addSublayer:shapeLayer];
    }
    return _doneBtn;
}
@end