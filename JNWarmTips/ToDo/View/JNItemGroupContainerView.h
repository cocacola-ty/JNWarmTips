//
//  JNItemGroupContainerView.h
//  JNWarmTips
//
//  Created by fengtianyu on 3/11/2018.
//  Copyright © 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JNItemGroupContainerView : UIView

@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) void (^deleteBlock)(void);

@end

NS_ASSUME_NONNULL_END
