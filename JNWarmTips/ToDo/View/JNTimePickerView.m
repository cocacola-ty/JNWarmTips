//
// Created by fengtianyu on 3/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNTimePickerView.h"
#import "JNWarmTipsPublicFile.h"
#import "CAShapeLayer+Extension.h"


static const int kDoneBthWH = 36;

static const int kTimeBtnHeight = 30;

static const int kTimeBtnWidth = 60;

static const int kTimeBtnMargin = 25;

static const int kTimeBtnTopMargin = 8;

@interface JNTimePickerView() <UIPickerViewDelegate, UIPickerViewDataSource>
@property(nonatomic, assign) JNTimeType type;

@property (nonatomic, strong) UIPickerView *timePickerView;
@property(nonatomic, strong) UIButton *startTimeBtn;
@property (nonatomic, strong) UILabel *separateLabel;
@property(nonatomic, strong) UIButton *endTimeBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *doneBtn;

@property (nonatomic, strong) UIButton *currentSelectBtn;
@property(nonatomic, assign) BOOL isSelectStart;

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *startHour;
@property (nonatomic, strong) NSString *startMinute;
@property (nonatomic, strong) NSString *endHour;
@property (nonatomic, strong) NSString *endMinute;
@end

@implementation JNTimePickerView

- (instancetype) initWithType:(JNTimeType) type {
    self = [super init];
    if (self) {
        self.type = type;

        [self addSubview:self.timePickerView];
        [self.timePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(30);
            make.bottom.equalTo(self.mas_bottom).offset(-50);
            make.left.equalTo(self.mas_left).offset(55);
            make.right.equalTo(self.mas_right).offset(-55);
        }];

        [self addSubview:self.startTimeBtn];
        [self.startTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(60);
            make.top.equalTo(self.mas_top).offset(8);
            make.right.equalTo(self.mas_centerX).offset(-25);
        }];

        UILabel *separateLabel = [UILabel new];
        self.separateLabel = separateLabel;
        separateLabel.text = @">";
        [self addSubview:separateLabel];
        [separateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.startTimeBtn.mas_centerY);
        }];

        [self addSubview:self.endTimeBtn];
        [self.endTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(60);
            make.left.equalTo(self.mas_centerX).offset(25);
            make.centerY.equalTo(self.startTimeBtn.mas_centerY);
        }];

        [self addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(8);
            make.right.equalTo(self.mas_right).offset(-8);
            make.width.height.mas_equalTo(30);
        }];

        [self addSubview:self.doneBtn];
        [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(kDoneBthWH);
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];

        // Data Init
        self.currentSelectBtn = self.startTimeBtn;
        self.currentSelectBtn.selected = YES;
        self.currentSelectBtn.backgroundColor = MAIN_COLOR;
        self.isSelectStart = YES;

        self.startHour = @"00";
        self.startMinute = @"00";
        self.endHour = @"00";
        self.endMinute = @"00";
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.timePickerView];
        [self.timePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(30);
            make.bottom.equalTo(self.mas_bottom).offset(-50);
            make.left.equalTo(self.mas_left).offset(55);
            make.right.equalTo(self.mas_right).offset(-55);
        }];

        [self addSubview:self.startTimeBtn];
        [self.startTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kTimeBtnHeight);
            make.width.mas_equalTo(kTimeBtnWidth);
            make.top.equalTo(self.mas_top).offset(kTimeBtnTopMargin);
            make.right.equalTo(self.mas_centerX).offset(-kTimeBtnMargin);
        }];

        UILabel *separateLabel = [UILabel new];
        self.separateLabel = separateLabel;
        separateLabel.text = @">";
        [self addSubview:separateLabel];
        [separateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.startTimeBtn.mas_centerY);
        }];

        [self addSubview:self.endTimeBtn];
        [self.endTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kTimeBtnHeight);
            make.width.mas_equalTo(kTimeBtnWidth);
            make.left.equalTo(self.mas_centerX).offset(kTimeBtnMargin);
            make.centerY.equalTo(self.startTimeBtn.mas_centerY);
        }];

        [self addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(8);
            make.right.equalTo(self.mas_right).offset(-8);
            make.width.height.mas_equalTo(30);
        }];

        [self addSubview:self.doneBtn];
        [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(kDoneBthWH);
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];

        // Data Init
        self.currentSelectBtn = self.startTimeBtn;
        self.currentSelectBtn.selected = YES;
        self.currentSelectBtn.backgroundColor = MAIN_COLOR;
        self.isSelectStart = YES;

        self.startHour = @"00";
        self.startMinute = @"00";
        self.endHour = @"00";
        self.endMinute = @"00";
        self.startTime = [NSString stringWithFormat:@"%@:%@", self.startHour, self.startMinute];
        self.endTime = [NSString stringWithFormat:@"%@:%@", self.endHour, self.endMinute];
        [self changeType:JNTimeTypeTime];

    }
    return self;
}

- (void) selectTime:(UIButton *)timeBtn {
    if (self.currentSelectBtn != timeBtn) {
        // 将原来选中的按钮状态重置
        self.currentSelectBtn.backgroundColor = [UIColor clearColor];
        self.currentSelectBtn.selected = NO;

        // 将选中按钮更新为当前点击按钮
        self.currentSelectBtn = timeBtn;
        self.currentSelectBtn.selected = YES;
        self.currentSelectBtn.backgroundColor = MAIN_COLOR;

        self.isSelectStart = self.currentSelectBtn == self.startTimeBtn;
    }
}

- (void) changeType:(JNTimeType)type {
    self.type = type;
    if (type == JNTimeTypeDuration) {
        [self.startTimeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kTimeBtnHeight);
            make.width.mas_equalTo(kTimeBtnWidth);
            make.top.equalTo(self.mas_top).offset(kTimeBtnTopMargin);
            make.right.equalTo(self.mas_centerX).offset(-kTimeBtnMargin);
        }];
        self.endTimeBtn.hidden = NO;
        self.separateLabel.hidden = NO;

    } else {
        [self.startTimeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.width.mas_equalTo(kTimeBtnWidth);
            make.height.mas_equalTo(kTimeBtnHeight);
            make.top.equalTo(self.mas_top).offset(kTimeBtnTopMargin);
        }];

        [self selectTime:self.startTimeBtn];
        self.endTimeBtn.hidden = YES;
        self.separateLabel.hidden = YES;
    }
}

- (void) dismiss {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void) done {
    if (self.doneBlock) {
        NSString *endTime = self.type == JNTimeTypeTime ? nil : self.endTime;
        self.doneBlock(self.startTime, endTime);
    }
}

#pragma mark - Delegate & DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return component == 0 ? 24 : 60;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = [NSString stringWithFormat:@"%02d", row];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    return titleLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if (component == 0) {
        if (self.isSelectStart) {
            self.startHour = [NSString stringWithFormat:@"%02d", row];
        } else {
            self.endHour =  [NSString stringWithFormat:@"%02d", row];
        }
    } else {
        if (self.isSelectStart) {
            self.startMinute = [NSString stringWithFormat:@"%02d", row];
        } else {
            self.endMinute = [NSString stringWithFormat:@"%02d", row];
        }
    }

    if (self.isSelectStart) {
        self.startTime = [NSString stringWithFormat:@"%@:%@", self.startHour, self.startMinute];
        [self.startTimeBtn setTitle:self.startTime forState:UIControlStateNormal];
    } else {
        self.endTime = [NSString stringWithFormat:@"%@:%@", self.endHour, self.endMinute];
        [self.endTimeBtn setTitle:self.endTime forState:UIControlStateNormal];
    }

}

#pragma mark - Getter & Setter

- (UIPickerView *)timePickerView {
    if (!_timePickerView) {
        _timePickerView = [[UIPickerView alloc] init];
        _timePickerView.delegate = self;
        _timePickerView.dataSource = self;
    }
    return _timePickerView;
}

- (UIButton *)startTimeBtn {
    if (!_startTimeBtn) {
        _startTimeBtn = [[UIButton alloc] init];
        _startTimeBtn.layer.cornerRadius = 4;
        _startTimeBtn.layer.borderWidth = 1;
        _startTimeBtn.layer.borderColor = MAIN_COLOR.CGColor;
        [_startTimeBtn setTitle:@"start" forState:UIControlStateNormal];
        _startTimeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [_startTimeBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [_startTimeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_startTimeBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startTimeBtn;
}

- (UIButton *)endTimeBtn {
    if (!_endTimeBtn) {
        _endTimeBtn = [[UIButton alloc] init];
        _endTimeBtn.layer.cornerRadius = 4;
        _endTimeBtn.layer.borderWidth = 1;
        _endTimeBtn.layer.borderColor = MAIN_COLOR.CGColor;
        [_endTimeBtn setTitle:@"end" forState:UIControlStateNormal];
        _endTimeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [_endTimeBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [_endTimeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

        [_endTimeBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endTimeBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

        CAShapeLayer *shapeLayer = [CAShapeLayer closeLayerWithWidth:30];
        [_closeBtn.layer addSublayer:shapeLayer];
    }
    return _closeBtn;
}

- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [UIButton new];
        _doneBtn.layer.cornerRadius = kDoneBthWH / 2;
        _doneBtn.layer.borderColor = MAIN_COLOR.CGColor;
        _doneBtn.layer.borderWidth = 2;
        CAShapeLayer *shapeLayer = [CAShapeLayer rightLayerWithWidth:kDoneBthWH WithHeight:kDoneBthWH];
        [_doneBtn.layer addSublayer:shapeLayer];
        _doneBtn.alpha = 0.8;
        [_doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
}
@end