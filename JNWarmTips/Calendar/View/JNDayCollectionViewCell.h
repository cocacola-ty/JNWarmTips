//
// Created by fengtianyu on 10/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNDayCollectionViewCell : UICollectionViewCell
/*
 * 设置cell的内容
 * isToday : 是否为今天
 * showFlag : 当前日期是否有事件需要显示
 * */
- (void) setupContent:(NSString *)content andIsToday:(BOOL)isToday andShowFlag:(BOOL)showFlag AndColor:(NSString *)color;
@end