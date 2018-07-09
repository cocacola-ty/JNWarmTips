//
//  ViewController.m
//  JNWarmTips
//
//  Created by fengtianyu on 9/4/18.
//  Copyright © 2018年 fengtianyu. All rights reserved.
//

/*
 * 获取所有的事件
 * 显示日历时检查该日期是否在事件列表中
 */

#import "ViewController.h"
#import "ViewController+CalculateCalendar.h"
#import "ViewController+EventList.h"
#import "JNTopContainerView.h"
#import "JNDayModel.h"
#import "JNWarmTipsPublicFile.h"
#import "JNDayCollectionViewCell.h"
#import "JNDayEventTableViewCell.h"
#import "JNDBManager.h"
#import "JNDBManager+Events.h"
#import "JNCalendarAssistant.h"
#import "JNEventTimeLineViewController.h"
#import "Masonry.h"

static NSString *const DayEventTableViewCellReuseId = @"DayEventTableViewCellReuseId";
static const int kCalendarViewMargin = 10;
static const int kAllSections = 100;
static const int kCurrentMonthSection = 50;
static CGFloat kTopContainerViewHeight = 64;
static CGFloat kWeekViewHeight = 30;

static NSInteger kItemCount = 7;
static NSInteger kItemLines = 6;
static NSString *CalCollectionViewCellReuseId = @"CalCollectionViewCellReuseId";

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    BOOL onceToken;
}

@property (nonatomic, strong) JNTopContainerView *topContainerView;
@property (nonatomic, strong) UIView *weekView;

@property (nonatomic, strong) NSMutableArray *dataArrayInit;
@property(nonatomic, assign) NSInteger currentShowMonth;

@property (nonatomic, strong) UIImageView *addEventImageView;
@end

@implementation ViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        onceToken = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //test
    [[JNCalendarAssistant shareInstance] getMonthFirstDayInWeek:6 InYear:2018];
    // test end

    // 初始化设置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFont) name:FONT_DOWNLOAD_NOTIFICATION object:nil];

    self.cacheList = [[NSCache alloc] init];
    [self initDataSource];

    self.currentShowMonth = self.currentMonth;
    self.currentSelectDay = [JNWarmTipsPublicFile dateStringFormat:self.currentYear month:self.currentMonth day:self.currentDay];

    // 获取所有事件
    self.allEventsDate = [[JNDBManager shareInstance] getAllDateAndEventColor];

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
        make.left.equalTo(self.view.mas_left).offset(kCalendarViewMargin);
        make.right.equalTo(self.view.mas_right).offset(-kCalendarViewMargin);
        make.height.mas_equalTo(kWeekViewHeight);
    }];

    // 添加日历
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[JNDayCollectionViewCell class] forCellWithReuseIdentifier:CalCollectionViewCellReuseId];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weekView.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(kCalendarViewMargin);
        make.right.equalTo(self.view.mas_right).offset(-kCalendarViewMargin);
        make.height.mas_equalTo(kCollectionViewHeight);
    }];

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
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[JNDayEventTableViewCell class] forCellReuseIdentifier:DayEventTableViewCellReuseId];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blankView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.currentDateShowLabel.text = [NSString stringWithFormat:@"%ld年 %02ld月 %02ld日", self.currentYear, self.currentMonth, self.currentDay];
    [self reloadEventList];


    [self.view addSubview:self.addEventImageView];
    [self.addEventImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.right.equalTo(_tableView.mas_right).offset(-20);
        make.bottom.equalTo(_tableView.mas_bottom).offset(-60);
    }];

    [self addObserver:self forKeyPath:@"currentSelectDay" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!onceToken) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:kAllSections/2] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        onceToken = YES;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Private Method

- (void) refreshFont {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.placeHolderLabel.font = [UIFont fontWithName:FONT_NAME_WAWA size:15.0];
        self.currentDateShowLabel.font = [UIFont fontWithName:FONT_NAME_WAWA size:12.0];
    });
}

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
    NSString *currentMonthKey = [JNWarmTipsPublicFile dateStringFormat:self.currentYear month:self.currentMonth day:0];
    [self.cacheList setObject:currentMonthArray forKey:currentMonthKey];
    [self.dataArray addObject:currentMonthKey];

    NSArray *nextMonthArray = [self getAllDaysOfMonth:self.currentMonth + 1 InYear:self.currentYear];
    NSString *nextMonthKey = [self getNextMonth:self.currentMonth currentYear:self.currentYear];
    [self.cacheList setObject:nextMonthArray forKey:nextMonthKey];
    [self.dataArray addObject:nextMonthKey];

}

- (CGSize) caculatorItemSize {
    CGFloat width = (SCREEN_WIDTH-21) / kItemCount;
    CGFloat height = kCollectionViewHeight / kItemLines;
    return CGSizeMake(width, height);
}

/*获取当前位置的日期*/
- (NSArray *)getDateWithIndexPath:(NSIndexPath *)indexPath {

    int awayLength = indexPath.section - kCurrentMonthSection;
    NSArray *resultArray = [[JNCalendarAssistant shareInstance] getDateAwayCurrentDate:awayLength];
    int month = [resultArray.lastObject intValue];
    int year = [resultArray.firstObject intValue];

    int firstDayIndex = [[JNCalendarAssistant shareInstance] getMonthFirstDayInWeek:month InYear:year];
    int rowIndex = indexPath.row + 1; // 更改row的起始索引为1

    // 获取该月份的天数
    int totalDaysOfMonth = [[JNCalendarAssistant shareInstance] getCountOfDayInMonth:month InYear:year]; // 这个月的天数

    int day;
    if (rowIndex < firstDayIndex || rowIndex >= firstDayIndex + totalDaysOfMonth) {
        day = 0;
    } else {
        day = rowIndex - firstDayIndex + 1;
    }

    return @[@(year), @(month), @(day)];
}

#pragma mark - Delegate & DataSources

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    
    if ([keyPath isEqualToString:@"currentSelectDay"]) {
        NSString *value = [change valueForKey:@"new"];
        [UIView animateWithDuration:0.25 animations:^{
            self.addEventImageView.hidden = value.length == 0;
        }];
    }
    
}

/* cell 显示之前 */
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSArray *indexpaths = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *firstIndexPath = indexpaths.firstObject;
    NSArray *dateArray = [self getDateWithIndexPath:firstIndexPath];
    int year = [dateArray.firstObject intValue];
    int month = [dateArray[1] intValue];
    NSString *dateStrign = [JNWarmTipsPublicFile dateStringFormat:year month:month day:nil];
    self.currentDateShowLabel.text = dateStrign;


}

/*
 * 如果在这个方法里检查每个日期是否有事件，想办法简化查询条件，因为这个方法滑动时候会频繁调用
 * */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    JNDayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CalCollectionViewCellReuseId forIndexPath:indexPath];

    NSArray *dateArray = [self getDateWithIndexPath:indexPath];

    int year = [dateArray.firstObject integerValue];
    int month = [dateArray[1] integerValue];
    int day = [dateArray.lastObject intValue];

    BOOL isToday = (indexPath.section == kCurrentMonthSection && day == [JNCalendarAssistant shareInstance].currentDay);

    NSString *dateString = [JNWarmTipsPublicFile dateStringFormat:year month:month day:day];
    BOOL showFlat = [self.allEventsDate.allKeys containsObject:dateString];
    NSString *color = [self.allEventsDate valueForKey:dateString];

    NSString *content = day == 0 ? @"" : [NSString stringWithFormat:@"%d", day];

    [cell setupContent:content andIsToday:isToday andShowFlag:showFlat AndColor:color];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kItemLines * kItemCount;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return kAllSections;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *dateArray = [self getDateWithIndexPath:indexPath];
    int day = [dateArray.lastObject intValue];
    return day != 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSArray *dateArray = [self getDateWithIndexPath:indexPath];
    int year = [dateArray.firstObject intValue];
    int month = [dateArray[1] intValue];
    int day = [dateArray.lastObject intValue];

    self.currentSelectDay = [JNWarmTipsPublicFile dateStringFormat:year month:month day:day];
    [self reloadEventList];

    self.currentDateShowLabel.text = [JNWarmTipsPublicFile dateStringFormat:year month:month day:day];
}

#pragma mark - Event Response

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:MOTIONEVENTNOTIFICATION object:nil];
}

- (void)backToToday {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:kAllSections/2] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

#pragma mark - Getter & Setter

- (JNTopContainerView *)topContainerView {
    if (!_topContainerView) {
        _topContainerView = [JNTopContainerView new];
        _topContainerView.backgroundColor = [UIColor whiteColor];

        __weak typeof(self) ws = self;
        JNEventTimeLineViewController *eventTimeLineViewController = [JNEventTimeLineViewController new];
        eventTimeLineViewController.hidesBottomBarWhenPushed = YES;
        _topContainerView.rightBtnActionBlock = ^() {
            [ws.navigationController pushViewController:eventTimeLineViewController animated:YES];
        };

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToToday)];
        [_topContainerView addGestureRecognizer:tapGestureRecognizer];
    }
    return _topContainerView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing = 0.0;
        layout.itemSize = [self caculatorItemSize];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
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

        [_tableView addSubview:self.currentDateShowLabel];
        [self.currentDateShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (UILabel *)currentDateShowLabel {
    if (!_currentDateShowLabel) {
        _currentDateShowLabel = [UILabel new];
        _currentDateShowLabel.textAlignment = NSTextAlignmentCenter;
        _currentDateShowLabel.numberOfLines = 0;
    }
    return _currentDateShowLabel;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSArray<JNEventModel *> *)oneDayEventsArray {
    if (!_oneDayEventsArray) {
        _oneDayEventsArray = [[JNDBManager shareInstance] getAllEventsOfDay:self.currentSelectDay];
    }
    return _oneDayEventsArray;
}

- (NSMutableArray *)eventsArray {
    if (!_eventsArray) {
        _eventsArray = [NSMutableArray arrayWithArray:[[JNDBManager shareInstance] getAllEventsOfDay:self.currentSelectDay]]; // 初始化获取当前日期的所有事件
    }
    return _eventsArray;
}

- (NSString *)eventsListPath {
    if (!_eventsListPath) {
        _eventsListPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Document/events.plist"];
    }
    return _eventsListPath;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignore "-Wundeclared-selector"
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
#pragma clang diagnostic pop
@end
