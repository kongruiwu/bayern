//
//  NFLNewsViewController.h
//  HupuNFL
//
//  Created by Wusicong on 15/1/14.
//  Copyright (c) 2015年 hupu.com. All rights reserved.
//

#import "BERRootViewController.h"

@interface BERNewsDetailViewController : BERRootViewController

@property (nonatomic, copy) NSString *news_id;
@property (nonatomic, copy) NSString *news_url;

@property BOOL isPictureType; //是否是图片类型新闻

@property BOOL needFetchNewsData;

@end
