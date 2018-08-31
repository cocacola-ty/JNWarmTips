//
// Created by fengtianyu on 22/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JNAlertAssistant : NSObject
+ (void)alertWarningInfo:(NSString *)warningInfo;

+ (void)alertMessage:(NSString *)message WithType:(NSInteger)type;
@end