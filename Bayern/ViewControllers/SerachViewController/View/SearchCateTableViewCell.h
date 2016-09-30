//
//  SearchCateTableViewCell.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/19.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchCateModel.h"
#import "Factory.h"
@interface SearchCateTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView * icon;
@property (nonatomic, strong) UILabel * nameLabel;

- (void)updateWithSearchCateModel:(SearchCateModel *)model;
@end
