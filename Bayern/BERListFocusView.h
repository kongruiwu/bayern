//
//  NFLVideoFocusView.h
//  HupuNFL
//
//  Created by Wusicong on 14/11/26.
//  Copyright (c) 2014年 hupu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FocusViewHeight (WindowWidth / (960/445))

@protocol BERListFocusViewDelegate <NSObject>

@optional
- (void)focusViewDidClickWithIndex:(NSInteger)index;

@end

@interface BERListFocusView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *focusScrollView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property id <BERListFocusViewDelegate> delegate;

- (void)creatDisplay;
- (void)redrawWithData:(NSArray *)dataArr;

@end
