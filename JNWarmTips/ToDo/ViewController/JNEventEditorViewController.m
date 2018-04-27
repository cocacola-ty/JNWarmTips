//
// Created by fengtianyu on 25/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNEventEditorViewController.h"
#import "View+MASAdditions.h"
#import "JNTextView.h"

@interface JNEventEditorViewController() <UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation JNEventEditorViewController {

}
- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.35];

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = self.view.bounds;
    [self.view addSubview:visualEffectView];
    self.view.backgroundColor = [UIColor clearColor];

    JNTextView *textView1 = [JNTextView new];
    [self.view addSubview:textView1];
    CGFloat height = textView1.font.lineHeight + textView1.textContainerInset.top + textView1.textContainerInset.bottom;
    NSLog(@"init text view height = %lf", height);
    [textView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.height.mas_equalTo(height);
        make.top.equalTo(self.view.mas_top).offset(120);
    }];

//    [self.view addSubview:self.textView];
//    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(25);
//        make.right.equalTo(self.view.mas_right).offset(-25);
//        make.height.mas_equalTo(30);
//        make.top.equalTo(self.view.mas_top).offset(120);
//    }];
//    self.textView.hidden = YES;
//    self.textView.transform = CGAffineTransformMakeTranslation(0, -200);

    /*
    [self.view addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom);
        make.left.equalTo(self.textView.mas_left);
        make.right.equalTo(self.textView.mas_right);
        make.height.mas_equalTo(1);
    }];
     */
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    self.textView.hidden = NO;
//    [UIView animateWithDuration:0.65 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.textView.transform = CGAffineTransformIdentity;
//    } completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView {

}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.scrollEnabled = NO;
        _textView.layer.cornerRadius = 5;
//        _textView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        _textView.backgroundColor = [UIColor yellowColor];
        _textView.font = [UIFont systemFontOfSize:17.0];
        _textView.delegate = self;

        UILabel *placeHolaerLabel = [UILabel new];
        placeHolaerLabel.text = @"input some thing";
        [_textView addSubview:placeHolaerLabel];
        [_textView setValue:placeHolaerLabel forKey:@"_placeholderLabel"];

    }
    return _textView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = [UIColor blackColor];
    }
    return _bottomLine;
}
@end
