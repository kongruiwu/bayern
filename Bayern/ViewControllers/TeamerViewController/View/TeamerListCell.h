//
//  TeamerListCell.h
//  Bayern
//
//  Created by 吴孔锐 on 2016/10/13.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
#import "ListTeamerModel.h"
@interface TeamerListCell : UITableViewCell

@property (nonatomic, strong) UILabel * CHNameLabel;
@property (nonatomic, strong) UILabel * ENNameLabel;
@property (nonatomic, strong) UIImageView * icon;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UILabel * cateLabel;
@property (nonatomic, strong) UILabel * teamNum;
@property (nonatomic, strong) UILabel * birthLabel;

- (void)updateWithModel:(ListTeamerModel *)model;
@end
