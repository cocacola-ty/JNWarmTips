//
//  ViewController.m
//  JNWarmTips
//
//  Created by fengtianyu on 9/4/18.
//  Copyright © 2018年 fengtianyu. All rights reserved.
//

#import "ViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define RGB(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]

static CGFloat kCollectionViewHeight = 400;
static CGFloat kWeekViewHeight = 25;
static CGFloat kNavViewHeight = 64;

static CGFloat kItemCount = 7;
static NSString *CalCollectionViewCellReuseId = @"CalCollectionViewCellReuseId";

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *weekView;
@property(nonatomic, assign) CGFloat collectionViewHeight;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(255, 250, 240);
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CalCollectionViewCellReuseId];

    [self.view addSubview:self.weekView];

}

#pragma mark - Private Method

- (CGSize) caculatorItemSize {
    CGFloat width = SCREEN_WIDTH / kItemCount;
    return CGSizeMake(width, width);
}

#pragma mark - Delegate & DataSources

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CalCollectionViewCellReuseId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UILabel *textLabel = [UILabel new];
    textLabel.font = [UIFont systemFontOfSize:14.0];
    textLabel.textColor = RGB(79, 79, 79);
    textLabel.center = cell.contentView.center;
    textLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat width = [self caculatorItemSize].width;
    textLabel.bounds = CGRectMake(0, 0, width, width);
    textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.item];
    [cell.contentView addSubview:textLabel];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 35;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - Getter & Setter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = [self caculatorItemSize];

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kWeekViewHeight+kNavViewHeight+1, SCREEN_WIDTH, self.collectionViewHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
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

- (CGFloat)collectionViewHeight {
    return SCREEN_WIDTH / kItemCount * 5;
}
@end
