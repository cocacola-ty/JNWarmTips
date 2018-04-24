//
//  ViewController.m
//  JNWarmTips
//
//  Created by fengtianyu on 9/4/18.
//  Copyright © 2018年 fengtianyu. All rights reserved.
//

/*
 * 初始化获取当前日前及前后两个月的日期
 * 随着向上/下翻 加载上/下一个月的日期
 * 最多缓存一年的日期 缓存当前查看日期的前后各六个月日期  获取过不再重复获取
 * 点击回到今天 清空缓存
 *
 * dataArray : 数据源 [@"2018-4", @"2018-5"] 通过key去cacheList中去取对应月份的数组
 * dataArrayInit : 最初始化的数据源 点击回到今天后重置的
 * cacheList : 加载过后缓存下来的日期 @"2018-04" : @[...]
 *
 * 事件格式：
 *   @{
 *      @"2018-4-23" ： @[@"15:04-今天没有什么事", @"今天真的没有什么事"]
 *   }
 *   以'-'分割，如果有时间，显示2018-4-23 15：04 如果没有只显示日期
 *
 */

#import "ViewController.h"
#import "ViewController+CalculateCalendar.h"
#import "JNTopContainerView.h"
#import "JNDayModel.h"
#import "JNWarmTipsPublicFile.h"
#import "JNDayCollectionViewCell.h"
#import "JNDayEventTableViewCell.h"
#import "Masonry.h"
#import <CoreText/CTFont.h>

static NSString *const DayEventTableViewCellReuseId = @"DayEventTableViewCellReuseId";
static CGFloat kTopContainerViewHeight = 64;
static CGFloat kWeekViewHeight = 30;

static CGFloat kItemCount = 7;
static NSString *CalCollectionViewCellReuseId = @"CalCollectionViewCellReuseId";

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) JNTopContainerView *topContainerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *weekView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataArrayInit;
@property(nonatomic, assign) NSInteger currentShowMonth;
@property(nonatomic, strong) NSString *currentSelectDay;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray *> *allEvents;
@property (nonatomic, strong) NSString *eventsListPath;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) UILabel *currentShowDateLabel;

@property (nonatomic, strong) UIImageView *addEventImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    // 初始化设置
    self.cacheList = [[NSCache alloc] init];
    [self initDataSource];

    self.currentShowMonth = self.currentMonth;
    self.currentSelectDay = [NSString stringWithFormat:@"%li-%li-%li", self.currentYear, self.currentMonth, self.currentDay];

    // 布局
    self.navigationController.navigationBar.hidden = YES;

    [self.topContainerView setContent:self.currentYear AndDay:self.currentDay AndMonth:self.currentMonth];
    [self.view addSubview:self.topContainerView];
    [self.topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(kTopContainerViewHeight);
    }];

    [self.view addSubview:self.weekView];
    [self.weekView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topContainerView.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(kWeekViewHeight);
    }];

    // 添加日历
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[JNDayCollectionViewCell class] forCellWithReuseIdentifier:CalCollectionViewCellReuseId];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weekView.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(kCollectionViewHeight);
    }];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];

    UIView *blankView = [UIView new];
    blankView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:blankView];
    [blankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.collectionView.mas_bottom);
        make.height.mas_equalTo(20);
    }];

    // 添加事件列表
    self.allEvents = [NSMutableDictionary dictionaryWithContentsOfFile:self.eventsListPath];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[JNDayEventTableViewCell class] forCellReuseIdentifier:DayEventTableViewCellReuseId];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blankView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.currentShowDateLabel.text = [NSString stringWithFormat:@"%li年 %li月 %li日", self.currentYear, self.currentMonth, self.currentDay];
    [self reloadEventList];

    [self downFont];

    [self.view addSubview:self.addEventImageView];
    [self.addEventImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.right.equalTo(_tableView.mas_right).offset(-20);
        make.bottom.equalTo(_tableView.mas_bottom).offset(-60);
    }];
}

#pragma mark - Private Method

- (void) initDataSource {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitDay fromDate:currentDate];
    _currentMonth = components.month;
    _currentYear = components.year;
    _currentDay = components.day;

    NSArray *lastMonthArray = [self getAllDaysOfMonth:self.currentMonth - 1 InYear:self.currentYear];
    NSString *lastMonthKey = [self getLastMonth:self.currentMonth currentYear:self.currentYear];

    [self.cacheList setObject:lastMonthArray forKey:lastMonthKey];
    [self.dataArray addObject:lastMonthKey];

    NSArray *currentMonthArray = [self getAllDaysOfMonth:self.currentMonth InYear:self.currentYear];
    NSString *currentMonthKey = [NSString stringWithFormat:@"%ld-%ld", self.currentYear, self.currentMonth];
    [self.cacheList setObject:currentMonthArray forKey:currentMonthKey];
    [self.dataArray addObject:currentMonthKey];

    NSArray *nextMonthArray = [self getAllDaysOfMonth:self.currentMonth + 1 InYear:self.currentYear];
    NSString *nextMonthKey = [self getNextMonth:self.currentMonth currentYear:self.currentYear];
    [self.cacheList setObject:nextMonthArray forKey:nextMonthKey];
    [self.dataArray addObject:nextMonthKey];

}

- (CGSize) caculatorItemSize {
    CGFloat width = (SCREEN_WIDTH-21) / kItemCount;
    CGFloat height = kCollectionViewHeight / 5;
    return CGSizeMake(width, height);
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

- (void) downFont {

    NSString *fontName = @"DFWaWaSC-W5";
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);

    CTFontDescriptorMatchFontDescriptorsWithProgressHandler((__bridge CFArrayRef)descs, NULL, ^bool(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
        // 字体已经匹配
        if (state == kCTFontDescriptorMatchingDidBegin) {
            NSLog(@"开始匹配");
        } else if (state == kCTFontDescriptorMatchingDidFinish) { // 下载完成
            dispatch_async(dispatch_get_main_queue(), ^{
                self.placeHolderLabel.font = [UIFont fontWithName:fontName size:15.0];
                self.currentShowDateLabel.font = [UIFont fontWithName:fontName size:12.0];
            });
            NSLog(@"匹配完成");
        } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) { // 开始下载
        } else if (state == kCTFontDescriptorMatchingDownloading) { // 下载中
            NSLog(@"download....");
            NSLog(@"progressValue = %lf", progressValue);
        } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
            NSLog(@"download done ");
        } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
            NSLog(@"error.userInfo = %@", error.userInfo);
            NSLog(@"error");
        }

        return (bool)YES;
    });
}

- (void) addEvent {
    NSLog(@"添加事件");
}

#pragma mark - Delegate & DataSources

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JNDayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CalCollectionViewCellReuseId forIndexPath:indexPath];

    NSString *key = self.dataArray[indexPath.section];
    NSArray *monthArray = [self.cacheList objectForKey:key];
    JNDayModel *dayModel = monthArray[indexPath.row];

    [cell setupContent:dayModel.day andHighLight:dayModel.isCurrentMonth andIsToday:dayModel.isToday];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 35;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did select");

    NSString *key = self.dataArray[indexPath.section];
    NSArray *monthArray = [self.cacheList objectForKey:key];
    JNDayModel *dayModel = monthArray[indexPath.row];

    self.currentSelectDay = [NSString stringWithFormat:@"%@-%@-%@", dayModel.year, dayModel.month, dayModel.day];
    [self reloadEventList];

    self.currentShowDateLabel.text = [NSString stringWithFormat:@"%@年 %@月 %@日", dayModel.year, dayModel.month, dayModel.day];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSArray *indexPathArray = [self.collectionView indexPathsForVisibleItems];

    // 找到最多的section
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (NSIndexPath *indexpath in indexPathArray) {
        NSNumber *number = [NSNumber numberWithUnsignedInteger:indexpath.section];
        if ([[dictionary allKeys] containsObject:number]) {
            NSInteger value = [[dictionary objectForKey:number] integerValue];
            value += 1;
            [dictionary setValue:@(value) forKey:number];
        } else {
            [dictionary setValue:@(1) forKey:number];
        }
    }

    // 对字典排序
    NSArray *sortKeys = [dictionary keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return (NSComparisonResult) (result == NSOrderedAscending);
    }];
    NSInteger section = [sortKeys.firstObject integerValue];

    NSString *key = self.dataArray[section];
    NSRange range = [key rangeOfString:@"-"];
    NSString *month = [key substringFromIndex:range.location+1];
    NSString *year = [key substringWithRange:NSMakeRange(0, 4)];
    NSInteger willShowMonth = [month integerValue];
    NSInteger willShowYear = [year integerValue];
    self.navigationItem.title = [NSString stringWithFormat:@"%@月",month];

    // 加载下一个要显示月份到数据源 检查要加载的是否在数据源中已经存在，如果存在则不加载, 否则添加到数据源中
    NSInteger currentIndex = [self.dataArray indexOfObject:key];
    if (willShowMonth < self.currentShowMonth || (willShowMonth == 12 && self.currentShowMonth == 1)) {
        NSString *loadMonthKey = [self getLastMonth:willShowMonth currentYear:willShowYear];
        //向上翻
        if (![self.dataArray containsObject:loadMonthKey]) {
            NSRange range = [loadMonthKey rangeOfString:@"-"];
            NSInteger loadMonth = [[loadMonthKey substringFromIndex:range.location+1] integerValue];
            NSInteger loadYear = [[loadMonthKey substringWithRange:NSMakeRange(0, 4)] integerValue];

            NSArray *loadData = [self getAllDaysOfMonth:loadMonth InYear:loadYear];
            if (loadData) {
                [self.cacheList setObject:loadData forKey:loadMonthKey];
                [self.dataArray insertObject:loadMonthKey atIndex:currentIndex];
                [self.collectionView reloadData];
                [self.collectionView setContentOffset:CGPointMake(0, kCollectionViewHeight)];
            }
        }
    } else if (willShowMonth > self.currentShowMonth || (willShowMonth == 1 && self.currentShowMonth == 12)) {
       // 向下翻
        NSString *loadMonthKey = [self getNextMonth:willShowMonth currentYear:willShowYear];
        if (![self.dataArray containsObject:loadMonthKey]) {
            NSRange range = [loadMonthKey rangeOfString:@"-"];
            NSInteger loadMonth = [[loadMonthKey substringFromIndex:range.location+1] integerValue];
            NSInteger loadYear = [[loadMonthKey substringWithRange:NSMakeRange(0, 4)] integerValue];

            NSArray *loadData = [self getAllDaysOfMonth:loadMonth InYear:loadYear];
            if (loadData) {
                [self.cacheList setObject:loadData forKey:loadMonthKey];
                [self.dataArray insertObject:loadMonthKey atIndex:currentIndex+1];
                [self.collectionView reloadData];
            }
        }
    }

    self.currentShowMonth = willShowMonth;


    // 滑动之后 清空事件列表
    self.currentSelectDay = @"";
    [self reloadEventList];
    self.currentShowDateLabel.text = [NSString stringWithFormat:@"%li年 %li月", willShowYear, willShowMonth];
}

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

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:MOTIONEVENTNOTIFICATION object:nil];
}

#pragma mark - Getter & Setter

- (JNTopContainerView *)topContainerView {
    if (!_topContainerView) {
        _topContainerView = [JNTopContainerView new];
        _topContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _topContainerView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0.1;
        layout.minimumLineSpacing = 0.1;
        layout.itemSize = [self caculatorItemSize];
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGB(245, 245, 245);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 110;
        _tableView.rowHeight = UITableViewAutomaticDimension;

        [_tableView addSubview:self.placeHolderLabel];
        [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_tableView.mas_centerY);
            make.centerX.equalTo(_tableView.mas_centerX);
            make.left.equalTo(_tableView.mas_left).offset(25);
            make.right.equalTo(_tableView.mas_right).offset(-25);
        }];

        [_tableView addSubview:self.currentShowDateLabel];
        [self.currentShowDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_tableView.mas_centerX);
            make.bottom.equalTo(self.placeHolderLabel.mas_top).offset(-50);
        }];

    }
    return _tableView;
}

- (UIView *)weekView {
    if (!_weekView) {
        _weekView = [UIView new];
        _weekView.backgroundColor = [UIColor whiteColor];

//        NSArray *weekdays = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
        NSArray *weekdays = @[@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat"];
        CGFloat width = (SCREEN_WIDTH-20) / 7;
        CGFloat height = kWeekViewHeight;
        for (int i = 0; i < 7; ++i) {
            UILabel *lbl = [UILabel new];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.font = [UIFont systemFontOfSize:14.0];
            lbl.textColor = (i == 0 || i == 6) ? RGB(255, 106, 106) : RGB(156, 156, 156);
            CGFloat x = i * width;
            lbl.frame = CGRectMake(x, 0, width, height);
            lbl.text = weekdays[i];
            [_weekView addSubview:lbl];
        }
    }
    return _weekView;
}

- (UILabel *)placeHolderLabel {
    if (!_placeHolderLabel) {
        _placeHolderLabel = [UILabel new];
        _placeHolderLabel.text = @"记录每天的小事件\n   记录每天的精彩";
        _placeHolderLabel.textAlignment = NSTextAlignmentCenter;
        _placeHolderLabel.numberOfLines = 0;
    }
    return _placeHolderLabel;
}

- (UILabel *)currentShowDateLabel {
    if (!_currentShowDateLabel) {
        _currentShowDateLabel = [UILabel new];
        _currentShowDateLabel.textAlignment = NSTextAlignmentCenter;
        _currentShowDateLabel.numberOfLines = 0;
    }
    return _currentShowDateLabel;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableDictionary<NSString *, NSArray *> *)allEvents {
    if (!_allEvents) {
        _allEvents = [NSMutableDictionary dictionaryWithContentsOfFile:self.eventsListPath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.eventsListPath]) {
            _allEvents = [NSMutableDictionary dictionaryWithContentsOfFile:self.eventsListPath];
        } else {
            _allEvents = [NSMutableDictionary dictionary];
            [_allEvents writeToFile:self.eventsListPath atomically:YES];
        }
    }
    return _allEvents;
}

- (NSString *)eventsListPath {
    if (!_eventsListPath) {
        _eventsListPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Document/events.plist"];
    }
    return _eventsListPath;
}

- (UIImageView *)addEventImageView {
    if (!_addEventImageView) {
        _addEventImageView = [UIImageView new];
        _addEventImageView.image = [UIImage imageNamed:@"publish_btn"];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addEvent)];
        [_addEventImageView addGestureRecognizer:tapGes];
        _addEventImageView.userInteractionEnabled = YES;
    }
    return _addEventImageView;
}
@end
