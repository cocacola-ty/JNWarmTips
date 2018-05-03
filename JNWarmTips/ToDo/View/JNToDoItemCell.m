//
// Created by fengtianyu on 3/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNToDoItemCell.h"
#import "JNWarmTipsPublicFile.h"
#import "View+MASAdditions.h"

static const int kSelectBtnHeight = 14;

@interface JNToDoItemCell()
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UILabel *itemTitleLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JNToDoItemCell {

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.selectBtn];
        [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(14);
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.width.and.height.mas_equalTo(kSelectBtnHeight);
        }];

        [self.contentView addSubview:self.itemTitleLabel];
        [self.itemTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.selectBtn.mas_right).offset(15);
            make.top.equalTo(self.contentView.mas_top);
            make.right.equalTo(self.contentView.mas_right).offset(-40);
            make.height.mas_equalTo(40);
        }];

        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(40);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.right.equalTo(self.contentView.mas_right).offset(-40);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void) taskFinish {
//    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:self.selectBtn.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *coverLayer = [CAShapeLayer  layer];
    coverLayer.path = circlePath.CGPath;
    coverLayer.fillColor = MAIN_COLOR.CGColor;
//    [self.selectBtn.layer addSublayer:coverLayer];

    UIBezierPath *finishPath = [UIBezierPath bezierPath];
    [finishPath moveToPoint:CGPointMake(3, 8)];
    [finishPath addLineToPoint:CGPointMake(7, 11)];
    [finishPath addLineToPoint:CGPointMake(12, 3)];

    CAShapeLayer *finishLayer = [CAShapeLayer layer];
    finishLayer.path = finishPath.CGPath;
    finishLayer.strokeColor = MAIN_COLOR.CGColor;
    finishLayer.fillColor = [UIColor clearColor].CGColor;
    finishLayer.lineWidth = 2;
    finishLayer.lineJoin = kCALineJoinRound;
    finishLayer.lineCap = kCALineCapRound;
    [self.selectBtn.layer addSublayer:finishLayer];

    self.selectBtn.layer.borderColor = [UIColor clearColor].CGColor;
}

- (void) taskFinishedStatues {

}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton new];
        _selectBtn.layer.cornerRadius = kSelectBtnHeight/2;
        _selectBtn.layer.borderWidth = 1;
        _selectBtn.layer.borderColor = GRAY_TEXT_COLOR.CGColor;
        _selectBtn.backgroundColor = [UIColor whiteColor];
        [_selectBtn addTarget:self action:@selector(taskFinish) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UILabel *)itemTitleLabel {
    if (!_itemTitleLabel) {
        _itemTitleLabel = [UILabel new];
        _itemTitleLabel.textColor = RGB(36, 36, 36);
        _itemTitleLabel.text = @"要去吃饭";
    }
    return _itemTitleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = GRAY_BACKGROUND_COLOR;
    }
    return _lineView;
}

@end