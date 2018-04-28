//
// Created by fengtianyu on 25/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNEventEditorViewController.h"
#import "View+MASAdditions.h"
#import "JNTextView.h"
#import "JNWarmTipsPublicFile.h"

@interface JNEventEditorViewController() <UITextViewDelegate>
@property (nonatomic, strong) JNTextView *textView;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation JNEventEditorViewController {

}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.alpha = 0.9;
    [self.view addSubview:visualEffectView];

    [self.view addSubview:self.textView];
    CGFloat height = self.textView.font.lineHeight + self.textView.textContainerInset.top + self.textView.textContainerInset.bottom;
    NSLog(@"init text view height = %lf", height);
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(height);
        make.top.equalTo(self.view.mas_top).offset(120);
    }];

    [self.view addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom);
        make.left.equalTo(self.textView.mas_left);
        make.right.equalTo(self.textView.mas_right);
        make.height.mas_equalTo(1);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter & Setter

- (void)setPlaceHoladerStr:(NSString *)placeHoladerStr {
    _placeHoladerStr = placeHoladerStr;
    [self.textView setPlaceHolderStr:placeHoladerStr];
}

- (JNTextView *)textView {
    if (!_textView) {
        _textView = [JNTextView new];
    }
    return _textView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = RGB(74, 112, 139);
    }
    return _bottomLine;
}
@end
