//
//  TeamerTableViewCell.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/17.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "teamerShowView.h"

@protocol TeamerTableViewCellDelegate <NSObject>

- (void)teamerClickWithModel:(HomeTeamerModel *)model;

@end

@interface TeamerTableViewCell : UITableViewCell
@property (nonatomic, strong) teamerShowView * leftTeamer;
@property (nonatomic, strong) teamerShowView * rightTeamer;
@property (nonatomic, strong) NSArray * models;
@property (nonatomic, assign) id<TeamerTableViewCellDelegate>delegate;
- (void)updateWithArray:(NSArray *)arr;
@end
