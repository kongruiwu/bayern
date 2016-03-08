//
//  BERRightTableViewCell.h
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BERBaseTableViewCell.h"

#define RightCellHeight 200

@protocol BERRightTableViewCellDelegate <NSObject>

- (void)BERRightTableViewCellGameButtonClick:(NSInteger)index;
- (void)BERRightTableViewCellPicButtonClick:(NSInteger)index;
@end

@interface BERRightTableViewCell : BERBaseTableViewCell

@property (nonatomic, strong) UIImageView *homeIcon;
@property (nonatomic, strong) UIImageView *awayIcon;

@property (nonatomic, strong) UILabel *homeLabel;
@property (nonatomic, strong) UILabel *awayLabel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *scoreSmallLabel;

@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) UIButton *newsButton;
@property (nonatomic, strong) UIButton *picButton;
@property (nonatomic, assign) id <BERRightTableViewCellDelegate> delegate;
@property NSInteger index;

- (void)showCellLineWithHeight:(CGFloat)height color:(UIColor *)color;

@end
