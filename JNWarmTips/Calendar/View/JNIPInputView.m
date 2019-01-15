//
//  JNIPInputView.m
//  JNWarmTips
//
//  Created by 冯天宇 on 2019/1/13.
//  Copyright © 2019 fengtianyu. All rights reserved.
//

#import "JNIPInputView.h"
#import <Masonry/Masonry.h>
#import "JNWarmTipsPublicFile.h"
#import "JNIPField.h"

static CGFloat const margin = 50;

@interface JNIPInputView() <UITextFieldDelegate>
@property (nonatomic, strong) JNIPField *firstSegIpField;
@property (nonatomic, strong) JNIPField *sedSegIpField;

@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UILabel *firstSegIpLbl;
@property (nonatomic, assign) NSInteger focusIndex;
@end

@implementation JNIPInputView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.focusIndex = 1;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.firstSegIpField];
        [self addSubview:self.sedSegIpField];
        
        [self.firstSegIpField becomeFirstResponseder];
        
        [self addSubview:self.inputField];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    CGFloat width = SCREEN_WIDTH - margin - margin;
    return CGSizeMake(width, 60);
}

- (void)updateConstraints {
    
    CGFloat width = (SCREEN_WIDTH - margin - margin ) / 4;
    
    [self.firstSegIpField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.mas_height);
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(width);
    }];
    
    [self.sedSegIpField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.mas_height);
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(width);
    }];
    
    [super updateConstraints];
}

#pragma mark - Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *updateText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    switch (self.focusIndex) {
        case 1:
            {
                self.firstSegIpLbl.text = updateText;
            }
            break;
    }
    return YES;
}

#pragma mark - Getter & Setter

- (JNIPField *)firstSegIpField {
    if (!_firstSegIpField) {
        _firstSegIpField = [JNIPField new];
    }
    return _firstSegIpField;
}

- (JNIPField *)sedSegIpField {
    if (!_sedSegIpField) {
        _sedSegIpField = [JNIPField new];
    }
    return _sedSegIpField;
}

- (UITextField *)inputField {
    if (!_inputField) {
        _inputField = [UITextField new];
        _inputField.delegate = self;
        _inputField.keyboardType = UIKeyboardTypeNumberPad;
        _inputField.inputView = [UIView new];
    }
    return _inputField;
}

- (UILabel *)firstSegIpLbl {
    if (!_firstSegIpLbl) {
        _firstSegIpLbl = [UILabel new];
        [self initLabelWith:_firstSegIpLbl];
    }
    return _firstSegIpLbl;
}

- (void) initLabelWith:(UILabel *)lbl {
    lbl.font = [UIFont boldSystemFontOfSize:17.0];
}
@end
