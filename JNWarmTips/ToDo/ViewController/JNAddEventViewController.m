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
        make.right.equalTo(self->_topView.mas_right).offset(-20);
        make.top.equalTo(self->_topView.mas_top).offset(55);
    }];

    [self.topView addSubview:self.eventInputField];
    [self.eventInputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(20);
        make.right.equalTo(self.self.doneBtn.mas_left).offset(-10);
        make.top.equalTo(self.topView.mas_top).offset(40);
        make.height.mas_equalTo(60);
    }];

    [self displayAllTags];
    [self.eventInputField becomeFirstResponder];
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

    // 检查是否为空
    if (self.eventInputField.text) {
        if (self.finishBlock) {
            self.finishBlock(self.eventInputField.text, self.selectedTypeModel.typeId, self.selectedTypeModel.typeColor);
        }
    } else {

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
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *inputString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBtn.hidden = inputString.length <= 0;
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
        _doneBtn.hidden = YES;
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

@end