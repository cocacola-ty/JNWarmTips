//
//  JNEventTimeLineTableViewCell.m
//  JNWarmTips
//
//  Created by fengtianyu on 12/10/2018.
//  Copyright © 2018 fengtianyu. All rights reserved.
//

#import "JNEventTimeLineTableViewCell.h"
#import "UIColor+Extension.h"

@interface JNEventTimeLineTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *circleView;

@end

@implementation JNEventTimeLineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.circleView.layer.cornerRadius = 12;
    self.circleView.layer.borderColor = [UIColor colorWithHexString:@"f08080"].CGColor;
    self.circleView.layer.borderWidth = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
