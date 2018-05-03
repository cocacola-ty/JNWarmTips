//
// Created by fengtianyu on 25/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNEventEditorViewController.h"
#import "View+MASAdditions.h"
#import "JNTextView.h"
#import "JNWarmTipsPublicFile.h"

@interface JNEventEditorViewController() <UITextViewDelegate>
@property (nonatomic, strong) UIView *warningView;
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

    [self.view addSubview:self.warningView];
    [self.warningView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(90);
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.centerY.equalTo(self.view.mas_centerY).offset(-30);
    }];
    self.warningView.transform = CGAffineTransformMakeTranslation(0, -400);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    self.warningView.hidden = NO;
    [self.view endEditing:YES];

    [UIView animateWithDuration:0.4 animations:^{
        self.warningView.transform = CGAffineTransformIdentity;
    }];
}

- (void) confirmAction {
    self.editFinishBlock(self.textView.text);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) cancleAction {
    [UIView animateWithDuration:0.4 animations:^{
        self.warningView.transform = CGAffineTransformMakeTranslation(0, 1000);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - Getter & Setter

- (void)setPlaceHoladerStr:(NSString *)placeHoladerStr {
    _placeHoladerStr = placeHoladerStr;
    [self.textView setPlaceHolderStr:placeHoladerStr];
}

- (JNTextView *)textView {
    if (!_textView) {
        _textView = [JNTextView new];
        _textView.layer.shadowOffset = CGSizeMake(0, 0);
        _textView.layer.shadowColor = [UIColor blackColor].CGColor;
        _textView.layer.shadowOpacity = 0.3;
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

- (UIView *)warningView {
    if (!_warningView) {
        _warningView = [UIView new];
        _warningView.layer.cornerRadius = 5;
        _warningView.hidden = YES;
        _warningView.backgroundColor = [UIColor whiteColor];

        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"warning"];
        [_warningView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(70);
            make.centerY.equalTo(_warningView.mas_centerY);
            make.left.equalTo(_warningView.mas_left).offset(15);
        }];

        UIButton *confirmBtn = [[UIButton alloc] init];
        confirmBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_WAWA size:14.0];
        [confirmBtn setTitle:@"记下吧" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        [_warningView addSubview:confirmBtn];
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_warningView.mas_bottom);
            make.right.equalTo(_warningView.mas_right);
            make.top.equalTo(_warningView.mas_centerY);
            make.width.mas_equalTo(80);
        }];
        UIButton *cancleBtn = [[UIButton alloc] init];
        cancleBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_WAWA size:14.0];
        [cancleBtn setTitle:@"不记啦" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:GRAY_TEXT_COLOR forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        [_warningView addSubview:cancleBtn];
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_warningView.mas_top);
            make.right.equalTo(_warningView.mas_right);
            make.bottom.equalTo(_warningView.mas_centerY);
            make.width.mas_equalTo(80);
        }];

        UIView *vLine = [UIView new];
        vLine.backgroundColor = RGB(245, 245, 245);
        [_warningView addSubview:vLine];
        [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(confirmBtn.mas_left);
            make.top.equalTo(_warningView.mas_top);
            make.bottom.equalTo(_warningView.mas_bottom);
            make.width.mas_equalTo(1);
        }];

        UIView *hLine = [UIView new];
        hLine.backgroundColor = RGB(245, 245, 245);
        [_warningView addSubview:hLine];
        [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cancleBtn.mas_bottom);
            make.left.equalTo(cancleBtn.mas_left);
            make.right.equalTo(_warningView.mas_right);
            make.height.mas_equalTo(1);
        }];

        UILabel *waningTextLabel = [UILabel new];
        waningTextLabel.textColor = [UIColor blackColor];
        waningTextLabel.font = [UIFont systemFontOfSize:20.];
        waningTextLabel.text = @"要不要记下来呢?";
        [_warningView addSubview:waningTextLabel];
        [waningTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(10);
            make.centerY.equalTo(_warningView.mas_centerY);
        }];

    }
    return _warningView;
}
@end
