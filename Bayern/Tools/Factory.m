//
//  Factory.m
//  TruckClan
//
//  Created by 吴孔锐 on 16/8/4.
//  Copyright © 2016年 wurui. All rights reserved.
//

#import "Factory.h"

@implementation Factory
+ (UILabel *)creatLabelWithTitle:(NSString *)title textColor:(UIColor *)textColor textFont:(CGFloat)fontValue textAlignment:(NSTextAlignment)alignment {
    UILabel * label = [[UILabel alloc]init];
    label.text = title;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontValue];
    label.textAlignment = alignment;
    return label;
}
+ (CGSize)getSize:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont*)font{
    CGSize sizeFirst = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil].size;
    return sizeFirst;
}

+ (UITableView *)creatTabbleViewWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    UITableView * tabview = [[UITableView alloc]initWithFrame:frame style:style];
    tabview.showsVerticalScrollIndicator = NO;
    tabview.showsHorizontalScrollIndicator = NO;
    tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabview.backgroundColor = [UIColor clearColor];
    return tabview;
}
+ (UIButton *)creatImageButtonWithTitle:(NSString *)title textFont:(CGFloat)textFontVlaue titleColor:(UIColor *)titleColor backGroundColor:(UIColor *)backGroundColor andImage:(NSString *)imageName{
    UIButton * button = [Factory creatButtonWithTitle:title textFont:textFontVlaue titleColor:titleColor backGroundColor:backGroundColor];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return button;
}
+ (UIButton *)creatGroundImageButtonWithImage:(NSString *)imageName{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return button;
}
+ (UIButton *)creatButtonWithTitle:(NSString *)title textFont:(CGFloat)textFontVlaue titleColor:(UIColor *)titleColor backGroundColor:(UIColor *)backGroundColor{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:textFontVlaue];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:backGroundColor];
    [button setTitleColor:titleColor forState:UIControlStateNormal];

    return button;
}
+ (UIButton *)creatButtonWithNormalImage:(NSString *)normalImage selectImage:(NSString *)selectImage{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    if (selectImage != nil) {
        [button setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
    }
    return button;
}
+ (UIView *)creatViewWithColor:(UIColor *)color{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = color;
    return view;
}

/// 十六进制转换 + 不透明
+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    return [self colorWithHexString:hexString alpha:1.0f];
}

/// 十六进制转换 + 透明度
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =0;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]]scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]]scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:alpha];
}
+ (UIImageView *)creatImageViewWithImageName:(NSString *)image{
    UIImageView * imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    return imgView;
}
+ (UITextField *)creatTextFieldWithPlaceHolder:(NSString *)placeHolder textAlignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor{
    UITextField * textfield = [[UITextField alloc]init];
    textfield.placeholder = placeHolder;
    textfield.textAlignment = alignment;
    textfield.textColor = textColor;
    return textfield;
}
+ (UITextField *)creatTextFieldWithPlaceHolder:(NSString *)placeHolder textAlignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor fontValue:(float)font{
    UITextField * textF = [Factory creatTextFieldWithPlaceHolder:placeHolder textAlignment:alignment textColor:textColor];
    textF.font = [UIFont systemFontOfSize:font];
    textF.layer.cornerRadius = Anno750(44);
    textF.layer.borderColor = [UIColor whiteColor].CGColor;
    textF.layer.borderWidth = 1.0f;
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:placeHolder];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, placeHolder.length)];
    textF.attributedPlaceholder = attStr;
    return textF;
}
+ (UITextField *)creatTextFiledWithPlaceHolder:(NSString *)placeHolder{
   return [Factory creatTextFieldWithPlaceHolder:placeHolder textAlignment:NSTextAlignmentCenter textColor:[UIColor whiteColor] fontValue:font750(28)];
}
//+ (UIImageView *)creatArrowNextIcon{
//    return [Factory creatImageViewWithImageName:@"arrows"];
//}
@end
