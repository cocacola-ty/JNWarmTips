//
// Created by fengtianyu on 26/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * 日历进来的 只能选择时间，不能选择日期，日期默认是当天。
 * list进来的可以选择日期,如果list中选择的是多天的时间段，并且选择同步到日历，那么在日历中要每天都插入进去这一任务。
 *
 * tag可以选择，在日历中没有显示。如果同步到list中，会有tag。
 *
 * */

@interface JNTextView : UITextView
@property (nonatomic, strong) NSString *placeHolderStr;
@end