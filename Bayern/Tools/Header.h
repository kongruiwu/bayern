//
//  Header.h
//  TruckClan
//
//  Created by 吴孔锐 on 16/8/3.
//  Copyright © 2016年 wurui. All rights reserved.
//

#ifndef Header_h
#define Header_h

#import "Masonry/Masonry.h"

#import "ToastView.h"
#import "UserInfo.h"

/*
 * typdef enum
 */

typedef NS_ENUM(NSInteger, SelectorBackType){
    SelectorBackTypePopBack = 0,
    SelectorBackTypeDismiss,
    SelectorBackTypePoptoRoot
};


/*
 * frame defines
 */

#define SCREENBOUNDS [UIScreen mainScreen].bounds
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGH  [UIScreen mainScreen].bounds.size.height

//750状态下像素适配宏
#define Anno750(x) ((x)/ 1334.0f) * SCREENHEIGH
//750状态下字体适配
#define font750(x) ((x)/ 1334.0f) * SCREENHEIGH

/*
 * color defines
 */
#define COLOR_MAIN_RED              UIColorFromRGB(0x961432)
#define COLOR_LINECOLOR             UIColorFromRGB(0xeeeeee)
#define COLOR_CONTENT_GRAY_3        UIColorFromRGB(0x333333)
#define COLOR_CONTENT_GRAY_6        UIColorFromRGB(0x666666)
#define COLOR_CONTENT_GRAY_9        UIColorFromRGB(0x999999)
#define COLOR_BACKGROUND            UIColorFromRGB(0xe9e9e9)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue,sec) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:sec]
#define COLOR_BACK_ALPHA_9 UIColorFromRGBA(0x000000,0.9)
#define COLOR_BACK_ALPHA_8 UIColorFromRGBA(0x000000,0.8)
#define COLOR_BACK_ALPHA_3 UIColorFromRGBA(0x000000,0.3)
#define COLOR_BACK_ALPHA_5 UIColorFromRGBA(0x000000,0.5)

#define ShowComplete @"showComplete"

#endif /* Header_h */
