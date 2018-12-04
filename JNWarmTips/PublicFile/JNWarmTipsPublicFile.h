//
// Created by fengtianyu on 20/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNWarmTipsPublicFile : NSObject
/*下载字体*/
+ (void) downFont:(NSString *)fontName ;

/*格式化日期字符串*/
+ (NSString *)dateStringFormat:(int)year month:(int)month day:(int)day ;

/*隐藏tabbar*/
+ (void) hiddenTabbar:(UITabBarController *)vc ;
+ (void) showTabbar:(UITabBarController *)vc ;

/**
 获取当前时间戳 13位
 */
+ (long long)getCurrentTimeStamp;

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

/*上次更新时间*/
UIKIT_EXTERN NSString * const LAST_UPDATE_KEY ;

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif


#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif
