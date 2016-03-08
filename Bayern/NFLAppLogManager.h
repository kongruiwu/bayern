//
//  NFLAppLogManager.h
//  HupuNFL
//
//  Created by Wusicong on 14/12/19.
//  Copyright (c) 2014年 hupu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EventID_Topbar @"Topbar"
#define EventID_Index @"Index"
#define EventID_News @"News"
#define EventID_Photos @"Photos"
#define EventID_Videos @"Videos"



#define KN_MainNav @"MainNav"
#define KN_GameCenter @"GameCenter"
#define KN_List @"List"
#define KN_NewsList @"NewsList"
#define KN_PhotosList @"PhotosList"
#define KN_VideosList @"VideosList"

@interface NFLAppLogManager : NSObject

+ (void)sendLogWithEventID:(NSString *)eventId withKeyName:(NSString *)key andValueName:(NSString *)value;

@end
