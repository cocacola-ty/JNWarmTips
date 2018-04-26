//
// Created by fengtianyu on 26/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNTextView.h"
#import "View+MASAdditions.h"


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

        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
//        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.lineSpacing = 10;
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
    }
    return self;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    CGRect originalRect = [super caretRectForPosition:position];
    originalRect.size.height = self.font.lineHeight + 2;
    originalRect.size.width = 3;
    return originalRect;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [UIView new];
        _bottomLineView.backgroundColor = [UIColor blackColor];
    }
    return _bottomLineView;
}
@end