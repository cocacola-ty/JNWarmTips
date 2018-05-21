//
// Created by fengtianyu on 24/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "ViewController+EventList.h"
#import "JNDayEventTableViewCell.h"
#import "JNEventEditorViewController.h"

static NSString *const DayEventTableViewCellReuseId = @"DayEventTableViewCellReuseId";

@implementation ViewController (EventList)

#pragma mark - Delegate & DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *eventsList = [self.allEvents objectForKey:self.currentSelectDay];
    NSString *event = eventsList[indexPath.row];
    NSRange range = [event rangeOfString:@"-"];

    NSString *eventStr;
    NSString *dateStr;
    if (range.length != 0) {
        eventStr = [event substringFromIndex:range.location+1];
        dateStr = [event substringToIndex:range.location];
    } else {
        eventStr = event;
        dateStr = self.currentSelectDay;
    };

    JNDayEventTableViewCell*cell = [[JNDayEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DayEventTableViewCellReuseId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    [cell setDate:dateStr AndEventDetail:eventStr];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *eventsList = [self.allEvents objectForKey:self.currentSelectDay];
    return eventsList.count;
}

#pragma mark - Event Response

- (void) addEvent {
    NSLog(@"添加事件");
    JNEventEditorViewController *editorVc = [[JNEventEditorViewController alloc] init];
    editorVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    editorVc.placeHoladerStr = @"记录一下这天小事件...";
    __weak typeof(self) weakSelf = self;
    
    editorVc.editFinishBlock = ^(NSString *text){
        NSString *key = weakSelf.currentSelectDay;
        NSMutableArray *events = [weakSelf.allEvents valueForKey:key];
        if (events) {
            [events addObject:text];

        }else {
            [weakSelf.allEvents setValue:@[text] forKey:weakSelf.currentSelectDay];
        }
        [weakSelf.allEvents writeToFile:weakSelf.eventsListPath atomically:YES];
        [weakSelf reloadEventList];
        
        // 插入数据库
        
        
    };
    [self presentViewController:editorVc animated:YES completion:nil];
}

- (void) reloadEventList {

    NSArray *dataList = [self.allEvents objectForKey:self.currentSelectDay];
    if (dataList==nil || self.currentSelectDay.length == 0) {
        self.placeHolderLabel.hidden = NO;
        self.currentDateShowLabel.hidden = NO;
    } else {
        self.placeHolderLabel.hidden = YES;
        self.currentDateShowLabel.hidden = YES;
    }
    [self.tableView reloadData];
}
@end
