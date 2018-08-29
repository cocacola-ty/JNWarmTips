//
// Created by fengtianyu on 28/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JNCategoryPickerViewController : UIViewController
@property (nonatomic, strong) NSArray *categoryData;

@property (nonatomic, strong) void (^selectCategoryBlock)(NSString *categoryId, NSString *categoryName);
@end