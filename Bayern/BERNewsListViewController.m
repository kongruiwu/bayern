//
//  BERNewsListViewController.m
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERNewsListViewController.h"
#import "BERNewsWordsCell.h"
#import "BERNewsPicCell.h"
#import "BERNewsDetailViewController.h"
#import "BERNewsPictureViewController.h"

#import "BERNewsPicModel.h"

#import "YTImageBrowerController.h"

@interface BERNewsListViewController ()

@end

@implementation BERNewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self drawMainTabItem];
    
    if (self.newsListType == NewsListTypeNews) {
        [self drawTitle:@"新闻"];
    } else if (self.newsListType == NewsListTypePic) {
        [self drawTitle:@"图片"];
    }
    
    if (self.newsListType == NewsListTypePic) {
        [[BERNewsPicModel sharedInstance] cleanNewsDataArr];
    }
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
- (void)initModel {
    [super initModel];
    self.pagnationNum = 10;
}

- (void)initDisplay {
    [super initDisplay];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)refreshData {
    
    self.isRefreshData = YES;
    
    if (self.newsListType == NewsListTypePic) {
        [NFLAppLogManager sendLogWithEventID:EventID_Photos withKeyName:KN_PhotosList andValueName:@"RefreshPhotosList"];
        
        [[BERNewsPicModel sharedInstance] cleanNewsDataArr];
    }else {
        [NFLAppLogManager sendLogWithEventID:EventID_News withKeyName:KN_NewsList andValueName:@"RefreshNewsList"];
        
    }
    
    [self doRequestList:NO];
    
}

- (void)loadMoreData {
    if (self.newsListType == NewsListTypePic) {
        [NFLAppLogManager sendLogWithEventID:EventID_Photos withKeyName:KN_PhotosList andValueName:@"LoadingPhotosList"];
        
    }else {
        [NFLAppLogManager sendLogWithEventID:EventID_News withKeyName:KN_NewsList andValueName:@"LoadingNewsList"];
        
    }

    [self doRequestList:YES];
}

#pragma mark - Request Method

- (NSString *)getActionName {
    return @"get_list";
}

- (NSString *)getMainActionName {
    if (self.newsListType == NewsListTypePic) {
        return @"album";
    }
    return @"news";
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
    
    
    [self requestListWithDataParams:[self getDataParams:isNext]];
    self.isRequesting = YES;
}

//获取分业数据id
- (NSString *)getLastNewsID {
    
    id newsID = [self.dataArray lastObject][@"id"];
    if ([newsID isKindOfClass:[NSNumber class]]) {
        return [newsID stringValue];
    } else if ([newsID isKindOfClass:[NSString class]]) {
        return newsID;
    }
    
    return @"";
}

//获取分业数据时间
- (NSString *)getLastTime {
    
    id newsID = [self.dataArray lastObject][@"date"];
    if ([newsID isKindOfClass:[NSNumber class]]) {
        return [newsID stringValue];
    } else if ([newsID isKindOfClass:[NSString class]]) {
        return newsID;
    }
    
    return @"";
}

//组装请求数据
- (NSDictionary *)getDataParams:(BOOL)isNext {
    
    NSDictionary *params = nil;
    NSString *lastIdKey = @"last_news_id";
    if (self.newsListType == NewsListTypePic) {
        lastIdKey = @"last_album_id";
    }
    
    if (isNext) {
        params = @{
                   @"last_time"  :   [self getLastTime],
                   @"limit"    :   [NSString stringWithFormat:@"%ld", (long)self.pagnationNum],
                   lastIdKey : [self getLastNewsID]
                   };
    } else {
        params = @{
                   @"last_time"  :   @"",
                   @"limit"    :   [NSString stringWithFormat:@"%ld", (long)self.pagnationNum],
                   lastIdKey : @""
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
        //DLog(@"~~~~~list response [%@]", responseObject);
//        NSLog(@"^^^^^^^^^^^^^^^^^^^^^^^^^^^%@^^^^^^^^^^^^^^^^^^^^^^^^",[BERApiProxy urlWithAction:[self getMainActionName]]);
      //  NSLog(@"**************************%@*************************",params);
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] integerValue] == 0) {
            [self cleanListArrayIfNeeded];
            
            NSArray *dataArr = dic[@"data"];
            
            if (dataArr.count > 0) {
                [self checkPagnationForReloadMoreWithListCount:dataArr.count]; //查询是否需要结束下拉更多
                
                for (int i = 0; i < dataArr.count; i ++) {
                    [listDataArray addObject:dataArr[i]];
                    if (self.newsListType == NewsListTypePic) {
                        [[BERNewsPicModel sharedInstance] addNewsData:dataArr[i]];
                    }
                }
                
            } else {
                DLog(@"~~~~~no list data");
                //无更多数据
                self.needReloadMore = NO;
            }
            
            [tableView reloadData];
        }
        [self finishRefreshingControl];
        self.isRequesting = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        self.isRequesting = NO;
    }];
}

#pragma mark - UITableViewDataSource / Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.needReloadMore) {
        if (indexPath.row == self.dataArray.count) {
            return LOADING_CELL_HEIGHT;
        }
    }
    
    if (self.newsListType == NewsListTypePic) {
        return BER_NEWS_PIC_CELL_HEIGHT;
    }
    
    return BER_NEWS_WORDS_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *newsCellIdentifier = @"newsCell";
    static NSString *moreCellIntifier = @"moreCell";
    
    if (self.needReloadMore && indexPath.row == self.dataArray.count) {
        AFLoadingCell *moreCell = [tableView dequeueReusableCellWithIdentifier:moreCellIntifier];
        if (moreCell == nil) {
            moreCell = [[AFLoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moreCellIntifier];
        }
        [moreCell.spinner startAnimating];
        return moreCell;
    }
    
    if (self.newsListType == NewsListTypePic) {
        BERNewsPicCell *cell = [tableView dequeueReusableCellWithIdentifier:newsCellIdentifier];
        
        if (cell == nil) {
            cell = [[BERNewsPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newsCellIdentifier];
        }
        
        [cell configureCell:self.dataArray[indexPath.row]];
        [cell showCellLineWithHeight:BER_NEWS_PIC_CELL_HEIGHT];
        
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
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *newdID = [dic stringValueForKey:@"id"];
    
    NSString *shareTitle = [dic stringValueForKey:@"title"];
    
    [BERShareModel sharedInstance].shareTitle = shareTitle;
    [BERShareModel sharedInstance].shareID = newdID;
    
    if (self.newsListType == NewsListTypeNews) {
        if ([cell isKindOfClass:[BERNewsWordsCell class]]) {
            [BERShareModel sharedInstance].shareImg = [[(BERNewsWordsCell *)cell imgView] image];
        }
        [NFLAppLogManager sendLogWithEventID:EventID_News withKeyName:KN_NewsList andValueName:@"News"];
        
        BERNewsDetailViewController *nd = [[BERNewsDetailViewController alloc] init];
        nd.news_id = newdID;
        [self.navigationController pushViewController:nd animated:YES];
    } else if (self.newsListType == NewsListTypePic) {
        
        
        
        if ([cell isKindOfClass:[BERNewsPicCell class]]) {
            [BERShareModel sharedInstance].shareImg = [[(BERNewsPicCell *)cell imgView1] image];
        }
        [NFLAppLogManager sendLogWithEventID:EventID_Photos withKeyName:KN_PhotosList andValueName:@"Photos"];
        
//        BERNewsPictureViewController *nd = [[BERNewsPictureViewController alloc] init];
//        nd.news_id = newdID;
        YTImageBrowerController * vc = [[YTImageBrowerController alloc]init];
        vc.news_id = newdID;
        vc.titleName = [dic stringValueForKey:@"title"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
