//
// Created by fengtianyu on 18/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNDayEventTableViewCell : UITableViewCell
- (void) setDate:(NSString *)dateStr AndEventDetail:(NSString *)eventStr;

@property(nonatomic, copy) void (^deleteClickBlock)(void);
@end
