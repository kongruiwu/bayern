//
//  ScoreTableViewCell.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/17.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
@protocol ScoreTableViewCellDelegate <NSObject>

- (void)homeGameClickAtIndex:(int)index;

@end

@interface ScoreTableViewCell : UITableViewCell
@property (nonatomic, strong) UIButton * leftButton;
@property (nonatomic, strong) UIButton * rightButton;
@property (nonatomic, strong) UIView * groundView;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, assign) id<ScoreTableViewCellDelegate> delegate;
- (void)updateScrollViewWithArray:(NSArray *)arr;
@end
