//
//  UIView+ToastInfo.h
//  UIComponents
//
//  Created by 丛 贵明 on 13-10-15.
//  Copyright (c) 2013年 anjuke inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIView (ToastInfo)

- (void)hideLoadWithAnimated:(BOOL)animated;
- (void)showLoadWithAnimated:(BOOL)animated;
- (void)showLoadingActivity:(BOOL)activity;
- (void)showInfo:(NSString *)info;
- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide;
- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide;
- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide interval:(NSUInteger)seconds;
- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide yOffset:(int)yOffset;
- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide font:(UIFont *)font;
- (void)showInfo:(NSString *)info activity:(BOOL)activity;

@end
