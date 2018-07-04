//
// Created by fengtianyu on 10/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNDayCollectionViewCell.h"
#import "JNWarmTipsPublicFile.h"
#import "View+MASAdditions.h"
#import "UIColor+Extension.h"


@interface JNDayCollectionViewCell()
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic, strong) UIView *markView;
@end

@implementation JNDayCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel.bounds = CGRectMake(0, 0, self.bounds.size.width - 5, self.bounds.size.height - 5);
        self.textLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        [self.contentView addSubview:self.textLabel];
        self.selectedBackgroundView = self.selectedView;

        [self.contentView addSubview:self.markView];
        [self.markView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(4);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-4);
        }];
        self.markView.layer.cornerRadius = 2;
    }
    return self;
}

- (void) setupContent:(NSString *)content andIsToday:(BOOL)isToday andShowFlag:(BOOL)showFlag AndColor:(NSString *)color{
    self.textLabel.text = content;

    self.markView.hidden = !showFlag;
    self.markView.backgroundColor = [UIColor colorWithHexString:color];

    if (isToday) {
        self.textLabel.backgroundColor = RGB(0, 191, 255);
        self.textLabel.textColor = [UIColor whiteColor];
    }else {
        self.textLabel.textColor = RGB(79, 79, 79);
        self.textLabel.backgroundColor = [UIColor whiteColor];
    }

    self.textLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:16.0];
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:14.0];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (UIView *)selectedView {
    if (!_selectedView) {
        _selectedView = [UIView new];
        _selectedView.layer.borderColor = RGB(255, 140, 0).CGColor;
        _selectedView.layer.borderWidth = 2;
    }
    return _selectedView;
}

- (UIView *)markView {
    if (!_markView) {
        _markView = [UIView new];
        _markView.backgroundColor = RANDOM_COLOR;
        _markView.hidden = YES;
    }
    return _markView;
}
@end