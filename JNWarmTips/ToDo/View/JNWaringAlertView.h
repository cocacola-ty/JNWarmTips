//
// Created by fengtianyu on 4/7/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JNWaringAlertView : UIView
@property (nonatomic, strong) NSString *alertText;
@property(nonatomic, copy) void (^confirmBlock)(void);
@property(nonatomic, copy) void (^cancleBlock)(void);

@end