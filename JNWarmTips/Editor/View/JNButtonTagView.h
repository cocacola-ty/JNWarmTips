//
// Created by fengtianyu on 1/7/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNButtonTagView : UIButton
- (CGSize)setupTagName:(NSString *)tagName AndColor:(UIColor *)tagColor;

- (CGSize)setupTagName:(NSString *)tagName AndColor:(UIColor *)tagColor WithWidth:(CGFloat)width;
@end