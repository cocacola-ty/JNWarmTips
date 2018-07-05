//
// Created by fengtianyu on 24/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

@interface ViewController (EventList) <UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate>
- (void) reloadEventList;
@end