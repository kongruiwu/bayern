//
//  UIColor+ColorHex.m
//  HupuNFL
//
//  Created by hupu.com on 14/11/10.
//  Copyright (c) 2014年 hupu.com. All rights reserved.
//

#import "UIColor+ColorHex.h"

@implementation UIColor (ColorHex)

+ (UIColor *)colorWithHex:(uint) hex alpha:(CGFloat)alpha
{
    int red, green, blue;
    
    blue = hex & 0x0000FF;
    green = ((hex & 0x00FF00) >> 8);
    red = ((hex & 0xFF0000) >> 16);
    
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

+ (UIColor *)bayernRedColor {
    return [UIColor colorWithHex:0xe4003a alpha:1];
}

+ (UIColor *)bayernImgDefaultColor {
    return [UIColor colorWithRed:0.91 green:0.91 blue:0.92 alpha:1];
}

@end
