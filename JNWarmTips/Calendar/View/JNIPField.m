//
//  JNIPField.m
//  JNWarmTips
//
//  Created by 冯天宇 on 2019/1/14.
//  Copyright © 2019 fengtianyu. All rights reserved.
//

#import "JNIPField.h"
#import <Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface JNIPField() <UITextFieldDelegate>
@property (nonatomic, strong) UILabel *showLbl;
@property (nonatomic, strong) UITextField *inputField;
@end

@implementation JNIPField

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.inputField];
        [self addSubview:self.showLbl];
        
        RAC(self.showLbl, text) =[ self.inputField.rac_textSignal filter:^BOOL(NSString *text) {
            return text.length <= 3;
        }];
    }
    return self;
}

- (void)updateConstraints {
    [self.showLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [super updateConstraints];
}

#pragma mark - Public Method

- (void)becomeFirstResponseder {
    [self.inputField becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *updateText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return updateText.length <= 3;
}

#pragma mark - Getter & Setter

- (UITextField *)inputField {
    if (!_inputField) {
        _inputField = [UITextField new];
        _inputField.keyboardType = UIKeyboardTypeNumberPad;
        _inputField.delegate = self;
    }
    return _inputField;
}

- (UILabel *)showLbl {
    if (!_showLbl) {
        _showLbl = [UILabel new];
        _showLbl.font = [UIFont boldSystemFontOfSize:17.0];
    }
    return _showLbl;
}
@end
