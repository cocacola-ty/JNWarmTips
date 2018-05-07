//
// Created by fengtianyu on 26/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNTextView.h"
#import "View+MASAdditions.h"
#import "JNWarmTipsPublicFile.h"


@interface JNTextView () <UITextViewDelegate >
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) UIView *accessoryView;
@end

@implementation JNTextView {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.font = [UIFont systemFontOfSize:17.0];
        self.backgroundColor = [UIColor clearColor];
        self.textColor = RGB(54, 54, 54);
        self.delegate = self;
        self.scrollEnabled = NO;
        self.layoutManager.allowsNonContiguousLayout = NO;
//        UIView *accessoryView = [UIView new];
//        accessoryView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 40);
//        accessoryView.backgroundColor = RANDOM_COLOR;
        self.inputAccessoryView = self.accessoryView;

        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 8;
        NSDictionary *attributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:17.0],
                NSParagraphStyleAttributeName : paragraphStyle,
        };
        self.typingAttributes = attributes;

        [self addSubview:self.placeHolderLabel];
        [self setValue:self.placeHolderLabel forKey:@"_placeholderLabel"];

    }
    return self;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    CGRect originalRect = [super caretRectForPosition:position];
    originalRect.size.height = self.font.lineHeight + 2;
    originalRect.size.width = 3;
    return originalRect;
}

- (void)textViewDidChange:(UITextView *)textView {
    CGSize size = [textView sizeThatFits:CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT)];

    CGFloat linesHeight = size.height - textView.textContainerInset.top;
    CGFloat singleLineHeight = textView.font.lineHeight + 8;
    int numOfLines = (int)(linesHeight / singleLineHeight);

    if (numOfLines <= 5) {
        textView.scrollEnabled = NO;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(size.height);
        }];
    } else {
        textView.scrollEnabled = YES;
    }
}

#pragma mark - Getter & Setter

- (void)setPlaceHolderStr:(NSString *)placeHolderStr {
    _placeHolderStr = placeHolderStr;
    self.placeHolderLabel.text = placeHolderStr;
}

- (UILabel *)placeHolderLabel {
    if (!_placeHolderLabel) {
        _placeHolderLabel = [UILabel new];
        _placeHolderLabel.font = [UIFont italicSystemFontOfSize:15.0];
        _placeHolderLabel.textColor = GRAY_TEXT_COLOR;
    }
    return _placeHolderLabel;
}

- (UIView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [UIView new];
        _accessoryView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 35);
        _accessoryView.backgroundColor = [UIColor clearColor];

        UIButton *timeBtn = [UIButton new];
//        timeBtn.backgroundColor = RANDOM_COLOR;
        [timeBtn setTitle:@"time" forState:UIControlStateNormal];
        [timeBtn setTitleColor:GRAY_TEXT_COLOR forState:UIControlStateNormal];
        timeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        timeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_accessoryView addSubview:timeBtn];
        [timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_accessoryView.mas_left);
            make.top.equalTo(_accessoryView.mas_top);
            make.bottom.equalTo(_accessoryView.mas_bottom);
            make.width.mas_equalTo(60);
        }];

        UIButton *tagBtn = [UIButton new];
//        tagBtn.backgroundColor = RANDOM_COLOR;
        [tagBtn setTitle:@"group" forState:UIControlStateNormal];
        [tagBtn setTitleColor:GRAY_TEXT_COLOR forState:UIControlStateNormal];
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        tagBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_accessoryView addSubview:tagBtn];
        [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(timeBtn.mas_right);
            make.top.equalTo(_accessoryView.mas_top);
            make.bottom.equalTo(_accessoryView.mas_bottom);
            make.width.mas_equalTo(60);
        }];
    }
    return _accessoryView;
}

@end