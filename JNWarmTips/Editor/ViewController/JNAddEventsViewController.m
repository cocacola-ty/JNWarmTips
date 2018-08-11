//
// Created by fengtianyu on 13/7/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNAddEventsViewController.h"
#import "UIColor+Extension.h"
#import "JNWarmTipsPublicFile.h"
#import "JNButtonTagView.h"
#import "JNDBManager.h"
#import "JNDBManager+Events.h"
#import "JNEventTypeModel.h"

static const int kBarButtonWH = 30;

static NSString *const kBtnNormalColor = @"F2F2F4";

@interface JNAddEventsViewController()
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIView *inputFieldLine;

@property (nonatomic, strong) UIView *timeView;

@property (nonatomic, strong) UIButton *typeBtn;
@property (nonatomic, strong) UIButton *timeBtn;

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *doneBtn;

@property (nonatomic, strong) NSArray *allTagModels;
@property (nonatomic, strong) NSMutableArray *allTagViews;
@property(nonatomic, assign) BOOL tagSelecting;
@property (nonatomic, strong) JNEventTypeModel *selectedTypeModel;
@property (nonatomic, strong) JNButtonTagView *selectedTagView;
@end

@implementation JNAddEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self displaySubView];

    [self.inputField becomeFirstResponder];
}

#pragma mark - Private Method

- (void) displaySubView {

    [self.view addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(kBarButtonWH);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.view.mas_top).offset(30);
    }];

    [self.view addSubview:self.doneBtn];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kBarButtonWH);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.centerY.equalTo(self.closeBtn.mas_centerY);
    }];

    [self.view addSubview:self.inputField];
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.height.mas_equalTo(35);
    }];

    [self.view addSubview:self.inputFieldLine];
    [self.inputFieldLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputField.mas_bottom);
        make.left.equalTo(self.inputField.mas_left);
        make.right.equalTo(self.inputField.mas_right);
        make.height.mas_equalTo(1);
    }];

    [self.view addSubview:self.typeBtn];
    [self.typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.centerX.equalTo(self.view.mas_centerX).offset(-60);
        make.top.equalTo(self.inputFieldLine.mas_bottom).offset(30);
    }];

    [self.view addSubview:self.timeBtn];
    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.centerX.equalTo(self.view.mas_centerX).offset(60);
        make.centerY.equalTo(self.typeBtn.mas_centerY);
    }];
}

- (void) showTimeSelector {

}

- (void)showTagSelector {
    if (self.tagSelecting) {
        return;
    }
    self.tagSelecting = YES;

    /*
    UIView *containerView = [UIView new];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    containerView.layer.shadowOffset = CGSizeMake(0, 0);
    containerView.layer.shadowOpacity = 0.3;
    [self.view addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeBtn.mas_bottom).offset(40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(150);
        make.left.equalTo(self.view.mas_left).offset(50)
        make.right.equalTo(self.view.mas_right).offset(-50);
    }];
     */

    // 一行显示两个 位置随机 大小随机

    self.allTagViews = [NSMutableArray array];

    CGFloat baseTagViewY = 240;
    for (int i = 0; i < self.allTagModels.count; ++i) {
        JNEventTypeModel *typeModel = self.allTagModels[i];
        JNButtonTagView *tagview = [JNButtonTagView new];
        UIColor *color = [UIColor colorWithHexString:typeModel.typeColor];
        CGFloat tagViewWidth = 60 + (arc4random() % 30);
        CGSize size = [tagview setupTagName:typeModel.typeName AndColor:color WithWidth:tagViewWidth];
        [tagview addTarget:self action:@selector(selectTag:) forControlEvents:UIControlEventTouchUpInside];

        CGFloat tagViewX = (arc4random() % 230) + 30;
        // 检查这个视图是否会超出屏幕 , 超过屏幕则更为位置为距离屏幕20
        if ((tagViewX + size.width) > SCREEN_WIDTH) {
            tagViewX = SCREEN_WIDTH - size.width - 20;
        }
        // 检查是否会和上一个视图重合, 如果重合 则下移一行
        JNButtonTagView *lastTagView = self.allTagViews.lastObject;
        CGFloat lastX = lastTagView.frame.origin.x;
        CGFloat lastW = lastTagView.frame.size.width;
        if ((lastX + lastW + 15) > tagViewX) {
            baseTagViewY += 50;
        }

        tagview.frame = CGRectMake(SCREEN_WIDTH, baseTagViewY, size.width, size.height);
        [self.view addSubview:tagview];

        [self.allTagViews addObject:tagview];

        [UIView animateWithDuration:0.35 delay:0.3 usingSpringWithDamping:0.7 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
            tagview.frame = CGRectMake(tagViewX, baseTagViewY, size.width, size.height);
        } completion:^(BOOL finished) {

        }];
    }

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Event Response

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectEventType {
    if (self.inputField.isFirstResponder) {
        [self.view endEditing:YES];
        dispatch_after(0.25, dispatch_get_main_queue(), ^{
            // 执行动画
            [self showTagSelector];
        });
    }else {
        // 飞入动画
        [self showTagSelector];
    }
}

- (void) addEventTime {
    if (self.inputField.isFirstResponder) {
        [self.view endEditing:YES];
    }
}

- (void) selectTag:(JNButtonTagView *)tagView {
    if (tagView != self.selectedTagView) {
        self.selectedTagView.selected = !self.selectedTagView.selected;
        tagView.selected = !tagView.selected;
        self.selectedTagView = tagView;

        // 获取点击tag的索引
        NSUInteger index = [self.allTagViews indexOfObject:tagView];
        // 根据索引获去模型
        self.selectedTypeModel = [self.allTagModels objectAtIndex:index];

        self.typeBtn.imageView.tintColor = [UIColor colorWithHexString:self.selectedTypeModel.typeColor];
        self.typeBtn.layer.borderColor = [UIColor colorWithHexString:self.selectedTypeModel.typeColor].CGColor;

        self.tagSelecting = NO;
        // 隐藏标签
        for (UIView *view in self.allTagViews) {
            [UIView animateWithDuration:0.35 animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }

        [self.allTagViews removeAllObjects];
    }
}
#pragma mark - Getter & Setter

- (UITextField *)inputField {
    if (!_inputField) {
        _inputField = [UITextField new];
        _inputField.font = [UIFont fontWithName:FONT_NAME_WAWA size:16.0];
        _inputField.placeholder = @"记录每天小事件~";
    }
    return _inputField;
}

- (UIView *)inputFieldLine {
    if (!_inputFieldLine) {
        _inputFieldLine = [UIView new];
        _inputFieldLine.backgroundColor = GRAY_BACKGROUND_COLOR;
    }
    return _inputFieldLine;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];

        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(7, 7)];
        [path addLineToPoint:CGPointMake(23, 23)];
        [path moveToPoint:CGPointMake(7, 23)];
        [path addLineToPoint:CGPointMake(23, 7)];

        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = GRAY_TEXT_COLOR.CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineWidth = 2;
        [_closeBtn.layer addSublayer:shapeLayer];
    }
    return _closeBtn;
}

- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [UIButton new];

        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(5, 15)];
        [path addLineToPoint:CGPointMake(13, 23)];
        [path addLineToPoint:CGPointMake(25, 5)];

        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = GRAY_TEXT_COLOR.CGColor;
        shapeLayer.lineWidth = 2;
        [_doneBtn.layer addSublayer:shapeLayer];
    }
    return _doneBtn;
}

- (UIButton *)typeBtn {
    if (!_typeBtn) {
        _typeBtn = [UIButton new];
        UIImage *iamge = [[UIImage imageNamed:@"type"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_typeBtn setImage:iamge forState:UIControlStateNormal];
        _typeBtn.imageView.tintColor = [UIColor colorWithHexString:kBtnNormalColor];
        [_typeBtn addTarget:self action:@selector(selectEventType) forControlEvents:UIControlEventTouchUpInside];

        _typeBtn.layer.cornerRadius = 20;
        _typeBtn.layer.borderWidth = 1;
        _typeBtn.layer.borderColor = [UIColor colorWithHexString:kBtnNormalColor].CGColor;
    }
    return _typeBtn;
}

- (UIButton *)timeBtn {
    if (!_timeBtn) {
        _timeBtn = [UIButton new];
        UIImage *image = [UIImage imageNamed:@"timer_normal"];
        [_timeBtn setImage:image forState:UIControlStateNormal];
        [_timeBtn setImage:[UIImage imageNamed:@"timer_highlight"] forState:UIControlStateSelected];
        [_timeBtn addTarget:self action:@selector(addEventTime) forControlEvents:UIControlEventTouchUpInside];

        _timeBtn.layer.cornerRadius = 20;
        _timeBtn.layer.borderColor = [UIColor colorWithHexString:kBtnNormalColor].CGColor;
        _timeBtn.layer.borderWidth = 1;
    }
    return _timeBtn;
}

- (NSArray *)allTagModels {
    if (!_allTagModels) {
        _allTagModels = [[JNDBManager shareInstance] getAllEventTypes];
    }
    return _allTagModels;
}
@end
