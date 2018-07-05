//
// Created by fengtianyu on 29/6/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNAddEventViewController.h"
#import "JNButtonTagView.h"
#import "JNWarmTipsPublicFile.h"
#import "JNDBManager+Events.h"
#import "JNEventTypeModel.h"
#import "UIColor+Extension.h"
#import "JNWaringAlertView.h"

/*标签按钮的上边间距*/
static const int kTagViewTopMargin = 30;
/*标签按钮的左边默认间距*/
static const int kTagViewDefaultLeftMargin = 40;

static const int kTopViewHeight = 100;

static const int kDoneBtnWH = 30;

@interface JNAddEventViewController() <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *eventInputField;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *doneBtn;

@property (nonatomic, strong) JNButtonTagView *selectedTagView;
@property (nonatomic, strong) JNEventTypeModel *selectedTypeModel;
@property (nonatomic, strong) NSMutableArray *allTagViews;
@property (nonatomic, strong) NSArray *allTagModels;

@property (nonatomic, strong) JNWaringAlertView *waringAlertView;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation JNAddEventViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GRAY_BACKGROUND_COLOR;

    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(kTopViewHeight);
    }];

    [self.topView addSubview:self.doneBtn];
    [_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kDoneBtnWH);
        make.right.equalTo(self.topView.mas_right).offset(-20);
        make.top.equalTo(self.topView.mas_top).offset(55);
    }];

    [self.topView addSubview:self.eventInputField];
    [self.eventInputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(20);
        make.right.equalTo(self.doneBtn.mas_left).offset(-10);
        make.top.equalTo(self.topView.mas_top).offset(40);
        make.height.mas_equalTo(60);
    }];

    [self.view addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(60);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-60);
    }];

    [self displayAllTags];

    [self.view addSubview:self.waringAlertView];
    self.waringAlertView.frame = CGRectMake(30, -90, SCREEN_WIDTH - 60, 90);

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.eventInputField becomeFirstResponder];
}

#pragma mark - Event Response

- (void) showAlertView {
    self.waringAlertView.hidden = NO;
    [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.waringAlertView.frame = CGRectMake(30, 250, SCREEN_WIDTH - 60, 90);
    } completion:^(BOOL finished) {
    }];
}

- (void) dismissAlertView {
    [UIView animateWithDuration:0.25 animations:^{
        self.waringAlertView.frame = CGRectMake(30, -90, SCREEN_WIDTH - 60, 90);
    } completion:^(BOOL finished){
        self.waringAlertView.hidden = YES;
    }];
}

- (void) displayAllTags {
    self.allTagModels = [[JNDBManager shareInstance] getAllEventTypes];
    self.allTagViews = [NSMutableArray array];

    for (int i = 0; i < self.allTagModels.count; ++i) {
        JNEventTypeModel *typeModel = self.allTagModels[i];
        JNButtonTagView *tagview = [JNButtonTagView new];
        [tagview addTarget:self action:@selector(selectTag:) forControlEvents:UIControlEventTouchUpInside];

        UIColor *color = [UIColor colorWithHexString:typeModel.typeColor];
        tagview.frame = CGRectMake(kTagViewDefaultLeftMargin + i * 80, kTagViewTopMargin + kTopViewHeight, 0, 0);
        [tagview setupTagName:typeModel.typeName AndColor:color];
        [self.view addSubview:tagview];

        [self.allTagViews addObject:tagview];
    }
}

- (void) done {

    // 检查是否选择类型
    if (self.selectedTypeModel == nil) {
        for (UIView *tagView in self.allTagViews) {
            CALayer *layer = tagView.layer;
            CGPoint position = layer.position;
            CGPoint startPoint = CGPointMake(position.x - 10, position.y);
            CGPoint endPoint = CGPointMake(position.x + 10, position.y);

            CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
            basicAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
            basicAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
            basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            basicAnimation.autoreverses = YES;
            basicAnimation.repeatCount = 2;
            basicAnimation.duration = 0.15;
            [layer addAnimation:basicAnimation forKey:nil];
        }

        return;
    }

    if (self.finishBlock) {
        self.finishBlock(self.eventInputField.text, self.selectedTypeModel.typeId, self.selectedTypeModel.typeColor);
    }

}

- (void)selectTag:(JNButtonTagView *)tagView {
    if (tagView == self.selectedTagView) {
        tagView.selected = !tagView.selected;
    }else {
        self.selectedTagView.selected = !self.selectedTagView.selected;
        tagView.selected = !tagView.selected;
        self.selectedTagView = tagView;

        // 获取点击tag的索引
        NSUInteger index = [self.allTagViews indexOfObject:tagView];
        // 根据索引获去模型
        self.selectedTypeModel = [self.allTagModels objectAtIndex:index];
    }

};

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {

    [self.view endEditing:YES];

    if (self.eventInputField.text.length > 0) {
        [self showAlertView];
    }
}

- (void) dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *inputString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [UIView animateWithDuration:0.35 animations:^{
        self.doneBtn.alpha = inputString.length;
    }];
    return YES;
}

#pragma mark - Getter & Setter

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.layer.shadowOffset = CGSizeMake(0, 5);
        _topView.layer.shadowColor = GRAY_TEXT_COLOR.CGColor;
        _topView.layer.shadowOpacity = 0.8;

    }
    return _topView;
}

- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [UIButton new];
        _doneBtn.alpha = 0;
        _doneBtn.backgroundColor = MAIN_COLOR;
        _doneBtn.layer.cornerRadius = kDoneBtnWH / 2;
        [_doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];

        CGPoint startPoint = CGPointMake(8, 15);
        CGPoint endPoint = CGPointMake(23, 8);
        CGPoint controlPoint = CGPointMake(12, 30);
        UIBezierPath *donePath = [UIBezierPath bezierPath];
        [donePath moveToPoint:startPoint];
        [donePath addQuadCurveToPoint:endPoint controlPoint:controlPoint];

        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = donePath.CGPath;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.lineWidth = 2;
        [_doneBtn.layer addSublayer:layer];
    }
    return _doneBtn;
}
- (UITextField *)eventInputField {
    if (!_eventInputField) {
        _eventInputField = [[UITextField alloc] init];
        _eventInputField.placeholder = @"记录这一天的小事件...";
        _eventInputField.font = [UIFont systemFontOfSize:15.0];
        _eventInputField.delegate = self;
    }
    return _eventInputField;
}

- (JNWaringAlertView *)waringAlertView {

    if (!_waringAlertView) {
        _waringAlertView = [JNWaringAlertView new];
        _waringAlertView.hidden = YES;
        _waringAlertView.alertText = @"确定不要啦?";
        __weak typeof(self) ws = self;
        _waringAlertView.cancleBlock = ^() {
            [ws dismissAlertView];
        };

        _waringAlertView.confirmBlock = ^() {
            [ws dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _waringAlertView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        _closeBtn.backgroundColor = [UIColor blueColor];
        _closeBtn.layer.cornerRadius = 30;
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

    }
    return _closeBtn;
}

@end
