//
//  HupuTitleScrollView.h
//  games
//
//  Created by wusicong on 15/5/8.
//
//

#import <UIKit/UIKit.h>

#define tScrollHeight 35

@protocol HupuTitleScrollViewDelegate <NSObject>

@optional
- (void)titleScrollViewIndexDidClickWithIndex:(NSInteger)index;
- (void)titleScrollViewSetupButtonDidClick;

@end

@interface HupuTitleScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UIScrollView *titleScrollView;
@property id <HupuTitleScrollViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *titleButtonArray;
@property (nonatomic, strong) NSMutableArray *titleLabelArray;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, assign) BOOL hideRightButton; //是否显示右侧按钮，兼容其他页面的复用
@property (nonatomic, assign) BOOL splitTitlePart; //是否均分显示顶部导航栏各部分，兼容其他页面的复用

- (void)createWithTitleArr:(NSArray *)titleArr;
- (void)setTitleButtonColorWithSelectIndex:(NSInteger)index;

@end
