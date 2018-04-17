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
 * dataArray : 数据源
 * dataArrayInit : 最初始化的数据源 点击回到今天后重置的
 * cacheDate : 加载过后缓存下来的日期 @"2018-04" : @[...]
 */

#import "ViewController.h"
#import "JNDayModel.h"
#import "JNWarmTipsHeader.h"
#import "JNDayCollectionViewCell.h"

static CGFloat kWeekViewHeight = 25;
static CGFloat kNavViewHeight = 64;

static CGFloat kItemCount = 7;
static NSString *CalCollectionViewCellReuseId = @"CalCollectionViewCellReuseId";

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *weekView;
@property(nonatomic, assign) CGFloat collectionViewHeight;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataArrayInit;
@property (nonatomic, strong) NSCache *cacheDate;
@property(nonatomic, assign) NSInteger currentYear;
@property(nonatomic, assign) NSInteger currentMonth;
@property(nonatomic, assign) NSInteger currentDay;
@property(nonatomic, assign) NSInteger currentShowMonth;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化设置
    [self initDataSource];
    self.navigationItem.title = [NSString stringWithFormat:@"%lu", self.currentMonth];
    self.currentShowMonth = self.currentMonth;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];

    self.view.backgroundColor = RGB(245, 245, 245);
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[JNDayCollectionViewCell class] forCellWithReuseIdentifier:CalCollectionViewCellReuseId];

    [self.view addSubview:self.weekView];
    [self.navigationController.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(backToToday)]];


}

#pragma mark - Private Method

- (void) getLastMonth {

}

- (void) getNextMonth {

}
- (void) initDataSource {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitDay fromDate:currentDate];
    self.currentMonth = components.month;
    self.currentYear = components.year;
    self.currentDay = components.day;

    NSArray *lastMonthArray = [self getAllDaysOfMonth:self.currentMonth - 1 InYear:self.currentYear];
    NSString *lastMonthkey = [NSString stringWithFormat:@"%ld-%ld", self.currentYear, self.currentMonth];
    NSDictionary *lastMonthDict = @{lastMonthkey : lastMonthArray};
    [self.dataArray addObject:lastMonthDict];

    NSArray *currentMonthArray = [self getAllDaysOfMonth:self.currentMonth InYear:self.currentYear];
    [self.dataArray addObject:currentMonthArray];

    NSArray *nextMonthArray = [self getAllDaysOfMonth:self.currentMonth + 1 InYear:self.currentYear];
    [self.dataArray addObject:nextMonthArray ];

}

- (NSMutableArray *) getAllDaysOfMonth:(NSInteger)month InYear:(NSInteger)year{

    NSCalendar *calendar = [NSCalendar currentCalendar];

    // 获取本月1号是周几
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *firstDayStr = [NSString stringWithFormat:@"%ld-%ld-01",year,month];
    NSLog(@"%@",firstDayStr);
    NSDate *firstDay = [dateFormatter dateFromString:firstDayStr];
    NSDateComponents *weekComponents = [calendar components:NSCalendarUnitWeekday fromDate:firstDay];
    NSInteger firstDayInWeek = weekComponents.weekday;
    NSLog(@"weekComponents = %ld", weekComponents.weekday);

    // 获取当前月有多少天
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:firstDay];
    NSLog(@"range = %ld", range.length);

    // 获取上一个月有多少天
    NSInteger lastMonthInt = month - 1;
    NSInteger lastMonthInYear = year;
    if (month == 1) {
        lastMonthInYear = year - 1;
        lastMonthInt = 12;
    }
    NSString *lastMonthStr = [NSString stringWithFormat:@"%ld-%ld-01", lastMonthInYear, lastMonthInt];
    NSDate *lastMonth = [dateFormatter dateFromString:lastMonthStr];
    NSRange lastMonthRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:lastMonth];
    NSInteger daysOflastMonth = lastMonthRange.length;
    NSLog(@"lastMonthRange = %ld", lastMonthRange.length);

    // 排列本月所有日期
    NSMutableArray *days = [NSMutableArray array];
    // 需要显示的上个月的天数
    for (int index = 1; index < firstDayInWeek; index++) {
        JNDayModel *dayModel = [JNDayModel new];
        dayModel.day = [NSString stringWithFormat:@"%ld", (daysOflastMonth - firstDayInWeek + index + 1)];
        dayModel.month = [NSString stringWithFormat:@"%ld",lastMonthInt];
        dayModel.year = [NSString stringWithFormat:@"%ld", lastMonthInYear];
        dayModel.needShowFlag = NO;
        dayModel.isCurrentMonth = NO;
        dayModel.isCurrentMonth = NO;
        dayModel.isToday = NO;
        [days addObject:dayModel];
    }
    // 本月的天数
    for (int i = 1; i <= range.length; i++) {
        JNDayModel *dayModel = [JNDayModel new];
        dayModel.day = [NSString stringWithFormat:@"%i", i];
        dayModel.month = [NSString stringWithFormat:@"%ld", month];
        dayModel.year = [NSString stringWithFormat:@"%ld", year];
        dayModel.needShowFlag = NO;
        dayModel.isCurrentMonth = YES;
        dayModel.isToday = (i == self.currentDay && month == self.currentMonth && year == self.currentYear);
        [days addObject:dayModel];
    }
    // 下个月的天数
    NSInteger nextMonthInt = month + 1;
    NSInteger nextMonthInYear = year;
    if (month == 12) {
        nextMonthInt = 1;
        nextMonthInYear = year + 1;
    }
    if (days.count < 35) {
        NSInteger nextDays = 35 - days.count;
        for (int i = 1; i <= nextDays; i++) {
            JNDayModel *dayModel = [JNDayModel new];
            dayModel.day = [NSString stringWithFormat:@"%i", i];
            dayModel.month = [NSString stringWithFormat:@"%ld", nextMonthInt];
            dayModel.year = [NSString stringWithFormat:@"%ld", nextMonthInYear];
            dayModel.needShowFlag = NO;
            dayModel.isCurrentMonth = NO;
            [days addObject:dayModel];
        }

    }
    return days;
}

- (CGSize) caculatorItemSize {
    CGFloat width = SCREEN_WIDTH / kItemCount;
    return CGSizeMake(width, width);
}

#pragma mark - Delegate & DataSources

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JNDayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CalCollectionViewCellReuseId forIndexPath:indexPath];

    NSArray *monthArray = self.dataArray[indexPath.section];
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
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSArray *indexPathArray = [self.collectionView indexPathsForVisibleItems];

    // 找到最多的section
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableArray *array = [NSMutableArray array];
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

    NSArray *sortKeys = [dictionary keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return (NSComparisonResult) (result == NSOrderedAscending);
    }];
    NSInteger section = [sortKeys.firstObject integerValue];
    NSArray *daysArray = self.dataArray[section];
    JNDayModel *model = daysArray[10];
    NSInteger willShowMonth = [model.month integerValue];
    self.navigationItem.title = [NSString stringWithFormat:@"%@", model.month];

    if (willShowMonth < self.currentShowMonth || (willShowMonth == 12 && self.currentShowMonth == 1)) {
        //向上翻
        /*
        NSInteger loadMonth;
        NSInteger loadYear;
        if(willShowMonth == 1) {
            loadMonth = 12;
            loadYear = [model.year integerValue] - 1;
        } else {
            loadMonth = willShowMonth - 1;
            loadYear = [model.year integerValue];
        }

        NSArray *data = [self getAllDaysOfMonth:loadMonth InYear:loadYear];
        NSLog(@"data = %@", data);
        [self.dataArray insertObject:data atIndex:0];
        [self.collectionView reloadData];
        */

    } else if (willShowMonth > self.currentShowMonth || (willShowMonth == 1 && self.currentShowMonth == 12)) {
       // 向下翻
        NSInteger loadMonth;
        NSInteger loadYear;
        if(willShowMonth == 12) {
            loadMonth = 1;
            loadYear = [model.year integerValue] + 1;
        } else {
            loadMonth = willShowMonth + 1;
            loadYear = [model.year integerValue];
        }

        NSArray *data = [self getAllDaysOfMonth:loadMonth InYear:loadYear];
        [self.dataArray addObject:data];
        NSLog(@"self.dataArray.count = %lu", self.dataArray.count);
        [self.collectionView reloadData];
    }

    self.currentShowMonth = willShowMonth;

}

#pragma mark - Getter & Setter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = [self caculatorItemSize];
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kWeekViewHeight+kNavViewHeight+1, SCREEN_WIDTH, self.collectionViewHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (UIView *)weekView {
    if (!_weekView) {
        _weekView = [UIView new];
        _weekView.frame = CGRectMake(0, kNavViewHeight, SCREEN_WIDTH, kWeekViewHeight);
        _weekView.backgroundColor = RGB(245, 245, 245);

        NSArray *weekdays = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
        CGFloat width = SCREEN_WIDTH / 7;
        CGFloat height = kWeekViewHeight;
        for (int i = 0; i < 7; ++i) {
            UILabel *lbl = [UILabel new];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.font = [UIFont systemFontOfSize:14.0];
            lbl.textColor = (i == 0 || i == 6) ? RGB(255, 106, 106) : RGB(79, 79, 79);
            CGFloat x = i * width;
            lbl.frame = CGRectMake(x, 0, width, height);
            lbl.text = weekdays[i];
            [_weekView addSubview:lbl];
        }
    }
    return _weekView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (CGFloat)collectionViewHeight {
    return SCREEN_WIDTH / kItemCount * 5;
}
@end
