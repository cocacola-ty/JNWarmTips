//
// Created by fengtianyu on 26/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNTextView.h"
#import "View+MASAdditions.h"
#import "JNWarmTipsPublicFile.h"


@interface JNTextView () <UITextViewDelegate >
@property (nonatomic, strong) UILabel *placeHolderLabel;
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

    NSLog(@"numOfLines = %d", numOfLines );

    NSLog(@"size.height = %lf", size.height);
    if (numOfLines <= 5) {
        textView.scrollEnabled = NO;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(size.height);
        }];
    } else {
        textView.scrollEnabled = YES;
    }
}

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

@end