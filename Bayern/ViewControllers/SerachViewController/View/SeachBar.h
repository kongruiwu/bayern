//
//  SeachBar.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/13.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
@interface SeachBar : UIView
@property (nonatomic, strong) UIButton * cateButton;
@property (nonatomic, strong) UITextField * searchTF;
@property (nonatomic, strong) UIView * line;
@property (nonatomic, strong) UIImageView * searchIcon;
@property (nonatomic, strong) UIImageView * bottomIcon;
@end
