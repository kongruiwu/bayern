//
//  APToastView.h
//  CommonUI
//
//  Created by  tudou on 13-4-12.
//  Copyright (c) 2013年  tudou. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  DefautMaxTimeOut   15.0

typedef enum{
    APToastIconNone = 0,    // 无图标
    APToastIconSuccess,     // 成功图标
    APToastIconFailure,     // 失败图标
	APToastIconLoading,     // 加载图标
    APToastIconNetFailure,  // 网络失败
} APToastIcon;

/**
 * Toast
 */
@interface LMToastView : UIView

@property (nonatomic, assign) CGFloat xOffset; // 设置相对父视图中心位置X坐标方向的偏移量
@property (nonatomic, assign) CGFloat yOffset; // 设置相对父视图中心位置Y坐标方向的偏移量

/**
 * 显示Toast
 *
 * @param superview 父视图
 * @param icon      图标类型
 * @param text      显示文本
 * @param duration  显示时长
 *
 * @return 返回显示的Toast对象
 */
+ (LMToastView *)presentToastWithin:(UIView *)superview
                           withIcon:(APToastIcon)icon
                               text:(NSString *)text
                           duration:(NSTimeInterval)duration;

/**
 * 显示Toast，需调用dismissToast方法使Toast消失
 *
 * @param superview 父视图
 * @param text      显示文本
 *
 * @return 返回显示的Toast对象
 */
+ (LMToastView *)presentToastWithin:(UIView *)superview text:(NSString *)text;

/*
 * 模态显示提示，此时屏幕不响应用户操作，需调用dismissToast方法使Toast消失
 *
 * @param text 显示文本
 *
 * @return 返回显示的Toast对象
 */
+ (LMToastView *)presentToastWithText:(NSString *)text;

/*
 * 模态toast，需调用dismissToast方法使Toast消失
 *
 * @param superview 父视图
 * @param text      显示文本
 *
 * @return 返回显示的Toast对象
 */
+ (LMToastView *)presentModelToastWithin:(UIView *)superview text:(NSString *)text;

/*
 * 使toast消失
 */
- (void)dismissToast;

/**
 * 显示Toast
 *
 * @param superview     要在其中显示Toast的视图
 * @param icon          图标类型
 * @param text          显示文本
 * @param duration      显示时长
 * @param completion    Toast自动消失后的回调
 *
 * @return 返回显示的Toast对象
 */
+ (LMToastView *)presentToastWithin:(UIView *)superview
                           withIcon:(APToastIcon)icon
                               text:(NSString *)text
                           duration:(NSTimeInterval)duration
                         completion:(void (^)())completion;

/**
 * 显示Toast
 *
 * @param superview     要在其中显示Toast的视图
 * @param icon          图标类型
 * @param text          显示文本
 * @param duration      显示时长
 * @param delay         延迟显示时长
 * @param completion    Toast自动消失后的回调
 *
 * @return 返回显示的Toast对象
 */
+ (LMToastView *)presentToastWithin:(UIView *)superview
                           withIcon:(APToastIcon)icon
                               text:(NSString *)text
                           duration:(NSTimeInterval)duration
                              delay:(NSTimeInterval)delay
                         completion:(void (^)())completion;

/**
 * 显示模态Toast
 *
 * @param superview     要在其中显示Toast的视图
 * @param icon          图标类型
 * @param text          显示文本
 * @param duration      显示时长
 * @param completion    Toast自动消失后的回调
 *
 * @return 返回显示的Toast对象
 */
+ (LMToastView *)presentModalToastWithin:(UIView *)superview
                                withIcon:(APToastIcon)icon
                                    text:(NSString *)text
                                duration:(NSTimeInterval)duration
                              completion:(void (^)())completion;


/**
 * 显示模态Toast
 *
 * @param superview     要在其中显示Toast的视图
 * @param icon          图标类型
 * @param text          显示文本
 * @param duration      显示时长
 * @param delay         延迟显示时长
 * @param completion    Toast自动消失后的回调
 *
 * @return 返回显示的Toast对象
 */
+ (LMToastView *)presentModalToastWithin:(UIView *)superview
                                withIcon:(APToastIcon)icon
                                    text:(NSString *)text
                                duration:(NSTimeInterval)duration
                                   delay:(NSTimeInterval)delay
                              completion:(void (^)())completion;

@end
