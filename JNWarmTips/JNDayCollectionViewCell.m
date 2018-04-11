//
// Created by fengtianyu on 10/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNDayCollectionViewCell.h"
#import "JNWarmTipsHeader.h"


@interface JNDayCollectionViewCell()
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIView *selectedView;
@end

@implementation JNDayCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel.frame = self.bounds;
        [self.contentView addSubview:self.textLabel];
        self.selectedBackgroundView = self.selectedView;
    }
    return self;
}

- (void) setupContent:(NSString *)content andHighLight:(BOOL)highLight andIsToday:(BOOL)isToday{
    self.textLabel.text = content;

    if (isToday) {
//        self.textLabel.layer.cornerRadius = self.frame.size.height/1.3;
//        self.textLabel.layer.masksToBounds = YES;
        self.textLabel.backgroundColor = RGB(0, 191, 255);
        self.textLabel.textColor = [UIColor whiteColor];
    }else {
        self.textLabel.textColor = highLight ? RGB(79, 79, 79) : RGB(211, 211, 211);
        self.textLabel.backgroundColor = [UIColor whiteColor];
//        self.textLabel.layer.cornerRadius = self.frame.size.height;
    }
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:14.0];
        _textLabel.textColor = RGB(79, 79, 79);
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
@end