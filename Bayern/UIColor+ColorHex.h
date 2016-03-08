//
//  UIColor+ColorHex.h
//  HupuNFL
//
//  Created by hupu.com on 14/11/10.
//  Copyright (c) 2014年 hupu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorHex)

+ (UIColor *)colorWithHex:(uint) hex alpha:(CGFloat)alpha;

+ (UIColor *)bayernRedColor;
+ (UIColor *)bayernImgDefaultColor;

@end
