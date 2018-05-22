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
//    NSArray *eventsList = [self.oneDayEventsArray objectForKey:self.currentSelectDay];
//    NSString *event = eventsList[indexPath.row];
    JNEventModel *eventModel = self.oneDayEventsArray[indexPath.row];


//    NSString *eventStr;
//    NSString *dateStr;
//    if (range.length != 0) {
//        eventStr = [event substringFromIndex:range.location+1];
//        dateStr = [event substringToIndex:range.location];
//    } else {
//        eventStr = event;
//        dateStr = self.currentSelectDay;
//    };

    JNDayEventTableViewCell*cell = [[JNDayEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DayEventTableViewCellReuseId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
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
