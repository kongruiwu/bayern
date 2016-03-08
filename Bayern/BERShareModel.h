//
//  BERShareModel.h
//  Bayern
//
//  Created by wusicong on 15/6/24.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BERShareModel : NSObject

+ (BERShareModel *)sharedInstance; //

@property (nonatomic, strong) UIImage *shareImg;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareID;

- (NSString *)getShareURL:(BOOL)isNews;
- (UIImage *)getWechatShareIcon;

@end
