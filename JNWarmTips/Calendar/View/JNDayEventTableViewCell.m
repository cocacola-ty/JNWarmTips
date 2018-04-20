//
// Created by fengtianyu on 18/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNDayEventTableViewCell.h"


@interface JNDayEventTableViewCell ()
@property (nonatomic, strong) UIView *containerView;
@end

@implementation JNDayEventTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.containerView];
    }
    return self;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
    }
    return _containerView;
}

@end