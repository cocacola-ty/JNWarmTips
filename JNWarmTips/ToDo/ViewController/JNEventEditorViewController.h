//
// Created by fengtianyu on 25/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNEventEditorViewController : UIViewController
@property (nonatomic, strong) NSString *placeHoladerStr;

@property (nonatomic, copy, nonnull) void(^editFinishBlock());
@end