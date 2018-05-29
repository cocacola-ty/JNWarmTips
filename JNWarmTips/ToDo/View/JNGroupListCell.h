//
// Created by fengtianyu on 6/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JNGroupListCell : UITableViewCell
@property (nonatomic, strong) UIImage *backgroundImage;
- (void) updateContentWithTitle:(NSString *)title WithItemTitle:(NSString *)itemTitle WithItemCount:(NSInteger)itemCount;
@end