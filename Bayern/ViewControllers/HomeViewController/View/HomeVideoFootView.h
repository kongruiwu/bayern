//
//  HomeVideoFootView.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/21.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
#import "HomeVideoView.h"
@protocol HomeVideoFootViewDelegate <NSObject>

- (void)HomeVideoSelctWithModel:(HomePicModel *)model;

@end

@interface HomeVideoFootView : UIView
@property (nonatomic, strong) NSArray * videos;
@property (nonatomic, strong) UIButton * leftButton;
@property (nonatomic, strong) UIButton * rightButton;
@property (nonatomic, strong) UIView * groundView;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, assign) id<HomeVideoFootViewDelegate>delegate;
- (void)updateScrollViewWithVideoArray:(NSArray *)arr;
@end
