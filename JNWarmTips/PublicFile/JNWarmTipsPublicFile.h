//
// Created by fengtianyu on 20/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNWarmTipsPublicFile : NSObject
/*下载字体*/
+ (void) downFont:(NSString *)fontName ;

/*格式化日期字符串*/
+ (NSString *)dateStringFormat:(NSInteger)year month:(NSInteger)month day:(NSInteger)day ;

/*隐藏tabbar*/
+ (void) hiddenTabbar:(UITabBarController *)vc ;
+ (void) showTabbar:(UITabBarController *)vc ;
@end

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define RGB(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]
/*灰色文本*/
#define GRAY_TEXT_COLOR RGB(156, 156, 156)
/*随机色*/
#define RANDOM_COLOR [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]
/*红色主色调*/
#define MAIN_COLOR RGB(255, 54, 79)
/*背景灰色*/
#define GRAY_BACKGROUND_COLOR RGB(245, 245, 245)

/*日历中的默认边距  15*/
UIKIT_EXTERN const CGFloat CalendarDefaultMargin;

UIKIT_EXTERN NSString * const MOTIONEVENTNOTIFICATION;

/*字体下载完成通知*/
UIKIT_EXTERN NSString * const FONT_DOWNLOAD_NOTIFICATION;

/*娃娃体字体名*/
UIKIT_EXTERN NSString * const FONT_NAME_WAWA;

/*手札体字体名*/
UIKIT_EXTERN NSString * const FONT_NAME_SHOUZHA;

/*雅痞字体*/
UIKIT_EXTERN NSString * const FONT_NAME_YAPI ;
