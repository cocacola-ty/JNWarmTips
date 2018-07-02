//
// Created by fengtianyu on 7/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kJNDBListTable;

UIKIT_EXTERN NSString *const kJNDBEventsTable;

UIKIT_EXTERN NSString *const kJNDBGroupTable;

UIKIT_EXTERN NSString *const kJNDBCategoryTable;

UIKIT_EXTERN NSString *const kJNDBEventTypeTable;

@class FMDatabaseQueue;

@interface JNDBManager : NSObject

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

+ (instancetype) shareInstance;

- (void) createTables;

@end
