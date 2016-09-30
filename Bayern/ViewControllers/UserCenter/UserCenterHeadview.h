//
//  UserCenterHeadview.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/3.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
@interface UserCenterHeadview : UIView
@property (nonatomic, strong) UIImageView * topImageView;
@property (nonatomic, strong) UIImageView * userIcon;
@property (nonatomic, strong) UILabel * userName;
@property (nonatomic, strong) UILabel * timeLabel;

- (void)updateUI;
@end
