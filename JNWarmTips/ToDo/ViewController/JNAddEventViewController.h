//
// Created by fengtianyu on 29/6/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JNAddEventViewController : UIViewController
@property(nonatomic, copy) void (^finishBlock)(NSString *text, NSString *eventTypeId, NSString *eventTypeColor);
@end