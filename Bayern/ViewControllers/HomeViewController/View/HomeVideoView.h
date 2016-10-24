//
//  HomeVideoView.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/19.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
#import "HomePicModel.h"
@interface HomeVideoView : UIView
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) HomePicModel * model;
- (void)updateImageViewWithModel:(HomePicModel *)model;
@end
