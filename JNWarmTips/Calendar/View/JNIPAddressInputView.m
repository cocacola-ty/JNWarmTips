//
//  JNIPAddressInputView.m
//  JNWarmTips
//
//  Created by fengtianyu on 5/12/2018.
//  Copyright © 2018 fengtianyu. All rights reserved.
//

#import "JNIPAddressInputView.h"
#import "Masonry.h"
#import "JNWarmTipsPublicFile.h"

@interface JNIPAddressInputView()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *ipFirstLabel;
@property (nonatomic, strong) UILabel *ipSecondLabel;
@property (nonatomic, strong) UILabel *ipThirdLabel;
@property (nonatomic, strong) UILabel *ipFourthLabel;

@property (nonatomic, strong) NSArray *ipLabelArray;
@end

@implementation JNIPAddressInputView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.textField];
        [self addSubview:self.ipFirstLabel];
        [self addSubview:self.ipSecondLabel];
        [self addSubview:self.ipThirdLabel];
        [self addSubview:self.ipFourthLabel];
        
        self.ipLabelArray = @[self.ipFirstLabel, self.ipSecondLabel, self.ipThirdLabel, self.ipFourthLabel];
        [self addDotLayer];
        
        CALayer *lineLayer = [CALayer layer];
        lineLayer.frame = CGRectMake(50, 10, 3, 30);
        lineLayer.backgroundColor = MAIN_COLOR.CGColor;
        [self.layer addSublayer:lineLayer];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
        animation.fromValue = [NSNumber numberWithFloat:1.0f];
        animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
        animation.autoreverses = YES;
        animation.duration = 0.25;
        animation.repeatCount = MAXFLOAT;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
        [lineLayer addAnimation:animation forKey:nil];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(240, 50);
}

- (void)updateConstraints {
    MASViewAttribute *attribute = self.mas_left;
    for (UILabel *lbl in self.ipLabelArray) {
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(attribute);
            make.top.equalTo(self.mas_top);
            make.width.mas_equalTo(60);
            make.bottom.equalTo(self.mas_bottom);
        }];
        attribute = lbl.mas_right;
    }
    [super updateConstraints];
}

- (void)addDotLayer {
    for (int index = 1; index < 4; index++) {
        CALayer *layer = [CALayer layer];
        CGFloat xPosition = index * 60;
        layer.frame = CGRectMake(xPosition, 30, 4, 4);
        layer.backgroundColor = [UIColor blackColor].CGColor;
        layer.cornerRadius = 2;
        [self.layer addSublayer:layer];
    }
}

- (void)labelSetting:(UILabel *)lbl {
    lbl.text = @"192";
    lbl.font = [UIFont boldSystemFontOfSize:18.0];
    lbl.textColor = MAIN_COLOR;
    lbl.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - Public Method
- (void)becomeFirstResponder {
    [self.textField becomeFirstResponder];
}

#pragma mark - Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

#pragma mark - Getter


- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypePhonePad;
        _textField.returnKeyType = UIReturnKeyNext;
    }
    return _textField;
}

- (UILabel *)ipFirstLabel {
    if (!_ipFirstLabel) {
        _ipFirstLabel = [UILabel new];
        [self labelSetting:_ipFirstLabel];
    }
    return _ipFirstLabel;
}

- (UILabel *)ipSecondLabel {
    if (!_ipSecondLabel) {
        _ipSecondLabel = [UILabel new];
        [self labelSetting:_ipSecondLabel];
    }
    return _ipSecondLabel;
}

- (UILabel *)ipThirdLabel {
    if (!_ipThirdLabel) {
        _ipThirdLabel = [UILabel new];
        [self labelSetting:_ipThirdLabel];
    }
    return _ipThirdLabel;
}

- (UILabel *)ipFourthLabel {
    if (!_ipFourthLabel) {
        _ipFourthLabel = [UILabel new];
        [self labelSetting:_ipFourthLabel];
    }
    return _ipFourthLabel;
}
@end
