//
// Created by fengtianyu on 30/7/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNArrowIndicateView : UIView
/*箭头颜色*/
@property (nonatomic, strong) UIColor *arrowColor;

- (void)close;

- (void)open;
@end