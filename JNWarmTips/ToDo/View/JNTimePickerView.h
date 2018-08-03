//
// Created by fengtianyu on 3/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JNTimePickerView : UIView

@property(nonatomic, copy) void (^closeBlock)();
@property(nonatomic, copy) void (^doneBlock)();
@end