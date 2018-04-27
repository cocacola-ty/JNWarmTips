//
// Created by fengtianyu on 26/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNTextView.h"
#import "View+MASAdditions.h"
#import "JNWarmTipsPublicFile.h"


@interface JNTextView () <UITextViewDelegate >
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) UIView *bottomLineView;
@end

@implementation JNTextView {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.font = [UIFont systemFontOfSize:17.0];
        self.backgroundColor = [UIColor greenColor];
        self.delegate = self;
        self.scrollEnabled = NO;

        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 8;
        NSDictionary *attributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:17.0],
                NSParagraphStyleAttributeName : paragraphStyle,
        };
        self.typingAttributes = attributes;

        [self addSubview:self.bottomLineView];
        [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(1);
        }];

        NSLog(@"self.textContainerInset.top = %lf", self.textContainerInset.top);
        NSLog(@"self.textContainerInset.bottom = %lf", self.textContainerInset.bottom);
        NSLog(@"self.textContainerInset.left = %lf", self.textContainerInset.left);
        NSLog(@"self.font.lineHeight = %lf", self.font.lineHeight);
        NSLog(@"self.font.pointSize = %lf", self.font.pointSize);
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
    int numOfLines = (int )(linesHeight / singleLineHeight);

    NSLog(@"numOfLines = %d", numOfLines );

//    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, size.width, size.height);
    NSLog(@"size.height = %lf", size.height);
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height);
    }];
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [UIView new];
        _bottomLineView.backgroundColor = [UIColor blackColor];
    }
    return _bottomLineView;
}
@end