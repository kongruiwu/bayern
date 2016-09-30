//
//  CommentTableViewCell.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/14.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
#import "CommentModel.h"
@protocol CommentCellDelegate <NSObject>

- (void)commenLikeButtonClick:(UIButton *)btn;

@end


@interface CommentTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView * userIcon;
@property (nonatomic, strong) UILabel * userName;
@property (nonatomic, strong) UILabel * creatTime;
@property (nonatomic, strong) UIButton * likeButton;
@property (nonatomic, strong) UILabel * content;
@property (nonatomic, strong) UIView * bottomLine;
@property (nonatomic, assign) id<CommentCellDelegate>delegate;

- (void)updateWithModel:(CommentModel *)model;
@end
