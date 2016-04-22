//
//  BERFactory.m
//  Bayern
//
//  Created by wurui on 16/4/22.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BERFactory.h"

@implementation BERFactory
+ (UIScrollView *)creatScrollViewWithcontentSize:(CGSize)size contentOffset:(CGPoint)point backGroundColor:(UIColor *)color{
    UIScrollView * sc = [[UIScrollView alloc]init];
    sc.showsVerticalScrollIndicator = NO;
    sc.showsHorizontalScrollIndicator = NO;
    sc.contentSize = size;
    sc.contentOffset = point;
    sc.backgroundColor = color;
    return sc;
}
+ (UILabel *)creatLabelWithText:(NSString *)title textColor:(UIColor *)textColor textFont:(CGFloat)FontValue textAlignment:(NSTextAlignment)textAlignment{
    UILabel * label = [[UILabel alloc]init];
    label.text = title;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.font = [UIFont systemFontOfSize:FontValue];
    return label;
}
+ (CGSize)getSize:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont*)font{
    CGSize sizeFirst = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil].size;
    return sizeFirst;
}
@end
