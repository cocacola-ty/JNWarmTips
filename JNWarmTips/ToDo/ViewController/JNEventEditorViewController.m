//
// Created by fengtianyu on 25/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNEventEditorViewController.h"
#import "View+MASAdditions.h"

@interface JNEventEditorViewController()
@property (nonatomic, strong) UITextView *textView;
@end

@implementation JNEventEditorViewController {

}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];

    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(140);
        make.top.equalTo(self.view.mas_top).offset(50);
    }];
    self.textView.hidden = YES;
    self.textView.transform = CGAffineTransformMakeTranslation(0, -200);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.textView.hidden = NO;
    [UIView animateWithDuration:0.65 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.textView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.layer.cornerRadius = 5;
        _textView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    }
    return _textView;
}
@end
