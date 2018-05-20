//
// Created by fengtianyu on 18/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNAddGroupAlertViewController.h"
#import "View+MASAdditions.h"
#import "JNWarmTipsPublicFile.h"
#import "JNGroupModel.h"
#import "JNDBManager.h"
#import "JNDBManager+Group.h"

static const int kFinishBtnWidthAndHeight = 30;

@interface JNAddGroupAlertViewController()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIButton *finishBtn;
@end

@implementation JNAddGroupAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];

    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.mas_equalTo(150);
    }];

    [self.containerView addSubview:self.inputField];
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15);
        make.right.equalTo(self.containerView.mas_right).offset(-20);
        make.top.equalTo(self.containerView.mas_top).offset(50);
    }];

    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = GRAY_BACKGROUND_COLOR;
    [self.containerView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputField.mas_bottom).offset(2);
        make.left.equalTo(self.inputField.mas_left);
        make.right.equalTo(self.inputField.mas_right);
        make.height.mas_equalTo(1);
    }];

    [self.containerView addSubview:self.finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-20);
        make.width.height.mas_equalTo(kFinishBtnWidthAndHeight);
    }];
    self.finishBtn.layer.cornerRadius = kFinishBtnWidthAndHeight / 2;
    [self.finishBtn.layer addSublayer:[self finishBtnCoverLayer]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) addGroup {

    JNGroupModel *groupModel = [JNGroupModel new];
    groupModel.groupName = self.inputField.text;

    // 插入到数据库
    [[JNDBManager shareInstance] addGroup:groupModel];

    // 回调给上一个界面
    if (self.finishAddGroup) {
        self.finishAddGroup(groupModel);
    }

    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - Getter & Setter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 8;
    }
    return _containerView;
}

- (UITextField *)inputField {
    if (!_inputField) {
        _inputField = [[UITextField alloc] init];
        _inputField.placeholder = @"为小组起一个响亮的名字";
    }
    return _inputField;
}

- (UIButton *)finishBtn {
    if (!_finishBtn) {
        _finishBtn = [[UIButton alloc] init];
        _finishBtn.backgroundColor = MAIN_COLOR;
        [_finishBtn addTarget:self action:@selector(addGroup) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

- (CAShapeLayer *)finishBtnCoverLayer {
    CGPoint midPoint = CGPointMake(kFinishBtnWidthAndHeight / 2, kFinishBtnWidthAndHeight / 2 + 6);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(midPoint.x - 6, midPoint.y - 6)];
    [path addLineToPoint:midPoint];
    [path addLineToPoint:CGPointMake(midPoint.x + 6, midPoint.y - 12)];

    CAShapeLayer *finishBtnCoverLayer = [CAShapeLayer layer];
    finishBtnCoverLayer.frame = self.finishBtn.frame;
    finishBtnCoverLayer.path = path.CGPath;
    finishBtnCoverLayer.lineWidth = 2;
    finishBtnCoverLayer.lineJoin = kCALineJoinRound;
    finishBtnCoverLayer.strokeColor = [UIColor whiteColor].CGColor;
    finishBtnCoverLayer.fillColor = [UIColor clearColor].CGColor;

    return finishBtnCoverLayer;

}

@end