//
//  BERNewsPicModel.m
//  Bayern
//
//  Created by wusicong on 15/6/17.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERNewsPicModel.h"

@implementation BERNewsPicModel

static BERNewsPicModel *sharedInstance = nil;

+ (BERNewsPicModel *)sharedInstance {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[BERNewsPicModel alloc] init];
    });
    return sharedInstance;
}

- (void)addNewsData:(NSDictionary*)dic {//添加图集id缓存
    id newsID = dic[@"id"];
    NSString *title = dic[@"title"];
    
    if ([newsID isKindOfClass:[NSString class]]) {
        [self.newsIDArray addObject:newsID];
    } else {
        [self.newsIDArray addObject:[newsID stringValue]];
    }
    
    [self.titleArray addObject:title];
}

- (NSString *)getNextNewdIDWithCurrentNewdID:(NSString *)currentNewdID {
    
    DLog(@"cached news data [%@]", self.newsIDArray);
    
    for (NSInteger i = 0; i < self.newsIDArray.count; i ++) {
        NSString *newsID = self.newsIDArray[i];
        if ([currentNewdID isEqualToString:newsID]) {
            if (i == self.newsIDArray.count - 1) { //已经到了最后一个newsID
                return @"";
            } else {
                return self.newsIDArray[i + 1]; //将该newsID的下一个id抛出
            }
            
            break;
        }
    }
    
    return @"";
}

- (NSString *)getCurrentNewsTitleWithNewsID:(NSString *)newsID{ //获取当前图集对应的标题
    for (NSString *news_ID in self.newsIDArray) {
        if ([news_ID isEqualToString:newsID]) {
            NSInteger index = [self.newsIDArray indexOfObject:newsID];
            
            return self.titleArray[index];
            break;
        }
    }
    
    return @"";
}

- (void)cleanNewsDataArr {
    [self.newsIDArray removeAllObjects];
    [self.titleArray removeAllObjects];
}


#pragma mark - Getter

- (NSMutableArray *)newsIDArray {
    if (!_newsIDArray) {
        _newsIDArray = [NSMutableArray array];
    }
    return _newsIDArray;
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

@end
