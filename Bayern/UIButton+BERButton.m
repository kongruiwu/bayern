//
//  UIButton+BERButton.m
//  Bayern
//
//  Created by wurui on 15/10/25.
//  Copyright © 2015年 Wusicong. All rights reserved.
//

#import "UIButton+BERButton.h"
#import "BERHeadFile.h"


@implementation UIButton (UIButton_BERButton)
- (UIButton *)initWithFrame:(CGRect)frame RedBackGroundColorAndTitle:(NSString *)title{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame = frame;
    self.layer.masksToBounds    = YES;
    self.layer.cornerRadius     = frame.size.height/2;
    self.backgroundColor        = [UIColor colorWithHexString:BERColor];
    self.layer.borderWidth      = 1.0f;
    self.layer.borderColor      = [[UIColor colorWithHexString:BERColor]CGColor];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    return self;
}
- (UIButton *)initWithFrame:(CGRect)frame WhiteBackGroundColorAndTitle:(NSString *)title{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame = frame;
    self.layer.masksToBounds    = YES;
    self.layer.cornerRadius     = frame.size.height/2;
    self.backgroundColor        = [UIColor whiteColor];
    self.layer.borderWidth      = 1.0f;
    self.layer.borderColor      = [[UIColor colorWithHexString:BERColor]CGColor];
    [self setTitleColor:[UIColor colorWithHexString:BERColor] forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    return self;
}
@end
