//
// Created by fengtianyu on 18/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JNGroupModel;

@interface JNAddGroupAlertViewController : UIViewController
@property(nonatomic, copy) void (^finishAddGroup)(JNGroupModel *groupModel);
@end