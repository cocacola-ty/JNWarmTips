//
//  JNAddEventStyleOneViewController.h
//  JNWarmTips
//
//  Created by fengtianyu on 17/7/18.
//  Copyright © 2018年 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JNEventModel;

@interface JNAddEventStyleOneViewController : UIViewController
@property(nonatomic, copy) void (^addEventBlock)(JNEventModel *eventModel);
@end
