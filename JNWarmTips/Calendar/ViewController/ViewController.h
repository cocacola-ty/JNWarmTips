//
//  ViewController.h
//  JNWarmTips
//
//  Created by fengtianyu on 9/4/18.
//  Copyright © 2018年 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

static const int kCollectionViewHeight = 215;

@interface ViewController : UIViewController

@property(nonatomic, assign, readonly) NSInteger currentYear;
@property(nonatomic, assign, readonly) NSInteger currentMonth;
@property(nonatomic, assign, readonly) NSInteger currentDay;
@property (nonatomic, strong) NSCache *cacheList;

@end

