//
//  TeamerDeatilHeadView.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/20.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
#import "BERTeamerModel.h"
@interface TeamerDeatilHeadView : UIView
@property (nonatomic, strong) UILabel * numberLabel;
@property (nonatomic, strong) UILabel * cateLabel;
@property (nonatomic, strong) UILabel * cnNameLable;
@property (nonatomic, strong) UILabel * enNameLabel;
@property (nonatomic, strong) UIView * bottomLine;
@property (nonatomic, strong) UILabel * bottomTitle;
@property (nonatomic, strong) UIImageView * icon;
- (void)updateWithModel:(BERTeamerModel *)model;
@end
