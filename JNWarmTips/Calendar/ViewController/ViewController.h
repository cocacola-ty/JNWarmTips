//
//  ViewController.h
//  JNWarmTips
//
//  Created by fengtianyu on 9/4/18.
//  Copyright © 2018年 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JNEventModel;

static const int kCollectionViewHeight = 215;

@interface ViewController : UIViewController

@property(nonatomic, assign, readonly) NSInteger currentYear;
@property(nonatomic, assign, readonly) NSInteger currentMonth;
@property(nonatomic, assign, readonly) NSInteger currentDay;
@property (nonatomic, strong) NSCache *cacheList;

@property(nonatomic, strong) NSString *currentSelectDay;

// 事件列表
@property (nonatomic, strong) NSString *eventsListPath;
@property (nonatomic, strong) NSArray<JNEventModel *> *oneDayEventsArray;
@property (nonatomic, strong) NSMutableArray *eventsArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) UILabel *currentDateShowLabel;
@end

