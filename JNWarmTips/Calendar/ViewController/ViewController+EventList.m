//
// Created by fengtianyu on 24/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "ViewController+EventList.h"
#import "JNDayEventTableViewCell.h"

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
    return 2;
}

#pragma mark - Event Response

- (void) addEvent {
    NSLog(@"添加事件");
}

- (void) reloadEventList {

    NSArray *dataList = [self.allEvents objectForKey:self.currentSelectDay];
    if (dataList==nil || self.currentSelectDay.length == 0) {
        self.placeHolderLabel.hidden = NO;
        self.currentShowDateLabel.hidden = NO;
    } else {
        self.placeHolderLabel.hidden = YES;
        self.currentShowDateLabel.hidden = YES;
    }
    [self.tableView reloadData];
}
@end