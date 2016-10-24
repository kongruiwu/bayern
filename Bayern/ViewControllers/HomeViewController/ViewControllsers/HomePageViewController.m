//
//  HomePageViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/13.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "HomePageViewController.h"
#import "AutoScrollView.h"
#import "TeamerTableViewCell.h"
#import "AdTableViewCell.h"
#import "ScoreTableViewCell.h"
#import "HomeBannerModel.h"
#import "HomeAdmoodel.h"
#import "HomePicModel.h"
#import "HomeTeamerModel.h"
#import "HomeGameModel.h"
#import "BERNewsDetailViewController.h"
#import "BERShopViewController.h"
#import "BERVideoPlayerViewController.h"
#import "BERNewsPictureViewController.h"
#import "BERDetailTeamViewController.h"
#import "YTImageBrowerController.h"
#import "CompleteMessageView.h"
#import "HomeVideoFootView.h"
#import "HomeScroeHeadView.h"
#import "UserCenterViewController.h"
@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource,HomeVideoFootViewDelegate,TeamerTableViewCellDelegate,HomeScoreHeadViewDelegate>
@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) AutoScrollView * bannerView;
@property (nonatomic, strong) NSMutableArray<HomeBannerModel *> * banners;
@property (nonatomic, strong) HomeAdmoodel * adModel;
@property (nonatomic, strong) NSMutableArray<HomePicModel *> * videos;
@property (nonatomic, strong) NSMutableArray<HomeTeamerModel *> * teamers;
@property (nonatomic, strong) NSMutableArray<HomeGameModel *> * games;
@property (nonatomic, strong) CompleteMessageView * messageView;
@property (nonatomic, strong) HomeVideoFootView * foot;

@property (nonatomic, assign) NSInteger index;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawTitle:@"首页"];
    [self setBackGroundImage];
    [self drawMainTabItemWithSearchItem];
    [self creatUI];
    [self creatHeadView];
    [self getdata];
    [self showComoleteMessageView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.messageView = [[CompleteMessageView alloc]init];
    [self.navigationController.view addSubview:self.messageView];
    self.messageView.frame = CGRectMake(0, SCREENHEIGH, SCREENWIDTH, SCREENHEIGH);
    [self.messageView.completeButton addTarget:self action:@selector(pushToUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.messageView.cannceButton addTarget:self action:@selector(dismissMessageView) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.messageView removeFromSuperview];
}
- (void)creatUI{
    self.tabview = [Factory creatTabbleViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH - 64) style:UITableViewStyleGrouped];
    self.tabview.backgroundColor = [UIColor clearColor];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];

    
}
- (void)showComoleteMessageView{
    NSNumber * userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    if (userID && userID.intValue>0) {
        if ([UserInfo defaultInfo].isTimeOver && ![UserInfo defaultInfo].isCompeletInfo) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.3 animations:^{
                    self.messageView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH);
                }];
            });
        }
    }
}
- (void)creatHeadView{
    
    self.bannerView = [[AutoScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH * 540 /960)];
    self.tabview.tableHeaderView = self.bannerView;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bannerClick)];
    [self.bannerView addGestureRecognizer:tap];
}
- (void)bannerClick{
    [NFLAppLogManager sendLogWithEventID:EventID_Index withKeyName:KN_List andValueName:@"News"];
    
    int index = (int)self.bannerView.pageControl.currentPage;
    HomeBannerModel * model =self.banners[index];
    
    [BERShareModel sharedInstance].shareTitle = model.title;
    [BERShareModel sharedInstance].shareID = [NSString stringWithFormat:@"%@",model.id];
    [BERShareModel sharedInstance].shareImg = [(UIImageView *)self.bannerView.imageViews[index] image];
    
    if ([model.show_type intValue] == 1) {
        BERNewsDetailViewController * vc = [[BERNewsDetailViewController alloc]init];
        vc.news_id = [NSString stringWithFormat:@"%@",model.show_id];
        vc.news_url = model.url;
        vc.isPictureType = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([model.show_type intValue] == 2){
        BERNewsPictureViewController * vc = [[BERNewsPictureViewController alloc]init];
        vc.news_id = [NSString stringWithFormat:@"%@",model.show_id];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([model.show_type intValue] == 3){
        BERVideoPlayerViewController * vc = [[BERVideoPlayerViewController alloc]init];
        vc.videoUrl = model.url;
        vc.url = [NSURL URLWithString:model.url];
        vc.videotitle = model.title;
        vc.videoiconUrl = model.pic;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (void)getdata{
    self.banners = [NSMutableArray new];
    self.videos = [NSMutableArray new];
    self.teamers = [NSMutableArray new];
    self.games = [NSMutableArray new];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BERApiProxy urlWithAction:@"home_data"] parameters:[BERApiProxy paramsWithDataDic:@{} action:@"get_focus_2016"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //轮播图
        NSDictionary * dic = (NSDictionary *)responseObject;
        if (dic[@"code"] && [dic[@"code"] intValue] == 0) {
            NSArray * arr = dic[@"data"];
            for (int i = 0; i<arr.count; i++) {
                HomeBannerModel * model = [[HomeBannerModel alloc]initWithDictionary:arr[i]];
                [self.banners addObject:model];
            }
        }
        NSMutableArray * descs = [NSMutableArray new];
        NSMutableArray * imags = [NSMutableArray new];
        for (int i = 0; i<self.banners.count; i++) {
            [descs addObject:self.banners[i].title];
            [imags addObject:[NSString stringWithFormat:@"%@%@",BER_IMAGE_HOST,self.banners[i].pic]];
        }
        self.bannerView.descs = descs;
        self.bannerView.images = imags;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [manager GET:[BERApiProxy urlWithAction:@"home_data"] parameters:[BERApiProxy paramsWithDataDic:@{} action:@"get_mid_adv"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //广告
        NSDictionary * dic = (NSDictionary *)responseObject;
        if (dic[@"code"] && [dic[@"code"] intValue] == 0) {
            NSArray * arr = dic[@"data"];
            NSDictionary * adDic = arr[0];
            self.adModel = [[HomeAdmoodel alloc]initWithDictionary:adDic];
        }
        [self.tabview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    [manager GET:[BERApiProxy urlWithAction:@"home_data"] parameters:[BERApiProxy paramsWithDataDic:@{} action:@"get_home_album"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //视频
        NSDictionary * dic = (NSDictionary *)responseObject;
        if (dic[@"code"] && [dic[@"code"] intValue] == 0) {
            NSArray * arr = dic[@"data"];
            for (int i = 0; i<arr.count; i++) {
                HomePicModel * model = [[HomePicModel alloc]initWithDictionary:arr[i]];
                [self.videos addObject:model];
            }
        }
        [self.tabview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    [manager GET:[BERApiProxy urlWithAction:@"home_data"] parameters:[BERApiProxy paramsWithDataDic:@{} action:@"get_home_schedule_board"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //赛程
        NSDictionary * dic = (NSDictionary *)responseObject;
        if (dic[@"code"] && [dic[@"code"] intValue] == 0) {
            NSArray * arr = dic[@"data"];
            for (int i = 0; i<arr.count; i++) {
                HomeGameModel * model = [[HomeGameModel alloc]initWithDictionary:arr[i]];
                if (model.show_default) {
                    self.index = i;
                }
                [self.games addObject:model];
            }
        }
        [self.tabview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    [manager GET:[BERApiProxy urlWithAction:@"home_data"] parameters:[BERApiProxy paramsWithDataDic:@{} action:@"get_home_player"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //球员
        NSDictionary * dic = (NSDictionary *)responseObject;
        if (dic[@"code"] && [dic[@"code"] intValue] == 0) {
            NSArray * arr = dic[@"data"];
            for (int i = 0; i<arr.count; i++) {
                HomeTeamerModel * model = [[HomeTeamerModel alloc]initWithDictionary:arr[i]];
                [self.teamers addObject:model];
            }
        }
        [self.tabview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return (SCREENWIDTH - Anno750(60)) * 140 /690;
    }
    return Anno750(200);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * ADcell = @"adcell";
    static NSString * teamCell = @"teamCell";
    if (indexPath.section == 0) {
        AdTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ADcell];
        if (cell == nil) {
            cell = [[AdTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ADcell];
        }
        [cell updateWithImageUrlstring:self.adModel.pic];
        return cell;
    }else if(indexPath.section == 1){
        TeamerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:teamCell];
        if (cell == nil) {
            cell = [[TeamerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:teamCell];
        }
        if (self.teamers.count>1) {
            [cell updateWithArray:@[self.teamers[0],self.teamers[1]]];
        }
        cell.delegate = self;
        return cell;
    }else if(indexPath.section == 2){
        TeamerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:teamCell];
        if (cell == nil) {
            cell = [[TeamerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:teamCell];
        }
        if (self.teamers.count>3) {
            [cell updateWithArray:@[self.teamers[2],self.teamers[3]]];
        }
        cell.delegate = self;
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return Anno750(390);
    }
    return Anno750(20);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return Anno750(400);
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        HomeScroeHeadView * headView = [[HomeScroeHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, Anno750(340))];
        [headView updateScrollViewWithArray:self.games andIndex:self.index];
        headView.delegate = self;
        return headView;
    }
    return nil;
}
- (void)homeGameViewPicButtonClickWithModel:(HomeGameModel *)model{
    NSString *picLink = [NSString stringWithFormat:@"%@",model.album_link];
    NSString *shareTitle = model.league_title;
    [BERShareModel sharedInstance].shareTitle=shareTitle;
    [BERShareModel sharedInstance].shareID=picLink;
    [BERShareModel sharedInstance].shareUrl=[[BERShareModel sharedInstance]getShareURL:NO];
    YTImageBrowerController * vc = [[YTImageBrowerController alloc]init];
    vc.news_id = picLink;
    vc.titleName = shareTitle;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)homeGameViewNewsButtonClickWithModel:(HomeGameModel *)model{
    NSString *newsLink = [NSString stringWithFormat:@"%@",model.news_link];
    
    NSString *shareTitle = model.league_title;
    if (shareTitle.length == 0 || shareTitle == nil) {
        shareTitle = @"";
    }
    [BERShareModel sharedInstance].shareTitle = shareTitle;
    [BERShareModel sharedInstance].shareID = newsLink;
    BERNewsDetailViewController *nv = [[BERNewsDetailViewController alloc] init];
    nv.news_id = newsLink;
    nv.needFetchNewsData = YES;
    [self.navigationController pushViewController:nv animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        self.foot = [[HomeVideoFootView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, Anno750(400))];
        [self.foot updateScrollViewWithVideoArray:self.videos];
        self.foot.delegate = self;
        return self.foot;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        BERShopViewController *sv = [[BERShopViewController alloc] init];
        sv.url = [NSURL URLWithString:self.adModel.url];
        sv.isNormalWebView = YES;
        [self.navigationController pushViewController:sv animated:YES];
    }
}
- (void)HomeVideoSelctWithModel:(HomePicModel *)model{
    [BERShareModel sharedInstance].shareTitle = model.title;
    [BERShareModel sharedInstance].shareID = [NSString stringWithFormat:@"%@",model.show_id];
    if (model.url && ![model isKindOfClass:[NSNull class]]) {
//        BERVideoPlayerViewController * vc = [[BERVideoPlayerViewController alloc]init];
//        vc.videoUrl = model.url;
//        vc.url = [NSURL URLWithString:model.url];
//        vc.videotitle = model.title;
//        vc.videoiconUrl = model.pic;
//        [self.navigationController pushViewController:vc animated:YES];
        YTImageBrowerController * vc = [[YTImageBrowerController alloc]init];
        vc.news_id = [NSString stringWithFormat:@"%@",model.show_id];
        vc.titleName = model.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)teamerClickWithModel:(HomeTeamerModel *)model{
    BERDetailTeamViewController * teamerVC = [[BERDetailTeamViewController alloc]init];
    teamerVC.isTeamer = !model.is_coach;
    teamerVC.teamerID = [NSString stringWithFormat:@"%@",model.player_id];
    [self.navigationController pushViewController:teamerVC animated:YES];
}
- (void)pushToUserInfo{
    UserCenterViewController * vc = [[UserCenterViewController alloc]init];
    vc.isPush = YES;
    NSNumber * currentTime = [NSNumber numberWithLong:time(NULL)];
    [[NSUserDefaults standardUserDefaults] setObject:currentTime forKey:ShowComplete];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[UserInfo defaultInfo] updateShowMessageStatus];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)dismissMessageView{
    NSNumber * currentTime = [NSNumber numberWithLong:time(NULL)];
    [[NSUserDefaults standardUserDefaults] setObject:currentTime forKey:ShowComplete];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[UserInfo defaultInfo] updateShowMessageStatus];
    [UIView animateWithDuration:0.3 animations:^{
        self.messageView.frame = CGRectMake(0, SCREENHEIGH,SCREENWIDTH, SCREENHEIGH);
    }];
}
@end
