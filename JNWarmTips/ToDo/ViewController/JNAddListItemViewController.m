//
//  JNAddListItemViewController.m
//  JNWarmTips
//
//  Created by fengtianyu on 11/8/18.
//  Copyright © 2018年 fengtianyu. All rights reserved.
//

#import "JNAddListItemViewController.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import "JNWarmTipsPublicFile.h"
#import "JNItemModel.h"
#import "JNDBManager.h"
#import "JNDBManager+Items.h"

@interface JNAddListItemViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIButton *cancleBtn;

@property (nonatomic, strong) JNItemModel *itemModel;
@end

@implementation JNAddListItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:0];

    [self.view addSubview:self.containerView];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.view.mas_top).offset(SCREEN_HEIGHT);
    }];

    [self.containerView addSubview:self.inputField];
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(40);
        make.top.equalTo(self.containerView.mas_top).offset(50);
        make.right.equalTo(self.containerView.mas_right).offset(-40);
        make.height.mas_equalTo(40);
    }];

    [self.containerView addSubview:self.doneBtn];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containerView.mas_right).offset(-15);
        make.top.equalTo(self.containerView.mas_top).offset(8);
    }];

    [self.containerView addSubview:self.cancleBtn];
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15);
        make.top.equalTo(self.containerView.mas_top).offset(8);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGFloat topMargin = SCREEN_HEIGHT / 2 - 100;
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(topMargin);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:0.6];
        [self.view layoutIfNeeded];
        [self.view setNeedsLayout];
    } completion:^(BOOL finished) {
        [self.inputField becomeFirstResponder];
    }];
}

#pragma mark - Event Response

- (void) doneAction {
    self.itemModel.content = self.inputField.text;

    [[JNDBManager shareInstance] addItem:self.itemModel];

    [self cancleAction];
}

- (void) cancleAction {
    [self dismiss];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.inputField resignFirstResponder];
}

- (void) dismiss {
    
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(SCREEN_HEIGHT);
    }];

    NSTimeInterval delayInterval = 0;
    if (self.inputField.isFirstResponder) {
        [self.inputField resignFirstResponder];
        delayInterval = 0.25;
    }

    [UIView animateKeyframesWithDuration:0.25 delay:delayInterval options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:0];
        [self.view layoutIfNeeded];
        [self.view setNeedsLayout];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBtn.enabled = text.length > 0;
    return YES;
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
        _inputField = [UITextField new];
        _inputField.placeholder = @"添加事项内容";
        _inputField.delegate = self;
    }
    return _inputField;
}

- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [UIButton new];
        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_doneBtn setTitleColor:GRAY_TEXT_COLOR forState:UIControlStateDisabled];
        [_doneBtn setTitleColor:[UIColor colorWithHexString:@"222222"] forState:UIControlStateNormal];
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        _doneBtn.enabled = NO;
        [_doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
}

- (UIButton *)cancleBtn {
    if (!_cancleBtn) {
        _cancleBtn = [UIButton new];
        [_cancleBtn setTitleColor:[UIColor colorWithHexString:@"222222"] forState:UIControlStateNormal];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

- (JNItemModel *)itemModel {
    if (!_itemModel) {
        _itemModel = [JNItemModel new];
        _itemModel.startTime = 0;
        _itemModel.endTime = 0;
        _itemModel.categoryId = -100;
        _itemModel.categoryName = @"未分类";
        _itemModel.notification = 0;
        _itemModel.finished = 0;
        _itemModel.groupId = self.groupId;
    }
    return _itemModel;
}

@end
