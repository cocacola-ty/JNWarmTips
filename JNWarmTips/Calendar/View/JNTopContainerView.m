//
// Created by fengtianyu on 20/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNTopContainerView.h"
#import "Masonry.h"
#import "JNWarmTipsPublicFile.h"

@interface JNTopContainerView() {
    NSInteger month;
}
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *yearLabel;

@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation JNTopContainerView {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
        }];

        [self addSubview:self.dayLabel];
        [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dateLabel.mas_right).offset(5);
            make.centerY.equalTo(self.dateLabel.mas_centerY);
        }];

        [self addSubview:self.yearLabel];
        [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dayLabel.mas_right).offset(5);
            make.centerY.equalTo(self.dateLabel.mas_centerY);
        }];

        [self addSubview:self.rightBtn];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.height.mas_equalTo(30);
        }];
    }
    return self;
}

- (void)setContent:(NSInteger)year AndDay:(NSInteger)day AndMonth:(NSInteger)month {
//    NSArray *monthTextArray = @[@"", @"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月"];
    NSArray *monthEnglishTextArray = @[@"", @"JAN", @"FEB", @"MAR", @"APR", @"MAY", @"JUNE", @"JULY", @"AUG", @"SEPT", @"OCT", @"NOV", @"DEC"];

    if (month <= 12 && month >= 1) {
//        NSString *monthText = monthTextArray[month];
        NSString *monthText =monthEnglishTextArray[month];
        self.dateLabel.text = monthText;
    }
    self.dayLabel.text = [NSString stringWithFormat:@"%li",day];
    self.yearLabel.text = [NSString stringWithFormat:@"%li \ntoday", year];
}

- (void)btnAction {
    if (self.rightBtnActionBlock) {
        self.rightBtnActionBlock();
    }
}



- (void)motionBegan:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event {
    NSLog(@"topView get motion event ");
 }


- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont fontWithName:@"Menlo-Bold" size:28.0];
        _dateLabel.textColor = RGB(255, 54, 79);
        _dateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _dateLabel;
}

- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [UILabel new];
        _dayLabel.font = [UIFont fontWithName:@"Menlo-Bold" size:28.0];
        _dayLabel.textColor = RGB(255, 54, 79);
        _dayLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _dayLabel;
}

- (UILabel *)yearLabel {
    if (!_yearLabel) {
        _yearLabel = [UILabel new];
        _yearLabel.font = [UIFont fontWithName:@"Menlo" size:12.0];
        _yearLabel.textColor = RGB(255, 54, 79);
        _yearLabel.numberOfLines = 0;
        _yearLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _yearLabel;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton new];
        [_rightBtn setImage:[UIImage imageNamed:@"event_list"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
@end
