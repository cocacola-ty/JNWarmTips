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

    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 0.8;

    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(100);
        make.top.equalTo(self.view.mas_top).offset(50);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.layer.cornerRadius = 5;
        _textView.backgroundColor = [UIColor whiteColor];
    }
    return _textView;
}
@end
