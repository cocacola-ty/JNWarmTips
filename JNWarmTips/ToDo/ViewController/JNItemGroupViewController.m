//
// Created by fengtianyu on 18/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNItemGroupViewController.h"
#import "JNItemGroupCell.h"
#import "JNWarmTipsPublicFile.h"

static NSString *const kGroupCollectionCellID= @"ItemGroupCellIdentity";

@interface JNItemGroupViewController() <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation JNItemGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.collectionView registerClass:[JNItemGroupCell class] forCellWithReuseIdentifier:kGroupCollectionCellID];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}

#pragma mark - Delegate & DataSource

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JNItemGroupCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGroupCollectionCellID forIndexPath:indexPath];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - Geeter & Setter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = ceilf(SCREEN_WIDTH / 2) - 2;
        layout.itemSize = CGSizeMake(width, 250);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
@end