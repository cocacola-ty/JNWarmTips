//
// Created by fengtianyu on 24/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "ViewController+EventList.h"
#import "JNWarmTipsPublicFile.h"
#import "JNDayEventTableViewCell.h"
#import "JNEventEditorViewController.h"
#import "JNEventModel.h"
#import "JNDBManager.h"
#import "JNDBManager+Events.h"
#import "JNDayModel.h"
#import "JNAddEventViewController.h"
#import "JNAddEventTransitionAnimator.h"
#import "JNAddEventsViewController.h"
#import "JNAddEventStyleOneViewController.h"
#import "JNCalendarAssistant.h"

static NSString *const DayEventTableViewCellReuseId = @"DayEventTableViewCellReuseId";

@implementation ViewController (EventList)

#pragma mark - Delegate & DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JNEventModel *eventModel = self.oneDayEventsArray[indexPath.row];

    JNDayEventTableViewCell*cell = [[JNDayEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DayEventTableViewCellReuseId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    @weakify(self)
    cell.deleteClickBlock = ^() {
        @strongify(self)
        UIAlertController *confirmAlertController = [UIAlertController alertControllerWithTitle:@"" message:@"确定要删除这个事件?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [[JNDBManager shareInstance] deleteEvent:eventModel.eventId];
            [self reloadEventList];
        }];
        [confirmAlertController addAction:cancleAction];
        [confirmAlertController addAction:deleteAction];

        [self presentViewController:confirmAlertController animated:YES completion:nil];
    };
    NSString *showDate = eventModel.showDate;
    if (eventModel.startTime != 0) {
        [JNCalendarAssistant shareInstance].dateFormatter.dateFormat = @"HH:mm";
        NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:eventModel.startTime];
        NSString *startTimeStr = [[JNCalendarAssistant shareInstance].dateFormatter stringFromDate:startTime];
        showDate = [NSString stringWithFormat:@"%@", startTimeStr];

        if (eventModel.endTime != 0) {
            [JNCalendarAssistant shareInstance].dateFormatter.dateFormat = @"HH:mm";
            NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:eventModel.endTime];
            NSString *endTimeStr = [[JNCalendarAssistant shareInstance].dateFormatter stringFromDate:endTime];

            showDate = [NSString stringWithFormat:@"%@ - %@", startTimeStr, endTimeStr];
        }
    }
    [cell setDate:showDate AndEventDetail:eventModel.content];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.oneDayEventsArray.count;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[JNAddEventTransitionAnimator alloc] initWithType:JNTransitionTypePresent];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[JNAddEventTransitionAnimator alloc] initWithType:JNTransitionTypeDismiss];
}

#pragma mark - Event Response

- (void) addEvent {

    NSInteger selectStyle = 1;

    switch (selectStyle) {
        case 1: {
            @weakify(self)
            JNAddEventStyleOneViewController *addEventStyleOneViewController = [JNAddEventStyleOneViewController new];
            addEventStyleOneViewController.selectedDate = self.currentSelectDay;
            addEventStyleOneViewController.addEventBlock = ^(JNEventModel *eventModel) {
                @strongify(self)
                eventModel.showDate = self.currentSelectDay;
                [[JNDBManager shareInstance] addEventWithModel:eventModel];
                [self reloadEventList];

                self.allEventsDate = [[JNDBManager shareInstance] getAllDateAndEventColor];
                NSArray *selectItems = [self.collectionView indexPathsForSelectedItems];
                [self.collectionView reloadItemsAtIndexPaths:selectItems];
            };
            [self presentViewController:addEventStyleOneViewController animated:YES completion:nil];
        }
            break;
        case 2: {
            JNAddEventsViewController *addEventsViewController = [[JNAddEventsViewController alloc] init];
            addEventsViewController.transitioningDelegate = self;
            [self presentViewController:addEventsViewController animated:YES completion:nil];
        }
            break;
        default: {
            __weak typeof(self) weakSelf = self;
            JNAddEventViewController *addEventViewController = [[JNAddEventViewController alloc] init];
            addEventViewController.transitioningDelegate = self;
            addEventViewController.finishBlock = ^(NSString *text, NSString *eventTypeId, NSString *eventTypeColor) {

                // 插入数据库
                [[JNDBManager shareInstance] addEventContent:text AndShowDate:self.currentSelectDay AndEventTypeId:eventTypeId AndEventColor:eventTypeColor];
                [weakSelf reloadEventList];

                // 刷新日历
                weakSelf.allEventsDate = [[JNDBManager shareInstance] getAllDateAndEventColor]; // 重新拉取数据
                NSArray *selectItems = [weakSelf.collectionView indexPathsForSelectedItems];
                [weakSelf.collectionView reloadItemsAtIndexPaths:selectItems];

            };
        }
    }

    return;

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
