//
//  NFLShareView.h
//  HupuNFL
//
//  Created by Wusicong on 14/12/9.
//  Copyright (c) 2014年 hupu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ShareViewHeight 340/2

typedef NS_ENUM (NSUInteger, ShareType) {
    ShareTypeWeixin = 0,
    ShareTypeWeixinFriend = 1,
    ShareTypeWeibo = 2,
    ShareTypeQzone = 3,
    ShareTypeQQ = 4
};

@protocol NFLShareDelegate <NSObject>

@optional
- (void)shareButtonDidClickWithType:(ShareType)ShareType;
- (void)shareCancleButtonDidClick;
- (void)shareBackgroundDidClick;
@end

@interface NFLShareView : UIView

@property ShareType shareType;
@property id <NFLShareDelegate> delegate;

- (void)resizeUI;

@end
