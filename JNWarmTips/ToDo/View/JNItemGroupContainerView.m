//
//  JNItemGroupContainerView.m
//  JNWarmTips
//
//  Created by fengtianyu on 3/11/2018.
//  Copyright © 2018 fengtianyu. All rights reserved.
//

#import "JNItemGroupContainerView.h"
#import <Masonry/View+MASAdditions.h>

@interface JNItemGroupContainerView()
@property (nonatomic, strong) UILabel *groupNameLabel;

@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation JNItemGroupContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(-40);
        }];
        
        [self addSubview:self.groupNameLabel];
        [self.groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.imageView.mas_bottom).offset(10);
        }];
        
        [self addSubview:self.deleteBtn];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_right);
            make.centerY.equalTo(self.mas_top);
            make.width.height.mas_equalTo(22);
        }];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL flag = NO;
    
    for (UIView *subView in self.subviews) {
        if (CGRectContainsPoint(subView.frame, point)) {
            flag = YES;
        }
    }
    
    return flag;
}

- (void) deleteAction {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

#pragma mark - Getter & Setter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.backgroundColor = [UIColor clearColor];
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
        [_deleteBtn setImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        _deleteBtn.backgroundColor = [UIColor whiteColor];
        _deleteBtn.layer.cornerRadius = 11;
        _deleteBtn.layer.masksToBounds = YES;
        _deleteBtn.hidden = YES;
        [_deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (void)setGroupName:(NSString *)groupName {
    _groupName = groupName;
    self.groupNameLabel.text = groupName;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = image;
    });
}

@end
