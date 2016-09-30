//
//  teamerShowView.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/17.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
#import "HomeTeamerModel.h"
@interface teamerShowView : UIView
@property (nonatomic, strong) UIView * groundView;
@property (nonatomic, strong) UIView * nameView;
@property (nonatomic, strong) UIImageView * teamImage;
@property (nonatomic, strong) UILabel * countLabel;
@property (nonatomic, strong) UILabel * namelabel;
- (void)updateWithHomeTeamerModel:(HomeTeamerModel *)model;
@end
