//
// Created by fengtianyu on 18/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNItemGroupCell.h"
#import "JNWarmTipsPublicFile.h"
#import "UIColor+Extension.h"
#import "JNGroupModel.h"
#import "JNItemGroupContainerView.h"

static const int kDefaultMargin = 20;

static NSString * const kAnimationKey = @"shakeAnimation";

@interface JNItemGroupCell()
@property (nonatomic, strong) JNItemGroupContainerView *containerView;

@property(nonatomic, assign) CGFloat containerViewWidth;
@property(nonatomic, assign) CGFloat containerViewHeight;
@end

@implementation JNItemGroupCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.containerViewWidth = frame.size.width - kDefaultMargin * 2;
    self.containerViewHeight = frame.size.height - kDefaultMargin * 2;

    if (self) {

        self.backgroundColor = [UIColor whiteColor];

        [self.contentView addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(kDefaultMargin);
            make.left.equalTo(self.contentView.mas_left).offset(kDefaultMargin);
            make.right.equalTo(self.contentView.mas_right).offset(-kDefaultMargin);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kDefaultMargin);
        }];
        
    }
    return self;
}

#pragma mark - Private Method


#pragma mark - Public Method

- (void)startShake {
    
    if ([self.containerView.layer animationForKey:kAnimationKey]) {
        return;
    }

    self.containerView.deleteBtn.hidden = NO;
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    shakeAnimation.keyPath = @"transform.rotation";
    shakeAnimation.values = @[@(-3 / 180.0 * M_PI), @(3 / 180.0 * M_PI), @(-3 / 180.0 * M_PI)];
    shakeAnimation.duration = 0.3;
    shakeAnimation.repeatCount = MAXFLOAT;
    shakeAnimation.fillMode = kCAFillModeForwards;
    shakeAnimation.removedOnCompletion = NO;
    [self.containerView.layer addAnimation:shakeAnimation forKey:kAnimationKey];    
}

- (void)stopShake {
    self.containerView.deleteBtn.hidden = YES;
    [self.containerView.layer removeAnimationForKey:kAnimationKey];
}

#pragma mark - Getter & Setter

- (JNItemGroupContainerView *)containerView {
    if (!_containerView) {
        _containerView = [JNItemGroupContainerView new];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 5;
        
        _containerView.layer.shadowOffset = CGSizeMake(0.5, 2);
        _containerView.layer.shadowColor = GRAY_TEXT_COLOR.CGColor;
        _containerView.layer.shadowOpacity = 0.5;
    }
    return _containerView;
}

- (void)setGroupModel:(JNGroupModel *)groupModel {
    _groupModel = groupModel;
    self.containerView.groupName = groupModel.groupName;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.containerView.image = image;
}

- (void)setDeleteBlock:(void (^)(void))deleteBlock {
    _deleteBlock = deleteBlock;
    
    self.containerView.deleteBlock = deleteBlock;
}
@end
