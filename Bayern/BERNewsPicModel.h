//
//  BERNewsPicModel.h
//  Bayern
//
//  Created by wusicong on 15/6/17.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BERNewsPicModel : NSObject

+ (BERNewsPicModel *)sharedInstance; //

@property (nonatomic, strong) NSMutableArray *newsIDArray;
@property (nonatomic, strong) NSMutableArray *titleArray;

- (void)addNewsData:(NSDictionary*)dic; //添加图集id缓存
- (void)cleanNewsDataArr; //清空当前的图集id缓存

- (NSString *)getNextNewdIDWithCurrentNewdID:(NSString *)currentNewdID; //获取当前图集的下一个图集id
- (NSString *)getCurrentNewsTitleWithNewsID:(NSString *)newsID; //获取当前图集对应的标题

@end
