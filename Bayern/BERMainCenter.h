//
//  BERMainCenter.h
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BERMainCenter : NSObject

+ (BERMainCenter *)sharedInstance; //

@property BOOL shouldAppRotateForRootVC; //tabbar或者其他rootViewController需要旋转时，通过该值获取和更改

- (CGFloat)sliderWidth; //设置主结构滑动距离
- (CGFloat)getSliderContainerWidth; //得到滑动后左右内嵌页面宽度
- (CGFloat)sliderPercentage;

@end
