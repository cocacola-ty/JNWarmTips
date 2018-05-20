//
// Created by fengtianyu on 18/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNAddGroupAlertViewController.h"
#import "View+MASAdditions.h"

static const int kFinishBtnWidthAndHeight = 30;

@interface JNAddGroupAlertViewController()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) CAShapeLayer *bottomLayer;
@property (nonatomic, strong) UIButton *finishBtn;
@end

@implementation JNAddGroupAlertViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];

    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.mas_equalTo(200);
    }];

    [self.containerView addSubview:self.inputField];
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15);
        make.right.equalTo(self.containerView.mas_right).offset(-15);
        make.top.equalTo(self.containerView.mas_top).offset(50);
    }];

    [self.containerView addSubview:self.finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-25);
        make.width.height.mas_equalTo(kFinishBtnWidthAndHeight);
    }];
    self.finishBtn.layer.cornerRadius = kFinishBtnWidthAndHeight/2;
    [self.finishBtn.layer addSublayer:[self finishBtnCoverLayer]];
}

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

        UIBezierPath *path = [UIBezierPath bezierPath];
//        [path moveToPoint:CGPointMake(0, <#CGFloat y#>)];
//        CAShapeLayer *bottomLayer = [CAShapeLayer layer];
    }
    return _inputField;
}

- (UIButton *)finishBtn {
    if (!_finishBtn) {
        _finishBtn = [[UIButton alloc] init];
        _finishBtn.backgroundColor = [UIColor redColor];
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
    finishBtnCoverLayer.strokeColor = [UIColor greenColor].CGColor;
    finishBtnCoverLayer.fillColor = [UIColor clearColor].CGColor;

    return finishBtnCoverLayer;

}

- (CAShapeLayer *)bottomLayer {
    if (!_bottomLayer) {

    }
    return _bottomLayer;
}
@end