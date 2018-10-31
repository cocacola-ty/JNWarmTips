//
// Created by fengtianyu on 18/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNItemGroupCell.h"
#import "JNWarmTipsPublicFile.h"
#import "UIColor+Extension.h"
#import "JNGroupModel.h"

static const int kDefaultMargin = 20;

static NSString * const kAnimationKey = @"shakeAnimation";

@interface JNItemGroupCell()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *groupNameLabel;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIImage *img;

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
        
        [self.contentView addSubview:self.shadowView];
        [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(kDefaultMargin);
            make.left.equalTo(self.contentView.mas_left).offset(kDefaultMargin);
            make.right.equalTo(self.contentView.mas_right).offset(-kDefaultMargin);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kDefaultMargin);
        }];

        [self.contentView addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(kDefaultMargin);
            make.left.equalTo(self.contentView.mas_left).offset(kDefaultMargin);
            make.right.equalTo(self.contentView.mas_right).offset(-kDefaultMargin);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kDefaultMargin);
        }];

        [self.containerView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView.mas_left);
            make.right.equalTo(self.containerView.mas_right);
            make.top.equalTo(self.containerView.mas_top);
            make.bottom.equalTo(self.containerView.mas_bottom).offset(-40);
        }];

        [self.containerView addSubview:self.groupNameLabel];
        [self.groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.containerView.mas_centerX);
            make.top.equalTo(self.imageView.mas_bottom).offset(10);
        }];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage *img = [self handleImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = img;
            });
        });
    }
    return self;
}

#pragma mark - Private Method

- (UIImage *)handleImage {
    
    int num = arc4random() % 8 + 1;
    NSString *imageName = [NSString stringWithFormat:@"group_bg%d.jpg", num];
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
    UIImage *sourceImg = [UIImage imageWithContentsOfFile:path];
    NSLog(@"source width - %f, source height - %f", sourceImg.size.width, sourceImg.size.height);
    
    CGImageRef sourceImage = sourceImg.CGImage;
    
    size_t bits = CGImageGetBitsPerComponent(sourceImage);
    size_t bytesPerRow = CGImageGetBytesPerRow(sourceImage);
    CGColorSpaceRef spaceRef = CGImageGetColorSpace(sourceImage);
    uint32_t bitmapInfo = CGImageGetBitmapInfo(sourceImage);
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, 270, 280, bits, bytesPerRow, spaceRef, bitmapInfo);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationDefault);
    CGContextDrawImage(ctx, CGRectMake(0, 0, 270, 280), sourceImage);
    
    CGImageRef desImage = CGBitmapContextCreateImage(ctx);
    
    UIImage *resImage = [UIImage imageWithCGImage:desImage];
    return resImage;
}

#pragma mark - Public Method

- (void)startShake {
    
    if ([self.containerView.layer animationForKey:kAnimationKey]) {
        return;
    }
    
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    shakeAnimation.keyPath = @"transform.rotation";
    shakeAnimation.values = @[@(-3 / 180.0 * M_PI), @(3 / 180.0 * M_PI), @(-3 / 180.0 * M_PI)];
    shakeAnimation.duration = 0.3;
    shakeAnimation.repeatCount = MAXFLOAT;
    shakeAnimation.fillMode = kCAFillModeForwards;
    shakeAnimation.removedOnCompletion = NO;
    [self.containerView.layer addAnimation:shakeAnimation forKey:kAnimationKey];
    [self.shadowView.layer addAnimation:shakeAnimation forKey:kAnimationKey];
    
    
}

- (void)stopShake {
    [self.containerView.layer removeAnimationForKey:kAnimationKey];
    [self.shadowView.layer removeAnimationForKey:kAnimationKey];
}

#pragma mark - Getter & Setter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 5;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [UIView new];
        _shadowView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        _shadowView.layer.shadowOffset = CGSizeMake(0.5, 2);
        _shadowView.layer.shadowColor = GRAY_TEXT_COLOR.CGColor;
        _shadowView.layer.shadowOpacity = 0.5;
    }
    return _shadowView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleToFill;
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            int num = arc4random() % 8 + 1;
//            NSString *imageName = [NSString stringWithFormat:@"group_bg%d.jpg", num];
//            NSLog(@"%@", imageName);
//            UIImage *image = [UIImage imageNamed:imageName];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                _imageView.image = image;
//            });
//        });
    }
    return _imageView;
}

- (UILabel *)groupNameLabel {
    if (!_groupNameLabel) {
        _groupNameLabel = [UILabel new];
        _groupNameLabel.backgroundColor = [UIColor whiteColor];
        _groupNameLabel.font = [UIFont boldSystemFontOfSize:14.0];
    }
    return _groupNameLabel;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
        _deleteBtn.backgroundColor = [UIColor whiteColor];
    }
    return _deleteBtn;
}

- (void)setGroupModel:(JNGroupModel *)groupModel {
    _groupModel = groupModel;
    self.groupNameLabel.text = groupModel.groupName;
}
@end
