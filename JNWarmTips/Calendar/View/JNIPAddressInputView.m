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

@property (nonatomic, strong) UIButton *preBtn;
@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, strong) CALayer *lineLayer;

@property (nonatomic, assign) NSInteger focusIndex;
@end

/*光标高度*/
static CGFloat lineLayerHeight = 30;

/*光标宽度*/
static CGFloat lineLayerWidth = 3;

/*光标边距*/
static CGFloat lineLayerRightMargin = 10;

/*光标初始y位置*/
static CGFloat lineLayerYPosition = 10;

static CGFloat margin = 80;

@implementation JNIPAddressInputView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.focusIndex = 1;
        
        [self addSubview:self.textField];
        [self addSubview:self.ipFirstLabel];
        [self addSubview:self.ipSecondLabel];
        [self addSubview:self.ipThirdLabel];
        [self addSubview:self.ipFourthLabel];
        
        self.ipLabelArray = @[self.ipFirstLabel, self.ipSecondLabel, self.ipThirdLabel, self.ipFourthLabel];
        [self addDotLayer];
        [self addCursorLayer];
        
        [self addObserver:self forKeyPath:@"focusIndex" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    CGFloat width = SCREEN_WIDTH - margin - margin;
    return CGSizeMake(width, 50);
}

- (void)updateConstraints {
    
    CGFloat width = ( SCREEN_WIDTH - margin - margin ) / 4;
    
    MASViewAttribute *attribute = self.mas_left;
    for (UILabel *lbl in self.ipLabelArray) {
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(attribute);
            make.top.equalTo(self.mas_top);
            make.width.mas_equalTo(width);
            make.bottom.equalTo(self.mas_bottom);
        }];
        attribute = lbl.mas_right;
    }
    [super updateConstraints];
}

- (void)addDotLayer {
    CGFloat labelWidth = ( SCREEN_WIDTH - margin - margin ) / 4;
    
    for (int index = 1; index < 4; index++) {
        CALayer *layer = [CALayer layer];
        CGFloat xPosition = index * labelWidth;
        layer.frame = CGRectMake(xPosition, 30, 4, 4);
        layer.backgroundColor = [UIColor blackColor].CGColor;
        layer.cornerRadius = 2;
        [self.layer addSublayer:layer];
    }
}

- (void)addCursorLayer {

//    CALayer *lineLayer = [CALayer layer];
//    CGFloat xPosition = labelWidth - lineLayerRightMargin;
//    lineLayer.frame = CGRectMake(xPosition, lineLayerYPosition, lineLayerWidth, lineLayerHeight);
//    lineLayer.backgroundColor = MAIN_COLOR.CGColor;
//    self.lineLayer = lineLayer;
//    [self.layer addSublayer:lineLayer];
//
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
//    animation.fromValue = [NSNumber numberWithFloat:1.0f];
//    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
//    animation.autoreverses = YES;
//    animation.duration = 0.6;
//    animation.repeatCount = MAXFLOAT;
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
//    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];///没有的话是均匀的动画。
//    [lineLayer addAnimation:animation forKey:nil];
}

- (void)labelSetting:(UILabel *)lbl {
//    lbl.text = @"192";
    lbl.font = [UIFont boldSystemFontOfSize:18.0];
    lbl.textColor = MAIN_COLOR;
    lbl.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - Public Method
- (void)becomeFirstResponder {
    [self.textField becomeFirstResponder];
}

#pragma mark - Event Response

- (void)moveFocusToNext {
    self.focusIndex = self.focusIndex + 1;
    UILabel *ipLabel = self.ipLabelArray[self.focusIndex - 1];
    self.textField.text = ipLabel.text.length > 0 ? ipLabel.text : @"";
//    CGFloat xPosition = self.focusIndex * labelWidth - 10;
//    CGFloat preX = self.lineLayer.frame.origin.x;
//    CGFloat width = xPosition - preX;
//    [self animationWithFromXPosition:preX toXPosition:xPosition width:width];
}

- (void)animationWithFromXPosition:(CGFloat)fromX toXPosition:(CGFloat)toX width:(CGFloat)width {
    [UIView animateWithDuration:0.25 animations:^{
        self.lineLayer.frame = CGRectMake(fromX, lineLayerYPosition, width, lineLayerHeight);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.lineLayer.frame = CGRectMake(toX, lineLayerYPosition, lineLayerWidth, lineLayerHeight);
        } completion:nil];
    });
}

- (void)moveFocusToPre {
    self.focusIndex = self.focusIndex - 1;
    UILabel *ipLabel = self.ipLabelArray[self.focusIndex - 1];
    self.textField.text = ipLabel.text.length > 0 ? ipLabel.text : @"";
    
    // 移动光标
//    CGFloat preX = self.lineLayer.frame.origin.x;
//    CGFloat xPosition = self.focusIndex * labelWidth - 10;
//    CGFloat width = preX - xPosition;
//    [self animationWithFromXPosition:xPosition toXPosition:xPosition width:width];
    
}
#pragma mark - Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *updateText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (updateText.length <= 3) {
        UILabel *ipLabel = self.ipLabelArray[self.focusIndex - 1];
        ipLabel.text = updateText;
        return YES;
    }else {
        return NO;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSInteger positionIndex = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
    self.preBtn.enabled = positionIndex > 1;
    self.nextBtn.enabled = positionIndex < 4;
}

#pragma mark - Getter


- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.returnKeyType = UIReturnKeyNext;
        
        _textField.inputAccessoryView = [self keyBoardToolBar];
    }
    return _textField;
}

- (UIView *)keyBoardToolBar {
    
    CGFloat toolBarHeight = 44;
    CGFloat btnWidth = 70;
    
    UIView *toolBar = [UIView new];
    toolBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, toolBarHeight);
    toolBar.backgroundColor = [UIColor whiteColor];
    
    UIButton *nextBtn = [[UIButton alloc] init];
    [nextBtn setTitle:@"下一段" forState:UIControlStateNormal];
    nextBtn.frame = CGRectMake(SCREEN_WIDTH - btnWidth, 0, btnWidth, toolBarHeight);
    [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [nextBtn addTarget:self action:@selector(moveFocusToNext) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:nextBtn];
    self.nextBtn = nextBtn;
    
    UIButton *preBtn = [UIButton new];
    preBtn.frame = CGRectMake(0, 0, btnWidth, toolBarHeight);
    [preBtn setTitle:@"上一段" forState:UIControlStateNormal];
    [preBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [preBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    preBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [preBtn addTarget:self action:@selector(moveFocusToPre) forControlEvents:UIControlEventTouchUpInside];
    preBtn.enabled = NO;
    [toolBar addSubview:preBtn];
    self.preBtn = preBtn;
    return toolBar;
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
