//
// Created by fengtianyu on 3/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNTimePickerView.h"
#import "JNWarmTipsPublicFile.h"
#import "CAShapeLayer+Extension.h"


static const int kDoneBthWH = 36;

@interface JNTimePickerView() <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *timePickerView;
@property(nonatomic, strong) UIButton *startTimeBtn;
@property(nonatomic, strong) UIButton *endTimeBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *doneBtn;
@end

@implementation JNTimePickerView

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
            make.height.mas_equalTo(24);
            make.width.mas_equalTo(60);
            make.top.equalTo(self.mas_top).offset(8);
            make.right.equalTo(self.mas_centerX).offset(-25);
        }];

        UILabel *separateLabel = [UILabel new];
        separateLabel.text = @"-";
        [self addSubview:separateLabel];
        [separateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.startTimeBtn.mas_centerY);
        }];

        [self addSubview:self.endTimeBtn];
        [self.endTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(24);
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
    }
    return self;
}

- (void) dismiss {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void) done {
    if (self.doneBlock) {
        self.doneBlock();
    }
}

#pragma mark - Delegate & DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return component == 0 ? 23 : 59;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = [NSString stringWithFormat:@"%d", row + 1];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    return titleLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
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
        _startTimeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_startTimeBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
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
        _endTimeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_endTimeBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
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