//
// Created by fengtianyu on 20/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNTopContainerView.h"
#import "Masonry.h"
#import "JNWarmTipsHeader.h"

@interface JNTopContainerView()
@property (nonatomic, strong) UILabel *dateLabel;
@end

@implementation JNTopContainerView {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        [self addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(20);
            make.left.equalTo(self.mas_left).offset(15);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont fontWithName:@"Courier-Bold" size:26.0];
        _dateLabel.textColor = RGB(255, 54, 79);
        _dateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _dateLabel;
}
@end