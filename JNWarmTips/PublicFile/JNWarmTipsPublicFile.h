//
// Created by fengtianyu on 20/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNWarmTipsPublicFile : NSObject
@end

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define RGB(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]
#define RANDOMRGB [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]

/*日历中的默认边距  15*/
UIKIT_EXTERN const CGFloat CalendarDefaultMargin;

UIKIT_EXTERN NSString * const MOTIONEVENTNOTIFICATION;