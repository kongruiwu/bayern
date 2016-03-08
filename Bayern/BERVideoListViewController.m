//
//  BERVideoListViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 15/7/30.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERVideoListViewController.h"
#import "BERVideosModel.h"
#import "BERVideosTableViewCell.h"
#import "BERVideoPlayerViewController.h"
@interface BERVideoListViewController ()

@end

@implementation BERVideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawMainTabItem];
    [self drawTitle:@"视频"];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.dataArray.count==0) {
        [self autoRefreshData];
    }
}
-(void)initModel
{
    [super initModel];
    self.pagnationNum=10;
}
-(void)initDisplay
{
    [super initDisplay];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}
-(void)refreshData
{
    self.isRefreshData=YES;
    [NFLAppLogManager sendLogWithEventID:EventID_Videos withKeyName:KN_VideosList andValueName:@"RefreshVideosList"];
    [self doRequestList:NO];
}
-(void)loadMoreData
{
    [NFLAppLogManager sendLogWithEventID:EventID_Videos withKeyName:KN_VideosList andValueName:@"LoadingVideosList"];
    [self doRequestList:YES];
}
#pragma mark - loadData
-(NSString *)getActionName
{
    return @"get_list";
}
-(NSString *)getMainActionName
{
    return @"video";
}
-(void)doRequestList:(BOOL)isNext
{
    if (self.isRequesting) {
        return;
    }
    if (![BERNetworkManager isNetworkOkay]) {
        [self.view showInfo:NetworkErrorTips autoHidden:YES];
        [self finishRefreshingControl];
        return;
    }
    
    [self requestListWithDataParams:[self getDataParams:isNext]];
    self.isRequesting=YES;
}
-(NSString *)getLastVideosID
{
    id videosID=[self.dataArray lastObject][@"id"];
    if ([videosID isKindOfClass:[NSNumber class]]) {
        return [videosID stringValue];
    } else if ([videosID isKindOfClass:[NSString class]]) {
        return videosID;
    }
    
    return @"";
}
-(NSString *)getLastTime
{
    id videosTime=[self.dataArray lastObject][@"date"];
    if ([videosTime isKindOfClass:[NSNumber class]]) {
        return [videosTime stringValue];
    } else if ([videosTime isKindOfClass:[NSString class]]) {
        return videosTime;
    }
    
    return @"";
}
- (NSDictionary *)getDataParams:(BOOL)isNext
{
    NSDictionary *params = nil;
    if (isNext) {
        params=@{
                 @"last_time":[self getLastTime],
                 @"last_id"  :[self getLastVideosID],
                 @"limit"    : @"10"
                 };
    }else
    {
        params=@{
                 @"last_time":@"",
                 @"last_id"  :@"",
                 @"limit"    :@"10"
                 };
    }
    return params;
}
- (void)requestListWithDataParams:(NSDictionary *)params
{
    __block NSMutableArray *listDataArray=self.dataArray;
    __block UITableView *tableView = self.tableView;
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:[BERApiProxy urlWithAction:[self getMainActionName]] parameters:[BERApiProxy paramsWithDataDic:params action:[self getActionName]] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] integerValue] == 0) {
            [self cleanListArrayIfNeeded];
            
            NSArray *dataArr = dic[@"data"];
            
            if (dataArr.count > 0) {
                [self checkPagnationForReloadMoreWithListCount:dataArr.count]; //查询是否需要结束下拉更多
                
                for (int i = 0; i < dataArr.count; i ++) {
                    [listDataArray addObject:dataArr[i]];
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
        self.isRequesting = NO;
    }];
}
#pragma mark - UITableViewDataSource / Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID=@"cellName";
    static NSString *moreCellIntifier = @"moreCell";
    
    if (self.needReloadMore && indexPath.row == self.dataArray.count) {
        AFLoadingCell *moreCell = [tableView dequeueReusableCellWithIdentifier:moreCellIntifier];
        if (moreCell == nil) {
            moreCell = [[AFLoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moreCellIntifier];
        }
        [moreCell.spinner startAnimating];
        return moreCell;
    }
    BERVideosTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"BERVideosTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    BERVideosModel *model=[[BERVideosModel alloc]init];
    [model setValuesForKeysWithDictionary:self.dataArray[indexPath.row]];
    [cell cellConfigUIWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [NFLAppLogManager sendLogWithEventID:EventID_Videos withKeyName:KN_VideosList andValueName:@"Videos"];
    if (indexPath.row == self.dataArray.count) {
        return; //点击加载更多cell，不操作
    }
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *newdID = [dic stringValueForKey:@"id"];
    
    NSString *shareTitle = [dic stringValueForKey:@"title"];
    
    [BERShareModel sharedInstance].shareTitle = shareTitle;
    [BERShareModel sharedInstance].shareID = newdID;
    

    if ([cell isKindOfClass:[BERVideosTableViewCell class]]) {
        [BERShareModel sharedInstance].shareImg = [[(BERVideosTableViewCell *)cell IconImage] image];
    }
//    [NFLAppLogManager sendLogWithEventID:EventID_News withKeyName:KN_NewsList andValueName:@"News"];
    BERVideosModel *model=[[BERVideosModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    if (model.link) {
        BERVideoPlayerViewController *playerVC=[[BERVideoPlayerViewController alloc]init];
        playerVC.url=[NSURL URLWithString:model.link];
        playerVC.videotitle=model.title;
        playerVC.videoUrl=model.link;
        playerVC.videoiconUrl=model.pic;
        [self.navigationController pushViewController:playerVC animated:YES];
    }else
    {
        UIAlertView *allert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"抱歉！你所搜索的视频不存在！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [allert show];
    }

}


@end
