//
//  BERApiProxy.h
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 线上
 */
#define BER_API_HOST @"http://api.fcbayern.cn"
#define BER_IMAGE_HOST @"http://7xj11p.com1.z0.glb.clouddn.com/" //@"http://img.fcbayern.cn/"
#define BER_WEBSITE @"www.fcbayern.cn"

/*
 线下
 */
//#define BER_API_HOST @"http://api.fcbayern.cn"
//#define BER_IMAGE_HOST @"http://7xj11p.com1.z0.glb.clouddn.com/"
//#define BER_WEBSITE @"www.fcbayern.cn:8080"

#define BER_APP_KEY @"54NexY5d69M24bg"

#define BER_PLATEFORM @"ios"


@interface BERApiProxy : NSObject

+ (NSString *)urlWithAction:(NSString *)action;
+ (NSDictionary *)paramsWithDataDic:(NSDictionary *)dataDic action:(NSString *)action;

@end
