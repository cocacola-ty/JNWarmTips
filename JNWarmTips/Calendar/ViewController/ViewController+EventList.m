//
// Created by fengtianyu on 24/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "ViewController+EventList.h"
#import "JNDayEventTableViewCell.h"
#import "JNEventEditorViewController.h"
#import "JNEventModel.h"
#import "JNDBManager.h"
#import "JNDBManager+Events.h"
#import "JNDayModel.h"
#import "JNAddEventViewController.h"

static NSString *const DayEventTableViewCellReuseId = @"DayEventTableViewCellReuseId";

@implementation ViewController (EventList)

#pragma mark - Delegate & DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JNEventModel *eventModel = self.oneDayEventsArray[indexPath.row];

    JNDayEventTableViewCell*cell = [[JNDayEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DayEventTableViewCellReuseId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    __weak typeof(self) ws = self;
    cell.deleteClickBlock = ^() {
        UIAlertController *confirmAlertController = [UIAlertController alertControllerWithTitle:@"" message:@"确定要删除这个事件?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [[JNDBManager shareInstance] deleteEvent:eventModel.eventId];
            [ws reloadEventList];
        }];
        [confirmAlertController addAction:cancleAction];
        [confirmAlertController addAction:deleteAction];

        [ws presentViewController:confirmAlertController animated:YES completion:nil];

    };
    [cell setDate:eventModel.showDate AndEventDetail:eventModel.content];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.oneDayEventsArray.count;
}

#pragma mark - Event Response

- (void) addEvent {
    NSLog(@"添加事件");

    __weak typeof(self) weakSelf = self;
    JNAddEventViewController *addEventViewController = [[JNAddEventViewController alloc] init];
    addEventViewController.finishBlock = ^(NSString *text, NSString *eventTypeId, NSString *eventTypeColor) {

        // 插入数据库
//        [[JNDBManager shareInstance] addEventContent:text AndShowDate:self.currentSelectDay];
        [[JNDBManager shareInstance] addEventContent:text AndShowDate:self.currentSelectDay AndEventTypeId:eventTypeId AndEventColor:eventTypeColor];
        [weakSelf reloadEventList];

        // 刷新日历
        weakSelf.allEventsDate = [[JNDBManager shareInstance] getAllDateAndEventColor]; // 重新拉取数据
        NSArray *selectItems = [weakSelf.collectionView indexPathsForSelectedItems];
        [weakSelf.collectionView reloadItemsAtIndexPaths:selectItems];

    };
    [self presentViewController:addEventViewController animated:YES completion:nil];

    return;

    JNEventEditorViewController *editorVc = [[JNEventEditorViewController alloc] init];
    editorVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    editorVc.placeHoladerStr = @"记录一下这天小事件...";
//    __weak typeof(self) weakSelf = self;
    
    editorVc.editFinishBlock = ^(NSString *text){
        // 插入数据库
//        [[JNDBManager shareInstance] addEventContent:text AndShowDate:self.currentSelectDay];
        [weakSelf reloadEventList];
        // 刷新日历
        NSArray *selectItems = [weakSelf.collectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = selectItems.firstObject;
        NSString *key = self.dataArray[indexPath.section];
        NSArray *monthArray = [self.cacheList objectForKey:key];
        JNDayModel *dayModel = monthArray[indexPath.row];
        dayModel.needShowFlag = YES;
        [weakSelf.collectionView reloadItemsAtIndexPaths:selectItems];
    };
    [self presentViewController:editorVc animated:YES completion:nil];
}

- (void) reloadEventList {

    self.oneDayEventsArray = [[JNDBManager shareInstance] getAllEventsOfDay:self.currentSelectDay];
    if (self.oneDayEventsArray.count == 0 || self.currentSelectDay.length == 0) {
        self.placeHolderLabel.hidden = NO;
        self.currentDateShowLabel.hidden = NO;
    } else {
        self.placeHolderLabel.hidden = YES;
        self.currentDateShowLabel.hidden = YES;
    }
    [self.tableView reloadData];
}
@end
