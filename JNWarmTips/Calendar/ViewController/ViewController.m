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
 */

#import "ViewController.h"
#import "ViewController+CalculateCalendar.h"
#import "JNDayModel.h"
#import "JNWarmTipsHeader.h"
#import "JNDayCollectionViewCell.h"
#import "Masonry.h"

static CGFloat kWeekViewHeight = 25;
static CGFloat kNavViewHeight = 64;

static CGFloat kItemCount = 7;
static NSString *CalCollectionViewCellReuseId = @"CalCollectionViewCellReuseId";

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *weekView;
@property(nonatomic, assign) CGFloat collectionViewHeight;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataArrayInit;
@property(nonatomic, assign) NSInteger currentShowMonth;

@property (nonatomic, strong) NSMutableDictionary *allEvents;
@property (nonatomic, strong) NSArray *tableViewDataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化设置
    self.cacheList = [[NSCache alloc] init];
    [self initDataSource];
    self.navigationItem.title = [NSString stringWithFormat:@"%li月", self.currentMonth];
    self.currentShowMonth = self.currentMonth;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];

    self.view.backgroundColor = RGB(245, 245, 245);
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[JNDayCollectionViewCell class] forCellWithReuseIdentifier:CalCollectionViewCellReuseId];

    [self.view addSubview:self.weekView];
    [self.navigationController.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(backToToday)]];

    [self.view addSubview:self.tableView];

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
    CGFloat width = SCREEN_WIDTH / kItemCount;
    return CGSizeMake(width, width);
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat tableViewY =  kNavViewHeight + kWeekViewHeight + self.collectionViewHeight + 10;
        CGFloat tableViewHeight = SCREEN_HEIGHT - tableViewY - 44;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, SCREEN_WIDTH, tableViewHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = RGB(245, 245, 245);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];

        UILabel *label = [UILabel new];
        label.text = @"对象不会像 NSMutableDictionary 中那样被复制。（键不需要实现 NSCo";
        [_tableView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_tableView.mas_centerY);
            make.centerX.equalTo(_tableView.mas_centerX);
        }];
    }
    return _tableView;
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
