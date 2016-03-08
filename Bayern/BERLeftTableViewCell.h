//
//  BERLeftTableViewCell.h
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BERBaseTableViewCell.h"

#define LeftCellHeight 45

@interface BERLeftTableViewCell : BERBaseTableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *selectedIconName;

@end
