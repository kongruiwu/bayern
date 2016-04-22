//
//  BERFactory.h
//  Bayern
//
//  Created by wurui on 16/4/22.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BERHeadFile.h"

@interface BERFactory : NSObject

/**
 * 创建 sc
 */
+ (UIScrollView *)creatScrollViewWithcontentSize:(CGSize)size contentOffset:(CGPoint)point backGroundColor:(UIColor *)color;

/**
 * 创建label
 */
+ (UILabel *)creatLabelWithText:(NSString *)title textColor:(UIColor *)textColor textFont:(CGFloat)FontValue textAlignment:(NSTextAlignment)textAlignment;
/**
 * 获取size
 */
+ (CGSize)getSize:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont*)font;
@end
