//
//  HFBaseListViewController.h
//  HupuNFL
//
//  Created by hupu.com on 14/11/10.
//  Copyright (c) 2014年 hupu.com. All rights reserved.
//

#import "AFLoadingCell.h"
#import "SearchViewController.h"
#define listPageSize 20 //每次请求的列表条目数
#define loadMoreOffset 35 //加载更多列表条目的滑动触发距离


@protocol NFLBaseListControllerDelegate <NSObject>

@optional
- (void)tableViewDidSelectWithIndexPath:(NSIndexPath *)indexPath;

@end


@interface BERBaseListViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *dataArray;

//@property (nonatomic, assign) RTSelectorBackType backType; //返回类型封装

@property BOOL needReloadMore; //是否需要请求更多列表数据，根据api数据返回设置
@property BOOL isRefreshData; //是否需要在获取数据后清除列表数据，在请求时设置，在获取数据后置回

@property BOOL isRequesting; //***是否正在请求，是则不做后续分页请求***

@property NSInteger pagnationNum; //分页数量，如果服务端返回分页列表数量小于该值，则表示分页结束（部分列表使用）

@property (nonatomic, assign) id<NFLBaseListControllerDelegate> baseListDelegate;

- (void)refreshData; //刷新数据
- (void)loadMoreData; //加载更多数据
- (void)finishRefreshingControl; //结束下拉刷新动画
- (void)autoRefreshData; //自动下拉刷新
- (void)cleanListArrayIfNeeded; //检查是否需要清理数据，下拉刷新时设置，获取数据后执行
- (void)checkPagnationForReloadMoreWithListCount:(NSInteger)listCount;

- (void)initModel;
- (void)initDisplay;

- (void)doBack;

- (void)hideRefreshControl; //隐藏下拉刷新控件

/*
 set nav bar
 */
- (void)drawMainTabItem;


- (void)drawTitle:(NSString *)title;

@end
