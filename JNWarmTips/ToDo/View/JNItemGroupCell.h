//
// Created by fengtianyu on 18/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JNGroupModel;


@interface JNItemGroupCell : UICollectionViewCell
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) JNGroupModel *groupModel;
@property (nonatomic, strong) NSOperation *imageTask;
@property (nonatomic, strong) void (^deleteBlock)(void);

- (void)startShake;
- (void)stopShake;
@end
