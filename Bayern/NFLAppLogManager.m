//
//  NFLAppLogManager.m
//  HupuNFL
//
//  Created by Wusicong on 14/12/19.
//  Copyright (c) 2014年 hupu.com. All rights reserved.
//

#import "NFLAppLogManager.h"
#import "MobClick.h"

@implementation NFLAppLogManager

+ (void)sendLogWithEventID:(NSString *)eventId withKeyName:(NSString *)key andValueName:(NSString *)value {
    [MobClick event:eventId attributes:@{key : value}];
    
//    [[HPMonitorPointManager sharedInstance] addEventLogsWithType:eventId logs:key,value,nil];
}

@end
