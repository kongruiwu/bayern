//
//  MainListViewController.m
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERHomeListViewController.h"
#import "BERNewsWordsCell.h"
#import "BERNewsPicCell.h"
#import "BERAdvCell.h"
#import "BERListFocusView.h"
#import "BERNewsDetailViewController.h"
//#import "BERNewsPictureViewController.h"
#import "YTImageBrowerController.h"
#import "BERShopViewController.h"
#import "BERNewsPicModel.h"

#import "BERNewsVideoCell.h"
#import "BERVideoPlayerViewController.h"

@interface BERHomeListViewController () <BERListFocusViewDelegate>

@property (nonatomic, strong) BERListFocusView *focusView;
@property (nonatomic, strong) NSMutableArray *focusDataArray; //轮播数据

@property (nonatomic, strong) NSMutableArray *advDataArray;

@property BOOL hasListDataFinished;
@property BOOL hasAdvDataFinished;

@property BOOL isRefreshList; //是否下拉刷新，是则需要请求时组装列表和广告数据

@end

@implementation BERHomeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [self drawMainTabItem];
    [self drawTitle:@"首页"];
    
    [[BERNewsPicModel sharedInstance] cleanNewsDataArr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.dataArray.count == 0) {
        [self autoRefreshData];
    }
}

- (void)dealloc {
    DLog(@"dealloc BERHomeListViewController");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initModel {
    [super initModel];
    self.pagnationNum = 10;
    self.focusDataArray = [NSMutableArray array];
    self.advDataArray = [NSMutableArray array];
}

- (void)initDisplay {
    [super initDisplay];
    
    [self showHeaderView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)showHeaderView {
    
    self.focusView = [[BERListFocusView alloc] initWithFrame:CGRectMake(0, 0, WindowWidth, FocusViewHeight)];
    [self.focusView creatDisplay];
    self.focusView.delegate = self;
    self.tableView.tableHeaderView = self.focusView;
}

- (void)refreshData {
    [NFLAppLogManager sendLogWithEventID:EventID_Index withKeyName:KN_List andValueName:@"RefreshList"];
    
    self.isRefreshData = YES;
    
    [[BERNewsPicModel sharedInstance] cleanNewsDataArr];
    
    [self doRequestList:NO];
    
    [self requestAdv];
}

- (void)loadMoreData {
    [NFLAppLogManager sendLogWithEventID:EventID_Index withKeyName:KN_List andValueName:@"LoadingList"];
    
    [self doRequestList:YES];
}

- (int)isNewsTypeWithIndex:(NSInteger)index {
    NSDictionary *dic = self.dataArray[index];
    NSString *cont_type = dic[@"cont_type"];
    
    if ([dic[@"cont_type"] isKindOfClass:[NSNumber class]]) {
        cont_type = [dic[@"cont_type"] stringValue];
    }
    
    if ([cont_type isEqualToString:@"1"]) {
        return 1;
    }else if([cont_type isEqualToString:@"9"])
    {
        return 9;
    }
    
    return 2;
}

- (BOOL)isAdvTypeWithIndex:(NSInteger)index {
    NSDictionary *dic = self.dataArray[index];
    NSString *cont_type = [dic stringValueForKey:@"cont_type"];
    
    if ([cont_type isEqualToString:@"0"]) {
        return YES;
    }
    
    return NO;
}

- (void)mixListData {
    if (self.hasAdvDataFinished == NO || self.hasListDataFinished == NO) {
        return;
    }
    
    if (self.isRefreshList == NO) {
        return;
    }
    
    if (self.advDataArray.count >= 2) {
        NSDictionary *dic = self.advDataArray[0];
        NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [newDic setObject:@"0" forKey:@"cont_type"];
        [self.dataArray insertObject:newDic atIndex:0];
        
        if (self.dataArray.count > 8) {
            NSDictionary *dic = self.advDataArray[1];
            NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [newDic setObject:@"0" forKey:@"cont_type"];
            [self.dataArray insertObject:newDic atIndex:8];
        }
    }
    
    [self.tableView reloadData];
    
    self.hasListDataFinished = NO;
    self.hasAdvDataFinished = NO;
    self.isRefreshList = NO;
}

#pragma mark - Request Method

- (NSString *)getActionName {
    return @"get_mix_list";
}

- (NSString *)getMainActionName {
    return @"home_data";
}

- (void)doRequestList:(BOOL)isNext {
    if (self.isRequesting) {
        return;
    }
    
    if (![BERNetworkManager isNetworkOkay]) {
        [self.view showInfo:NetworkErrorTips autoHidden:YES];
        [self finishRefreshingControl];
        return;
    }
    
    self.isRefreshList = !isNext;
    
    [self requestListWithDataParams:[self getDataParams:isNext]];
    
    if (!isNext) {
        [self requestHeaderFocusWithDataParams:@{}];
    }
    self.isRequesting = YES;
}

//获取分业数据id
- (NSString *)getLastTime {
    
    id newsID = [self.dataArray lastObject][@"date"];
    if ([newsID isKindOfClass:[NSNumber class]]) {
        return [newsID stringValue];
    } else if ([newsID isKindOfClass:[NSString class]]) {
        return newsID;
    }
    
    return @"";
}

//获取分业数据id
- (NSString *)getLastID {
    
    id newsID = [self.dataArray lastObject][@"id"];
    if ([newsID isKindOfClass:[NSNumber class]]) {
        return [newsID stringValue];
    } else if ([newsID isKindOfClass:[NSString class]]) {
        return newsID;
    }
    
    return @"";
}

- (BOOL)isLastTypeNews {
    id cont_type = [self.dataArray lastObject][@"cont_type"];
    if ([cont_type isKindOfClass:[NSNumber class]] && [cont_type integerValue] == 1) {
        return YES;
    } else if ([cont_type isKindOfClass:[NSString class]] && [cont_type integerValue] == 1) {
        return YES;
    }
    
    return NO;
}

//组装请求数据
- (NSDictionary *)getDataParams:(BOOL)isNext {
    
    NSDictionary *params = nil;
    NSString *lastIdKey = @"last_news_id";
    if (![self isLastTypeNews]) {
        lastIdKey = @"last_album_id";
    }
    
    if (isNext) {
        params = @{
                   @"last_time"  :   [self getLastTime],
                   @"limit"    :   [NSString stringWithFormat:@"%ld", (long)self.pagnationNum],
                   lastIdKey : [self getLastID]
                   };
    } else {
        params = @{
                   @"last_time"  :   @"",
                   @"limit"    :   [NSString stringWithFormat:@"%ld", (long)self.pagnationNum],
                   lastIdKey : [self getLastID]
                   };
    }
    
    return params;
}

- (void)requestListWithDataParams:(NSDictionary *)params {
    
    __block NSMutableArray *listDataArray = self.dataArray;
    __block UITableView *tableView = self.tableView;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BERApiProxy urlWithAction:[self getMainActionName]] parameters:[BERApiProxy paramsWithDataDic:params action:[self getActionName]] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        DLog(@"~~~~~list response [%@]", responseObject);
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] integerValue] == 0) {
            [self cleanListArrayIfNeeded];
            
            NSArray *dataArr = dic[@"data"];
            
            if (dataArr.count > 0) {
                [self checkPagnationForReloadMoreWithListCount:dataArr.count]; //查询是否需要结束下拉更多
                
                for (int i = 0; i < dataArr.count; i ++) {
                    [listDataArray addObject:dataArr[i]];
                    
                    if (![self isNewsTypeWithIndex:i]) {
                        [[BERNewsPicModel sharedInstance] addNewsData:dataArr[i]];
                    }
                }
                
            } else {
                DLog(@"~~~~~no list data");
                //无更多数据
                self.needReloadMore = NO;
            }
            
            self.hasListDataFinished = YES;
            
            if (self.isRefreshList) {
                [self mixListData];
            } else {
                [tableView reloadData];
            }
            
        }
        [self finishRefreshingControl];
        self.isRequesting = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        self.isRequesting = NO;
    }];
}

//请求轮播焦点图
- (void)requestHeaderFocusWithDataParams:(NSDictionary *)params {
    if (![BERNetworkManager isNetworkOkay]) {
        return;
    }
    
    [self.focusDataArray removeAllObjects];
    
    __block NSMutableArray *focusDataArr = self.focusDataArray;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BERApiProxy urlWithAction:[self getMainActionName]] parameters:[BERApiProxy paramsWithDataDic:params action:@"get_focus"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        DLog(@"focus response [%@]", responseObject);
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        if ([dic[@"code"] integerValue] == 0) {
            NSArray *dataArr = [NSArray arrayWithArray:dic[@"data"]];
            
            if (dataArr.count > 0) {
                [focusDataArr removeAllObjects]; //先清空数据
                
                for (int i = 0; i < dataArr.count; i ++) {
                    [focusDataArr addObject:dataArr[i]];
                }
            }
            
            [self.focusView redrawWithData:focusDataArr];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        
    }];
}

- (void)requestAdv {
    if (![BERNetworkManager isNetworkOkay]) {
        return;
    }
    
    __block NSMutableArray *focusDataArr = self.advDataArray;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BERApiProxy urlWithAction:@"home_data"] parameters:[BERApiProxy paramsWithDataDic:@{} action:@"get_mid_adv"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        DLog(@"adv response [%@]", responseObject);
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        if ([dic[@"code"] integerValue] == 0) {
            NSArray *dataArr = [NSArray arrayWithArray:dic[@"data"]];
            
            if (dataArr.count > 0) {
                [focusDataArr removeAllObjects]; //先清空数据
                
                for (int i = 0; i < dataArr.count; i ++) {
                    [focusDataArr addObject:dataArr[i]];
                }
            }
            
            self.hasAdvDataFinished = YES;
            [self mixListData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
}

#pragma mark - UITableViewDataSource / Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.needReloadMore) {
        if (indexPath.row == self.dataArray.count) {
            return LOADING_CELL_HEIGHT;
        }
    }
    
    if ([self isAdvTypeWithIndex:indexPath.row]) {
        return ADV_CELL_HEIGHT;
    }
    
    if ([self isNewsTypeWithIndex:indexPath.row]==2) {
        return BER_NEWS_PIC_CELL_HEIGHT;
    }
    
    return BER_NEWS_WORDS_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *newsCellIdentifier = @"newsCell";
    static NSString *picCellIdentifier = @"picCell";
    static NSString *moreCellIntifier = @"moreCell";
    static NSString *advCellIntifier = @"advCell";
    static NSString *videoCellIntifier=@"videoCell";
    
    if (self.needReloadMore && indexPath.row == self.dataArray.count) {
        AFLoadingCell *moreCell = [tableView dequeueReusableCellWithIdentifier:moreCellIntifier];
        if (moreCell == nil) {
            moreCell = [[AFLoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moreCellIntifier];
        }
        [moreCell.spinner startAnimating];
        return moreCell;
    }
    
    if ([self isAdvTypeWithIndex:indexPath.row]) {
        BERAdvCell *cell = [tableView dequeueReusableCellWithIdentifier:advCellIntifier];
        if (cell == nil) {
            cell = [[BERAdvCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:advCellIntifier];
        }
        
        NSDictionary *dic = self.dataArray[indexPath.row];
        [cell configureCell:dic];
        
        return cell;
    }
    
    if ([self isNewsTypeWithIndex:indexPath.row]==2) {
        BERNewsPicCell *cell = [tableView dequeueReusableCellWithIdentifier:picCellIdentifier];
        
        if (cell == nil) {
            cell = [[BERNewsPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:picCellIdentifier];
        }
        
        [cell configureCell:self.dataArray[indexPath.row]];
        [cell showCellLineWithHeight:BER_NEWS_PIC_CELL_HEIGHT];
        
        return cell;
    }else if ([self isNewsTypeWithIndex:indexPath.row]==9)
    {
        BERNewsVideoCell *cell=[tableView dequeueReusableCellWithIdentifier:videoCellIntifier];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"BERNewsVideoCell" owner:self options:nil] lastObject];
        }
        [cell configUIwith:self.dataArray[indexPath.row]];
        
        return cell;
    }
    
    BERNewsWordsCell *cell = [tableView dequeueReusableCellWithIdentifier:newsCellIdentifier];
    
    if (cell == nil) {
        cell = [[BERNewsWordsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newsCellIdentifier];
    }
    
    [cell configureCell:self.dataArray[indexPath.row]];
    [cell showCellLineWithHeight:BER_NEWS_WORDS_CELL_HEIGHT];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == self.dataArray.count) {
        return; //点击加载更多cell，不操作
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    if ([self isAdvTypeWithIndex:indexPath.row]) {
        //跳转广告页面
        BERShopViewController *sv = [[BERShopViewController alloc] init];
        sv.url = [NSURL URLWithString:[dic stringValueForKey:@"url"]];
        sv.isNormalWebView = YES;
        [self.navigationController pushViewController:sv animated:YES];
        return;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *newdID = [dic stringValueForKey:@"id"];
    
    NSString *shareTitle = [dic stringValueForKey:@"title"];
    
    
    [BERShareModel sharedInstance].shareTitle = shareTitle;
    [BERShareModel sharedInstance].shareID = newdID;
    
    if ([self isNewsTypeWithIndex:indexPath.row]==1) {
        if ([cell isKindOfClass:[BERNewsWordsCell class]]) {
            [BERShareModel sharedInstance].shareImg = [[(BERNewsWordsCell *)cell imgView] image];
        }
        [NFLAppLogManager sendLogWithEventID:EventID_Index withKeyName:KN_List andValueName:@"News"];
        
        BERNewsDetailViewController *nd = [[BERNewsDetailViewController alloc] init];
        nd.news_id = newdID;
        [self.navigationController pushViewController:nd animated:YES];
    } else if([self isNewsTypeWithIndex:indexPath.row]==2) {
        if ([cell isKindOfClass:[BERNewsPicCell class]]) {
            [BERShareModel sharedInstance].shareImg = [[(BERNewsPicCell *)cell imgView1] image];
        }
        [NFLAppLogManager sendLogWithEventID:EventID_Index withKeyName:KN_List andValueName:@"Photos"];
        
//        BERNewsPictureViewController *nd = [[BERNewsPictureViewController alloc] init];
        YTImageBrowerController * vc = [[YTImageBrowerController alloc]init];
        vc.news_id = newdID;
        vc.titleName = shareTitle;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([self isNewsTypeWithIndex:indexPath.row]==9)
    {
        if ([cell isKindOfClass:[BERNewsVideoCell class]]) {
            [BERShareModel sharedInstance].shareImg = [[(BERNewsVideoCell *)cell videoImgView] image];
        }
        
        BERVideoPlayerViewController *vc=[[BERVideoPlayerViewController alloc]init];
        vc.url=[NSURL URLWithString:dic[@"link"]];
        vc.videoUrl=dic[@"link"];
        vc.videotitle=dic[@"title"];
        vc.videoiconUrl=dic[@"pic"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - NFLListFocusViewDelegate

- (void)focusViewDidClickWithIndex:(NSInteger)index {
    [NFLAppLogManager sendLogWithEventID:EventID_Index withKeyName:KN_List andValueName:@"News"];
    
    NSDictionary *dic = self.focusDataArray[index];
    NSString *newdID = [dic stringValueForKey:@"id"];
    NSString *url = [dic stringValueForKey:@"url"];
    
    NSString *shareTitle = [dic stringValueForKey:@"title"];
    
    NSString *type = [dic stringValueForKey:@"show_type"];
    
    [BERShareModel sharedInstance].shareTitle = shareTitle;
    [BERShareModel sharedInstance].shareID = newdID;
    [BERShareModel sharedInstance].shareImg = [(UIImageView *)self.focusView.imageArray[index] image];
    
    BERNewsDetailViewController *nd = [[BERNewsDetailViewController alloc] init];
    nd.news_id = newdID;
    nd.news_url = url;
    nd.isPictureType = [type integerValue] == 1 ? NO : YES;
    [self.navigationController pushViewController:nd animated:YES];
}

@end
