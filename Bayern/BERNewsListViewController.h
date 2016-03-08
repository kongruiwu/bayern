//
//  BERNewsListViewController.h
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERBaseListViewController.h"

typedef NS_ENUM (NSInteger, NewsListType) {
    NewsListTypeNews ,
    NewsListTypePic
};

@interface BERNewsListViewController : BERBaseListViewController

@property (nonatomic, assign) NewsListType newsListType;
@end
