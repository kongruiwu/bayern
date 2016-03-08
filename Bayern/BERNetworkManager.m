//
//  NFLNetworkManager.m
//  HupuNFL
//
//  Created by Wusicong on 14/12/15.
//  Copyright (c) 2014年 hupu.com. All rights reserved.
//

#import "BERNetworkManager.h"

@implementation BERNetworkManager

+ (BOOL)isNetworkOkay {
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        return NO;
    }
    
    return YES;
}

@end
