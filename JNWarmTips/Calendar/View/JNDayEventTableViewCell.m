//
// Created by fengtianyu on 18/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNDayEventTableViewCell.h"
#import "Masonry.h"
#import "JNWarmTipsPublicFile.h"

/**
 * TODO:
 *  在cell右上角添加一个小✘，删除该条事件
 */

@interface JNDayEventTableViewCell ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *eventLabel;
@property (nonatomic, strong) UIView *dotView;
@end

@implementation JNDayEventTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGB(245, 245, 245);

        [self.containerView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView.mas_left).offset(30);
            make.top.equalTo(self.containerView.mas_top).offset(15);
        }];

        [self.containerView addSubview:self.eventLabel];
        [self.eventLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dateLabel.mas_left);
            make.right.equalTo(self.containerView.mas_right).offset(-15);
            make.bottom.equalTo(self.containerView.mas_bottom).offset(-20);
            make.top.equalTo(self.dateLabel.mas_bottom).offset(10);
        }];

        [self.containerView addSubview:self.dotView];
        [self.dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.dateLabel.mas_centerY);
            make.left.equalTo(self.containerView.mas_left).offset(11);
            make.width.and.height.mas_equalTo(8);
        }];

        [self.contentView addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(CalendarDefaultMargin);
            make.right.equalTo(self.contentView.mas_right).offset(-CalendarDefaultMargin);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.top.equalTo(self.contentView.mas_top).offset(20);
        }];

    }
    return self;
}

- (void) setDate:(NSString *)dateStr AndEventDetail:(NSString *)eventStr {
    self.dateLabel.text = dateStr;
    self.eventLabel.text = eventStr;
}

#pragma mark - Getter & Setter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 5;
    }
    return _containerView;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont systemFontOfSize:12.0];
        _dateLabel.textColor = RGB(156, 156, 156);
        _dateLabel.numberOfLines = 0;
        _dateLabel.text = @"15:28";
    }
    return _dateLabel;
}

- (UILabel *)eventLabel {
    if (!_eventLabel) {
        _eventLabel = [UILabel new];
        _eventLabel.textColor = [UIColor blackColor];
        _eventLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _eventLabel.numberOfLines = 0;
        _eventLabel.text = @"今天吃的好好吃啊,明天吃什么啊，沙发嘎嘎发ad发答案发多少暗示法司法改革1231212了开发商";
    }
    return _eventLabel;
}

- (UIView *)dotView {
    if (!_dotView) {
        _dotView = [UIView new];
        _dotView.layer.cornerRadius = 4;
        _dotView.backgroundColor = RANDOM_COLOR;
    }
    return _dotView;
}

@end
