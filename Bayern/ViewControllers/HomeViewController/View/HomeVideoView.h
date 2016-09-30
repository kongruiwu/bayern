//
//  HomeVideoView.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/19.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
#import "HomdeVideoModel.h"
@interface HomeVideoView : UIView
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIImageView * videoIcon;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) HomdeVideoModel * model;
- (void)updateImageViewWithModel:(HomdeVideoModel *)model;
@end
