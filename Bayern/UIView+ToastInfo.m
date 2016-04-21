//
//  UIView+ToastInfo.m
//  UIComponents
//
//  Created by 丛 贵明 on 13-10-15.
//  Copyright (c) 2013年 anjuke inc. All rights reserved.
//

#import "UIView+ToastInfo.h"

@implementation UIView (ToastInfo)

- (void)hideLoadWithAnimated:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:self animated:animated];
}

- (void)showLoadWithAnimated:(BOOL)animated
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:animated];
    hud.labelText = @"加载中...";
}

- (void)showLoadingActivity:(BOOL)activity{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText = @"加载中...";
//    [hud hide:YES afterDelay:3];
}

- (void)showInfo:(NSString *)info{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText = info;
    
    [hud hide:YES afterDelay:2];
}

- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide {
    [self showInfo:info image:icon autoHidden:autoHide interval:1.5];
}

- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide interval:(NSUInteger)seconds{
    [self showInfo:info image:icon autoHidden:autoHide interval:seconds yOffset:0];
}

- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide{
    [self showInfo:info image:nil autoHidden:autoHide];
}

- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide yOffset:(int)yOffset{
    [self showInfo:info image:nil autoHidden:autoHide interval:1.5 yOffset:yOffset];
}

- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide interval:(NSUInteger)seconds {
    [self showInfo:info image:Nil autoHidden:autoHide interval:seconds];
}

- (void)showInfo:(NSString *)info activity:(BOOL)activity{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText = [NSString stringWithFormat:@"%@",info];
}

- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide font:(UIFont *)font
{
    [self showInfo:info image:icon autoHidden:autoHide interval:1.5 yOffset:0 font:font];
}

- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide interval:(NSUInteger)seconds yOffset:(int)yOffset{
    [self showInfo:info image:icon autoHidden:autoHide interval:seconds yOffset:yOffset font:nil];
}

- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide interval:(NSUInteger)seconds yOffset:(int)yOffset font:(UIFont *)font{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    hud.removeFromSuperViewOnHide = YES;
    
    [self addSubview:hud];
    
    if (icon) {
        hud.customView = [[UIImageView alloc] initWithImage:icon];
    }
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.detailsLabelFont = hud.labelFont;
    hud.detailsLabelText = info;
    if (yOffset != 0) {
        hud.yOffset = yOffset;
    }
    if (font) {
        hud.labelFont = font;
    }
    
    [hud show:YES];
    if (autoHide) {
        [hud hide:YES afterDelay:(seconds > 0 ? seconds : 1.5)];
    }
}

@end
