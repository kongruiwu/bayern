//
//  BERMainCenter.m
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERMainCenter.h"

@implementation BERMainCenter

static BERMainCenter *sharedInstance = nil;

+ (BERMainCenter *)sharedInstance {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[BERMainCenter alloc] init];
    });
    return sharedInstance;
}

- (CGFloat)sliderWidth {
    return WindowWidth *0.75;
}

- (CGFloat)getSliderContainerWidth {
    return [self sliderWidth];
}

- (CGFloat)sliderPercentage {
    return 0.75;
}

@end
