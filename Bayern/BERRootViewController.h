//
//  BERRootViewController.h
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFLShareView.h"

typedef NS_ENUM (NSUInteger, RTSelectorBackType) {
    RTSelectorBackTypePopBack = 0,
    RTSelectorBackTypeDismiss,
    RTSelectorBackTypePopToRoot
};                      

@interface BERRootViewController : UIViewController <NFLShareDelegate>

@property (nonatomic, assign) RTSelectorBackType backType; //返回类型封装
@property CGFloat sliderWidth; //滑动内嵌页面宽

@property (nonatomic, strong) NFLShareView *shareView;

- (void)drawMainTabItem;
- (void)drawTitle:(NSString *)title;
- (void)drawBackButton;
- (void)drawShareButton;

- (void)doBack;
- (void)doShare;

@end
