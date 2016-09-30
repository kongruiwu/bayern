//
//  LeftRootScoreTableViewCell.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/17.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
#import "TeamRankModel.h"
@interface LeftRootScoreTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel * countLabel;
@property (nonatomic, strong) UIImageView * icon;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * winScoreLabel;
@property (nonatomic, strong) UILabel * ballCountLabel;
@property (nonatomic, strong) UILabel * scoreLabel;
- (void)updateWithTeamRankModel:(TeamRankModel *)model;
@end
