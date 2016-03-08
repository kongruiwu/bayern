//
//  BERTeamCell.h
//  Bayern
//
//  Created by wusicong on 15/6/19.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERBaseTableViewCell.h"

#define TeamCellHeight 350/2

@interface BERTeamCell : BERBaseTableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *positionLalel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *ennameLabel;
@property (nonatomic, strong) UILabel *birthLabel;
@property (nonatomic, strong) UILabel *numberLabel;

@end
