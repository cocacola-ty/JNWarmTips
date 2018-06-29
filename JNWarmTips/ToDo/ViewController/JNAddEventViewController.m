//
// Created by fengtianyu on 29/6/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNAddEventViewController.h"
#import "JNWarmTipsPublicFile.h"


@interface JNAddEventViewController()
@property (nonatomic, strong) UITextField *eventInputField;
@property (nonatomic, strong) UIView *topView;
@end

@implementation JNAddEventViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GRAY_BACKGROUND_COLOR;

    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(100);
    }];

    [self.topView addSubview:self.eventInputField];
    [self.eventInputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(20);
        make.right.equalTo(self.topView.mas_right).offset(-20);
        make.top.equalTo(self.topView.mas_top).offset(40);
        make.height.mas_equalTo(60);
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter & Setter

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.layer.shadowOffset = CGSizeMake(0, 5);
        _topView.layer.shadowColor = GRAY_TEXT_COLOR.CGColor;
        _topView.layer.shadowOpacity = 0.8;
    }
    return _topView;
}
- (UITextField *)eventInputField {
    if (!_eventInputField) {
        _eventInputField = [[UITextField alloc] init];
        _eventInputField.placeholder = @"记录这一天的小事件...";
        _eventInputField.font = [UIFont systemFontOfSize:15.0];
    }
    return _eventInputField;
}
@end