//
// Created by fengtianyu on 5/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNAddEventCellView : UIView

@property (nonatomic, strong) NSString *title;

- (instancetype)initWithTitle:(NSString *)title WithIconImageName:(NSString *)imageName;

@end