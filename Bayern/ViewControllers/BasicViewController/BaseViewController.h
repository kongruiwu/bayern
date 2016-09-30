//
//  BaseViewController.h
//  Bayern
//
//  Created by 吴孔锐 on 16/8/31.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Factory.h"
@interface BaseViewController : UIViewController
@property (nonatomic, assign) SelectorBackType backType;

- (void)doBack;
- (void)drawBackButton;
- (void)setNavigationTitle:(NSString *)title;
- (void)setBackGroundImage;
@end
