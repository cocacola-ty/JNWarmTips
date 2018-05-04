//
// Created by fengtianyu on 3/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 * Cell 默认高度为40
 * */

@interface JNToDoItemCell : UITableViewCell
- (void)reloadCellWithTitle:(NSString *)taskTitle taskFinishStatus:(BOOL)taskFinished ;
- (void)refreshTaskStatus:(BOOL)taskFinished ;
@end