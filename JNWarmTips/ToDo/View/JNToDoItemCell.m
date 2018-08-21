//
// Created by fengtianyu on 3/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNToDoItemCell.h"
#import "JNWarmTipsPublicFile.h"
#import "View+MASAdditions.h"

static const int kSelectBtnHeight = 8;

@interface JNToDoItemCell()
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UILabel *itemTitleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) CAShapeLayer *finishLayer;
@end

@implementation JNToDoItemCell {

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFont) name:FONT_DOWNLOAD_NOTIFICATION object:nil];

        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.selectBtn];
        [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(16); // (40 - kselectBtnHeight) / 2 40是cell的高度
            make.left.equalTo(self.contentView.mas_left).offset(40);
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
            make.left.equalTo(self.contentView.mas_left).offset(60);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.right.equalTo(self.contentView.mas_right).offset(-40);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)reloadCellWithTitle:(NSString *)taskTitle taskFinishStatus:(BOOL)taskFinished {
    self.itemTitleLabel.text = taskTitle;
    [self refreshTaskStatus:taskFinished];
}

- (void)refreshTaskStatus:(BOOL)taskFinished {
    if (taskFinished) {
        self.selectBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [self.selectBtn.layer addSublayer:self.finishLayer];
        self.itemTitleLabel.textColor = GRAY_TEXT_COLOR;
    } else {
        self.selectBtn.layer.borderColor = GRAY_TEXT_COLOR.CGColor;
        [self.finishLayer removeFromSuperlayer];
        self.itemTitleLabel.textColor = RGB(36, 36, 36);
    }
}

- (void) refreshFont {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.itemTitleLabel.font = [UIFont fontWithName:FONT_NAME_YAPI size:16.];
    });
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
        _itemTitleLabel.font = [UIFont fontWithName:FONT_NAME_YAPI size:16.0];
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

- (CAShapeLayer *)finishLayer {
    if (!_finishLayer) {

        UIBezierPath *finishPath = [UIBezierPath bezierPath];
        [finishPath moveToPoint:CGPointMake(3, 8)];
        [finishPath addLineToPoint:CGPointMake(7, 11)];
        [finishPath addLineToPoint:CGPointMake(12, 3)];

        _finishLayer = [CAShapeLayer layer];
        _finishLayer.path = finishPath.CGPath;
        _finishLayer.strokeColor = MAIN_COLOR.CGColor;
        _finishLayer.fillColor = [UIColor clearColor].CGColor;
        _finishLayer.lineWidth = 2;
        _finishLayer.lineJoin = kCALineJoinRound;
        _finishLayer.lineCap = kCALineCapRound;
    }
    return _finishLayer;
}

@end