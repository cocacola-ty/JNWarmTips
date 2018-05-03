//
// Created by fengtianyu on 3/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNToDoItemCell.h"
#import "JNWarmTipsPublicFile.h"
#import "View+MASAdditions.h"

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
        [self.contentView addSubview:self.selectBtn];
        [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(14);
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.width.and.height.mas_equalTo(12);
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

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton new];
        _selectBtn.layer.cornerRadius = 6.0;
        _selectBtn.layer.borderWidth = 1;
        _selectBtn.layer.borderColor = GRAY_TEXT_COLOR.CGColor;
        _selectBtn.backgroundColor = [UIColor whiteColor];
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