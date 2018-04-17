//
// Created by fengtianyu on 10/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNDayCollectionViewCell : UICollectionViewCell
- (void) setupContent:(NSString *)content andHighLight:(BOOL)highLight andIsToday:(BOOL)isToday;
@end