//
//  JNAddListItemViewController.m
//  JNWarmTips
//
//  Created by fengtianyu on 11/8/18.
//  Copyright © 2018年 fengtianyu. All rights reserved.
//

#import "JNAddListItemViewController.h"

@interface JNAddListItemViewController ()
@property (nonatomic, strong) UIView *containerView;
@end

@implementation JNAddListItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.containerView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter & Setter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
    }
    return _containerView;
}

@end
