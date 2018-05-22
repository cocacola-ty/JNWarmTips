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
        [[JNDBManager shareInstance] deleteEvent:eventModel.eventId];
        [ws reloadEventList];
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
    JNEventEditorViewController *editorVc = [[JNEventEditorViewController alloc] init];
    editorVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    editorVc.placeHoladerStr = @"记录一下这天小事件...";
    __weak typeof(self) weakSelf = self;
    
    editorVc.editFinishBlock = ^(NSString *text){
        // 插入数据库
        [[JNDBManager shareInstance] addEventContent:text AndShowDate:self.currentSelectDay];
        [weakSelf reloadEventList];

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
