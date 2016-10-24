//
//  HomeScroeHeadView.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/21.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
#import "HomeScoreView.h"
@protocol HomeScoreHeadViewDelegate <NSObject>
@optional
- (void)homeGameViewNewsButtonClickWithModel:(HomeGameModel *)model;
- (void)homeGameViewPicButtonClickWithModel:(HomeGameModel *)model;
@end
@interface HomeScroeHeadView : UIView
@property (nonatomic, strong) UIButton * leftButton;
@property (nonatomic, strong) UIButton * rightButton;
@property (nonatomic, strong) UIView * groundView;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, assign) id<HomeScoreHeadViewDelegate> delegate;
@property (nonatomic, strong) NSArray * models;
- (void)updateScrollViewWithArray:(NSArray *)arr andIndex:(NSInteger)index;
@end
