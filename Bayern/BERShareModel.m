//
//  BERShareModel.m
//  Bayern
//
//  Created by wusicong on 15/6/24.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERShareModel.h"

@implementation BERShareModel

static BERShareModel *sharedInstance = nil;

+ (BERShareModel *)sharedInstance {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[BERShareModel alloc] init];
    });
    return sharedInstance;
}

- (NSString *)getShareURL:(BOOL)isNews {
    if (isNews) {
        self.shareUrl = [NSString stringWithFormat:@"http://%@/news/%@?app=1",BER_WEBSITE,self.shareID];
    } else {
        self.shareUrl = [NSString stringWithFormat:@"http://%@/photo/album/%@.html", BER_WEBSITE,self.shareID];
    }
    
    return self.shareUrl;
}

- (UIImage *)getWechatShareIcon {
    return [UIImage imageNamed:@"weixin_icon.png"];
}

@end
