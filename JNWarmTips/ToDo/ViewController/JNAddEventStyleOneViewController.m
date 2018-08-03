//
//  JNAddEventStyleOneViewController.m
//  JNWarmTips
//
//  Created by fengtianyu on 17/7/18.
//  Copyright © 2018年 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNAddEventStyleOneViewController.h"
#import "JNWarmTipsPublicFile.h"
#import "UIColor+Extension.h"
#import "JNEventModel.h"
#import "JNDBManager.h"
#import "JNDBManager+Events.h"
#import "JNEventTypeModel.h"
#import "JNSwitchView.h"
#import "JNArrowIndicateView.h"
#import "JNTimePickerView.h"

static const int kTopImageViewHeight = 180;

static const int kStarImageViewWH = 40;

static const int kTagViewHeight = 80;

static const int kTimeSwitchViewWidth = 35;
static const int kTimeSwitchViewHeight = 16;

static const int kCloseBtnWH = 30;

static const int kTimeIndicateWH = 22;  // 是否显示事件视图指示器的宽高

static const int kDefaultRightMargin = -30; // 右侧边距默认值

@interface JNAddEventStyleOneViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *starImageView;

@property (nonatomic, strong) UIView *eventView;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UIView *tagView;

@property (nonatomic, strong) JNSwitchView *switchView;

@property (nonatomic, strong) UIView *timesSwitchView;
@property (nonatomic, strong) CALayer *selectedLayer;
@property (nonatomic) BOOL isShowTimeView; // 当前是否显示时间视图
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) JNArrowIndicateView *arrowIndicateView;

@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) NSArray<JNEventTypeModel *> *allTagModels;
@property (nonatomic, strong) UIButton *selectedTagBtn;
@property (nonatomic, strong) JNEventTypeModel *selectedTagModel;
@property (nonatomic, strong) NSMutableArray *allTagBtns;

@property(nonatomic, assign) long long startTime;
@property(nonatomic, assign) long long endTime;

//@property (nonatomic, strong) UIView *timeContainerView;
//@property (nonatomic, strong) UIPickerView *timePickerView;
//@property (nonatomic, strong) UIButton *closeTimePickerBtn;
@property (nonatomic, strong) JNTimePickerView *timePickerView;
@end

@implementation JNAddEventStyleOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self dataInit];
    [self viewLayout];
    [self selectTag:self.allTagBtns.firstObject];
}

- (void) dataInit {
    self.isShowTimeView = NO;
    self.startTime = 0;
    self.endTime = 0;
    // todo: 这里后面可以改成自己设置默认是否显示时间视图
}

- (void) viewLayout {
    [self.view addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(kTopImageViewHeight);
    }];

    [self.view addSubview:self.starImageView];
    [self.starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topImageView.mas_centerX);
        make.centerY.equalTo(self.topImageView.mas_bottom);
        make.width.height.mas_equalTo(kStarImageViewWH);
    }];

    [self.view addSubview:self.eventView];
    [self.eventView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageView.mas_bottom).offset(60);
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(kDefaultRightMargin);
        make.height.mas_equalTo(60);
    }];

    [self.view addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.eventView.mas_bottom).offset(25);
        make.left.equalTo(self.eventView.mas_left);
        make.width.equalTo(self.eventView.mas_width);
        make.height.mas_equalTo(kTagViewHeight);
    }];

    [self.view addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagView.mas_bottom).offset(40);
        make.width.equalTo(self.eventView.mas_width);
        make.left.equalTo(self.eventView.mas_left);
        make.height.mas_equalTo(55);
    }];

    UIButton *doneBtn = [UIButton new];
    self.doneBtn = doneBtn;
    [doneBtn setTitle:@"ADD" forState:UIControlStateNormal];
    doneBtn.backgroundColor = GRAY_BACKGROUND_COLOR;
    doneBtn.layer.cornerRadius = 4;
    [doneBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:doneBtn];
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(kDefaultRightMargin);
    }];

    [self.view addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(40);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.width.and.height.mas_equalTo(kCloseBtnWH);
    }];

    UIView *coverView = [UIView new];
    coverView.backgroundColor = [UIColor whiteColor];
    self.coverView = coverView;
    [self.view addSubview:coverView];
    CGFloat height = self.isShowTimeView ? 0 : 95;
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.timeView.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(height);
    }];

    [self.view addSubview:self.timesSwitchView];
    UIView *referenceView = self.isShowTimeView ? self.timeView : self.tagView;
    [self.timesSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(referenceView.mas_bottom).offset(15);
        make.width.height.mas_equalTo(30);
    }];

    [self.view addSubview:self.arrowIndicateView];
    [self.arrowIndicateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kTimeIndicateWH);
        make.top.equalTo(referenceView.mas_bottom).offset(20);
        make.right.equalTo(self.view.mas_right).offset(kDefaultRightMargin);
    }];

    [self.view addSubview:self.timePickerView];
    [self.timePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(220);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void) showTime {
    self.isShowTimeView = !self.isShowTimeView;
    self.selectedLayer.hidden = !self.isShowTimeView;

    CGFloat coverViewUpdateHeight;
    UIView *referenceView;
    if (self.isShowTimeView) {
        coverViewUpdateHeight = 0;
        referenceView = self.timeView;

        [self.arrowIndicateView close];
    } else {
        coverViewUpdateHeight = 95;
        referenceView = self.tagView;

        [self.arrowIndicateView open];
    }

    [self.coverView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(coverViewUpdateHeight);
    }];

    [self.timesSwitchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(referenceView.mas_bottom).offset(15);
        make.width.height.mas_equalTo(30);
    }];

    [self.arrowIndicateView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(kDefaultRightMargin);
        make.top.equalTo(referenceView.mas_bottom).offset(20);
        make.width.height.mas_equalTo(kTimeIndicateWH);
    }];

    [UIView animateWithDuration:0.35 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
}

- (void) turnToTimeDuration {
    self.switchView.on = !self.switchView.on;
}

- (void) selectTag:(UIButton *)btn {

    self.selectedTagBtn.layer.borderColor = GRAY_BACKGROUND_COLOR.CGColor;
    self.selectedTagBtn.selected = NO;
    self.selectedTagBtn = btn;
    btn.selected = YES;

    NSInteger index = [self.allTagBtns indexOfObject:btn];
    JNEventTypeModel *typeModel = (JNEventTypeModel *)[self.allTagModels objectAtIndex:index];
    self.selectedTagModel = typeModel;
    btn.layer.borderColor = [UIColor colorWithHexString:typeModel.typeColor].CGColor;
    [self.starImageView setTintColor:[UIColor colorWithHexString:typeModel.typeColor]];
    self.starImageView.layer.borderColor = [UIColor colorWithHexString:typeModel.typeColor].CGColor;

}

- (void)finish {
    if (self.addEventBlock) {
        JNEventModel *eventModel = [JNEventModel new];
        eventModel.content = self.inputField.text;
        eventModel.eventTypeId = self.selectedTagModel.typeId;
        eventModel.color = self.selectedTagModel.typeColor;
        if (self.isShowTimeView) {
            eventModel.startTime;
            eventModel.endTime;
            eventModel.needNotification = 0;
        }
        self.addEventBlock(eventModel);

        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
};

#pragma mark - Delegate & DataSource

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *inputString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (inputString.length) {
        self.doneBtn.backgroundColor = MAIN_COLOR;
    } else {
        self.doneBtn.backgroundColor = GRAY_BACKGROUND_COLOR;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 23;
    } else {
        return 59;
    }
}

//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    NSAttributedString *title = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", row + 1] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0]}];
//    return title;
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.textColor = MAIN_COLOR;
    titleLabel.text = [NSString stringWithFormat:@"%d", row + 1];
    return titleLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 70;
}

#pragma mark - Getter & Setter

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [UIImageView new];
        _topImageView.image = [UIImage imageNamed:@"group_bg2.jpg"];
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(0, 0)];
        [bezierPath addLineToPoint:CGPointMake(0, kTopImageViewHeight - 40)];
        [bezierPath addQuadCurveToPoint:CGPointMake(SCREEN_WIDTH, kTopImageViewHeight - 40) controlPoint:CGPointMake(SCREEN_WIDTH / 2, kTopImageViewHeight+30)];
        [bezierPath addLineToPoint:CGPointMake(SCREEN_WIDTH, 0)];
        [bezierPath closePath];

        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = bezierPath.CGPath;
        shapeLayer.fillColor = [UIColor redColor].CGColor;

        _topImageView.layer.mask = shapeLayer;

        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"ADD  EVENT";
        titleLabel.alpha = 0.6;
        titleLabel.font = [UIFont boldSystemFontOfSize:22.0];
        titleLabel.textColor = MAIN_COLOR;
        [_topImageView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->_topImageView.mas_centerX);
            make.top.equalTo(self->_topImageView.mas_top).offset(80);
        }];
    }
    return _topImageView;
}

- (UIImageView *)starImageView {
    if (!_starImageView) {
        _starImageView = [UIImageView new];
        _starImageView.image = [[UIImage imageNamed:@"type"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _starImageView.tintColor = GRAY_BACKGROUND_COLOR;
        _starImageView.alpha = 0.6;

        _starImageView.layer.cornerRadius = kStarImageViewWH / 2;
        _starImageView.layer.borderWidth = 1;
        _starImageView.layer.borderColor = GRAY_BACKGROUND_COLOR.CGColor;
    }
    return _starImageView;
}

- (UIView *)eventView {
    if (!_eventView) {
        _eventView = [UIView new];
        [self configCommonView:_eventView AndTitle:@"EVENT" WithImageName:@"event_list_full"];
        UITextField *inputField = [[UITextField alloc] init];
        inputField.placeholder = @"请输入内容";
        inputField.delegate = self;
        self.inputField = inputField;
        [_eventView addSubview:inputField];
        [inputField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_eventView.mas_left).offset(35);
            make.height.mas_equalTo(44);
            make.bottom.equalTo(self->_eventView.mas_bottom).offset(-1);
        }];
    }
    return _eventView;
}

- (UIView *)timeView {
    if (!_timeView) {
        _timeView = [UIView new];
        [self configCommonView:_timeView AndTitle:@"TIME" WithImageName:@"timer_highlight"];

        UILabel *timeLabel = [UILabel new];
        timeLabel.text = @"12:00";
        timeLabel.textColor = GRAY_TEXT_COLOR;
        [_timeView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self->_timeView.mas_centerY).offset(5);
            make.centerX.equalTo(self->_timeView.mas_centerX);
        }];

        JNSwitchView *switchView = [JNSwitchView new];
        self.switchView = switchView;
        [switchView addTarget:self action:@selector(turnToTimeDuration) forControlEvents:UIControlEventTouchUpInside];
        [_timeView addSubview:switchView];
        [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kTimeSwitchViewWidth);
            make.height.mas_equalTo(kTimeSwitchViewHeight);
            make.centerY.equalTo(self->_timeView.mas_centerY).offset(4);
            make.right.equalTo(self->_timeView.mas_right).offset(-6);
        }];
    }
    return _timeView;
}

- (UIView *)timesSwitchView {
    if (!_timesSwitchView) {
        _timesSwitchView = [UIView new];
        _timesSwitchView.hidden = YES;

        UIView *circleView = [UIView new];
        circleView.layer.borderWidth = 1;
        circleView.layer.borderColor = MAIN_COLOR.CGColor;
        circleView.layer.cornerRadius = 6;
        [_timesSwitchView addSubview:circleView];
        [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(12);
            make.centerX.equalTo(self->_timesSwitchView.mas_centerX);
            make.centerY.equalTo(self->_timesSwitchView.mas_centerY);
        }];

        CALayer *centerLayer = [CALayer layer];
        centerLayer.hidden = !self.isShowTimeView;
        self.selectedLayer = centerLayer;
        centerLayer.backgroundColor = MAIN_COLOR.CGColor;
        centerLayer.frame = CGRectMake(3, 3, 6, 6);
        centerLayer.cornerRadius = 3;
        [circleView.layer addSublayer:centerLayer];

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTime)];
        [_timesSwitchView addGestureRecognizer:tapGestureRecognizer];

    }
    return _timesSwitchView;
}

- (UIView *)tagView {
    if (!_tagView) {
        _tagView = [UIView new];
        [self configCommonView:_tagView AndTitle:@"TAG" WithImageName:@"tag_full"];

        CGFloat offset = 0;
        self.allTagBtns = [NSMutableArray array];
        for (JNEventTypeModel *model in self.allTagModels) {
            UIButton *tagBtn = [UIButton  new];
            tagBtn.font = [UIFont systemFontOfSize:14.0];
            tagBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [tagBtn setTitle:[model.typeName substringToIndex:1] forState:UIControlStateNormal];
            [tagBtn addTarget:self action:@selector(selectTag:) forControlEvents:UIControlEventTouchUpInside];

            [tagBtn setTitleColor:GRAY_TEXT_COLOR forState:UIControlStateNormal];
            [tagBtn setTitleColor:[UIColor colorWithHexString:model.typeColor] forState:UIControlStateSelected];

            tagBtn.layer.borderColor = GRAY_TEXT_COLOR.CGColor;
            tagBtn.layer.borderWidth = 1;
            [_tagView addSubview:tagBtn];
            [self.allTagBtns addObject:tagBtn];


            UILabel *nameLabel = [UILabel new];
            nameLabel.font = [UIFont systemFontOfSize:12.0];
            nameLabel.text = model.typeName;
            [_tagView addSubview:nameLabel];
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_tagView.mas_bottom).offset(-6);
                make.left.equalTo(self->_tagView.mas_left).offset(35 + offset);
            }];

            CGRect rect = [model.typeName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:nil attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} context:nil];
            [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(nameLabel.mas_top).offset(-4);
                make.centerX.equalTo(nameLabel.mas_centerX);
                make.width.height.mas_equalTo(30);
            }];
            tagBtn.layer.cornerRadius = (rect.size.height + 4) / 2;
            tagBtn.layer.cornerRadius = 15;

            offset += 50;
        }
    }
    return _tagView;
}

- (JNArrowIndicateView *)arrowIndicateView {
    if (!_arrowIndicateView) {
        _arrowIndicateView = [JNArrowIndicateView new];
        _arrowIndicateView.backgroundColor = [UIColor clearColor];

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTime)];
        [_arrowIndicateView addGestureRecognizer:tapGestureRecognizer];
    }
    return _arrowIndicateView;
}

- (void) configCommonView:(UIView *)superView AndTitle:(NSString *)title WithImageName:(NSString *)imageName{

    UILabel *titleLabel = [UILabel new];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
    titleLabel.textColor = [UIColor colorWithHexString:@"c8c8c8"];
    titleLabel.textColor = MAIN_COLOR;
    [superView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top);
        make.left.equalTo(superView.mas_left).offset(35);
    }];

    UIView *line = [UIView new];
    line.alpha = 0.6;
    line.backgroundColor = GRAY_BACKGROUND_COLOR;
    line.backgroundColor = MAIN_COLOR;
    [superView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(superView.mas_left).offset(35);
        make.right.equalTo(superView.mas_right);
        make.bottom.equalTo(superView.mas_bottom);
    }];

    UIImageView *iconImageView = [UIImageView new];
    iconImageView.image = [UIImage imageNamed:imageName];
    [superView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left);
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(superView.mas_centerY);
    }];
}

- (NSArray *)allTagModels {
    if (!_allTagModels) {
        _allTagModels = [[JNDBManager shareInstance] getAllEventTypes];
    }
    return _allTagModels;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.layer.cornerRadius = kCloseBtnWH / 2;
        _closeBtn.layer.borderColor = [UIColor colorWithHexString:@"C4c4c4"].CGColor;
        _closeBtn.layer.borderWidth = 1;
        _closeBtn.alpha = 0.8;
        _closeBtn.backgroundColor = [UIColor clearColor];

        CAShapeLayer *shapeLayer = [self closeLayerWithWidth:kCloseBtnWH];
        [_closeBtn.layer addSublayer:shapeLayer];

    }
    return _closeBtn;
}

- (CAShapeLayer *)closeLayerWithWidth:(CGFloat)width {

    CGPoint centerPoint = CGPointMake(width/ 2, width / 2);
    CGFloat step = 5;
    CGPoint point1 = CGPointMake(centerPoint.x - step, centerPoint.y - step);
    CGPoint point2 = CGPointMake(centerPoint.x + step, centerPoint.y + step);
    CGPoint point3 = CGPointMake(centerPoint.x - step, centerPoint.y + step);
    CGPoint point4 = CGPointMake(centerPoint.x + step, centerPoint.y - step);

    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:point1];
    [bezierPath addLineToPoint:point2];
    [bezierPath moveToPoint:point3];
    [bezierPath addLineToPoint:point4];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor colorWithHexString:@"C4c4c4"].CGColor;
    shapeLayer.lineWidth = 2;

    return shapeLayer;
}


- (JNTimePickerView *)timePickerView {
    if (!_timePickerView) {
        _timePickerView = [[JNTimePickerView alloc] init];
        _timePickerView.backgroundColor = [UIColor colorWithHexString:@"F0FFFF"];
    }
    return _timePickerView;
}
@end
