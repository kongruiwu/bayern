//
//  UserCenterCell.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/3.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
@interface UserCenterCell : UITableViewCell
@property (nonatomic, strong) UIImageView * icon;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UIImageView * nextIcon;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, assign) BOOL arrowHiden;

- (void)hideArrowIcon:(BOOL)rec;
- (void)configUIwithTitle:(NSString *)title imageName:(NSString *)imageName descText:(NSString *)descStr;
@end
