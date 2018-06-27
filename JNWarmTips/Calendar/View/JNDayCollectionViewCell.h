//
// Created by fengtianyu on 10/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNDayCollectionViewCell : UICollectionViewCell
/*
 * 设置cell的内容
 * highlight ： 文字是否高亮显示 用于区分不是当月的日期
 * isToday : 是否为今天
 * showFlag : 当前日期是否有事件需要显示
 * */
- (void) setupContent:(NSString *)content andHighLight:(BOOL)highLight andIsToday:(BOOL)isToday andShowFlag:(BOOL)showFlag;
@end