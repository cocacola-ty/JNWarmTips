//
//  JNAddListItemViewController.m
//  JNWarmTips
//
//  Created by fengtianyu on 11/8/18.
//  Copyright © 2018年 fengtianyu. All rights reserved.
//

#import "JNAddListItemViewController.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import "JNWarmTipsPublicFile.h"

@interface JNAddListItemViewController ()
@property (nonatomic, strong) UIView *containerView;
@end

@implementation JNAddListItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:0.6];
    
    [self.view addSubview:self.containerView];
    CGFloat topMargin = SCREEN_HEIGHT / 2 - 100;
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.view.mas_top).offset(topMargin);
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Getter & Setter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 8;
    }
    return _containerView;
}

@end
