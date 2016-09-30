//
//  AutoScrollView.h
//  XYL_iOS
//
//  Created by wurui on 16/6/17.
//  Copyright © 2016年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
typedef void(^CountButtonImageClickBlock)(void);


@interface AutoScrollView : UIView

/** 存放图片的数组*/
@property (nonatomic,strong) NSArray *images;
@property (nonatomic, strong) UIPageControl   *pageControl;
@property (nonatomic, strong) NSArray * descs;
@property (nonatomic, strong) NSMutableArray * descStrings;
@property (nonatomic, strong)NSMutableArray * imageViews;
/** 开启定时器*/
- (void)startTimer;

/** 移除定时器*/
- (void)invalidateTimer;

@property (nonatomic,assign) BOOL isShowButton;

@property (nonatomic,strong) UIButton *countButton;

///** 存放点击按钮图片的数组*/
@property (nonatomic,strong) NSArray *buttonImageArr;

@property (nonatomic,copy) CountButtonImageClickBlock countButtonImageClickBlock;

@end
