//
// Created by fengtianyu on 28/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNCategoryPickerViewController.h"
#import "UIColor+Extension.h"
#import "JNDBManager.h"
#import "JNWarmTipsPublicFile.h"

static const int kContainerViewHeight = 220;

@interface JNCategoryPickerViewController() <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *doneBtn;
@end

@implementation JNCategoryPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(kContainerViewHeight);
    }];

    [self.containerView addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.top.equalTo(self.containerView.mas_top);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-50);
    }];

    [self.containerView addSubview:self.doneBtn];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(36);
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.bottom.mas_equalTo(self.containerView.mas_bottom).offset(-8);
    }];

    self.containerView.transform = CGAffineTransformMakeTranslation(0, kContainerViewHeight);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - Event Response

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.transform = CGAffineTransformMakeTranslation(0, kContainerViewHeight);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - Delegate & DataSource

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    NSDictionary *categoryDict = self.categoryData[row];
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = [categoryDict valueForKey:@"categoryName"];
    return titleLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.categoryData.count;
}

#pragma mark - Getter & Setter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    }
    return _containerView;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [UIPickerView new];
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [UIButton new];
        UIImage *image = [[UIImage imageNamed:@"done"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_doneBtn setImage:image forState:UIControlStateNormal];
        _doneBtn.tintColor = MAIN_COLOR;
    }
    return _doneBtn;
}

@end