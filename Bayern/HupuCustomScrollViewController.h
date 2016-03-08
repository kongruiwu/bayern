//
//  HupuCustomScrollViewController.h
//  games
//
//  Created by wusicong on 15/5/14.
//
//

#import "BERRootViewController.h"
#import "HupuTitleScrollView.h"

@protocol HupuCustomScrollViewDelegate <NSObject>

@optional
- (void)titleHupuCustomScrollViewDidClickWithIndex:(NSInteger)index;

@end

@interface HupuCustomScrollViewController : BERRootViewController <UIScrollViewDelegate, HupuTitleScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *navScrollTitleArray; //导航标题
@property (nonatomic, strong) HupuTitleScrollView *titleScrollView;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSMutableArray *contentControllerArray; //显示页面容器，由上层VC各自维护
@property (nonatomic, weak) id <HupuCustomScrollViewDelegate>delegate;

- (NSInteger)getCurrentIndex; //获取当前index
- (void)addContentControllers;
- (void)setNavigationBar; //重绘导航和数据列表

@end
