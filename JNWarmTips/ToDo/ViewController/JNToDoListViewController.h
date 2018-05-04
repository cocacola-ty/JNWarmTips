//
// Created by fengtianyu on 2/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * section的个数规则：
 *  1. 如果任务有时间，自动添加一个有时间安排的section，并且放到第一个。任务按时间升序显示。
 *  2. 如果当前标签的所有任务都没有时间，且没有分类。则只有一个section，就是一个list
 *  3. 如果当前标签的所有任务都没有时间，有分类，按分类显示。无序
 *
 *  1. select * from task_table where tag='life' and time!=null order by asc // 第一组数据
 *  2. select * form task_table where tag='life' group by category // 剩下的数据
 * */
@interface JNToDoListViewController : UIViewController
@end