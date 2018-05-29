//
// Created by fengtianyu on 2/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * 如果该tag下没有item , 默认显示，快去添加吧
 * */

@interface JNToDoGroupListViewController : UIViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *currentSelectIndexPath;
@property (nonatomic, strong) UIImage *cellBackGroundImage;
@end