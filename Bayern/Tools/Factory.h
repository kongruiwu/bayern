//
//  Factory.h
//  TruckClan
//
//  Created by 吴孔锐 on 16/8/4.
//  Copyright © 2016年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Header.h"
@interface Factory : NSObject
/**
 *  get textSize
 */
+ (CGSize)getSize:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont*)font;
/**
 * creat Tabbleview and defaultSetting
 */
+ (UITableView *)creatTabbleViewWithFrame:(CGRect)frame style:(UITableViewStyle)style;

/**
 * creat Label
 */
+ (UILabel *)creatLabelWithTitle:(NSString *)title textColor:(UIColor *)textColor textFont:(CGFloat)fontValue textAlignment:(NSTextAlignment)alignment;
/**
 * creat  text UIButton
 */
+ (UIButton *)creatButtonWithTitle:(NSString *)title textFont:(CGFloat)textFontVlaue titleColor:(UIColor *)titleColor backGroundColor:(UIColor *)backGroundColor;
/**
 * creat Image + text Button
 */
+ (UIButton *)creatImageButtonWithTitle:(NSString *)title textFont:(CGFloat)textFontVlaue titleColor:(UIColor *)titleColor backGroundColor:(UIColor *)backGroundColor andImage:(NSString *)imageName;
/**
 * creat  imageButton  selectImage with state
 */
+ (UIButton *)creatButtonWithNormalImage:(NSString *)normalImage selectImage:(NSString *)selectImage;
/**
 * creat imageButton  backgroundImage
 */
+ (UIButton *)creatGroundImageButtonWithImage:(NSString *)imageName;

/**
 *  creat View setColor
 */
+ (UIView *)creatViewWithColor:(UIColor *)color;

/**
 * 十六进制颜色控制
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;
/**
 * 十六进制转换 + 透明度
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 * creatImageView  imageName
 */
+ (UIImageView *)creatImageViewWithImageName:(NSString *)image;
/**
 * creat textField
 */
+ (UITextField *)creatTextFieldWithPlaceHolder:(NSString *)placeHolder textAlignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor;
/**登陆界面专用*/
+ (UITextField *)creatTextFieldWithPlaceHolder:(NSString *)placeHolder textAlignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor fontValue:(float)font;
/**登陆界面快捷创建*/
+ (UITextField *)creatTextFiledWithPlaceHolder:(NSString *)placeHolder;
/**
 * creat arrow Image
 */
//+ (UIImageView *)creatArrowNextIcon;
@end
