//
//  LeftHeadCell.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/23.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
@interface LeftHeadCell : UITableViewCell
@property (nonatomic, strong) UIImageView * UserIcon;
@property (nonatomic, strong) UILabel * loginLabel;
- (void)updateStatus;
@end
