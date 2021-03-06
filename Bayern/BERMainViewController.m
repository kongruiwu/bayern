//
//  BERMainViewController.m
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERMainViewController.h"
#import "BERNavigationController.h"


#import "BERRightViewController.h"

#import "BERHomeListViewController.h"
#import "BERNewsListViewController.h"
#import "BERSettingsViewController.h"

#import "BERShopViewController.h"
#import "BERTeamViewController.h"

#import "BERFixturesViewController.h"
#import "BERVideoListViewController.h"
#import "BERStandingsViewController.h"
#import "BERClubViewController.h"

#import "HomePageViewController.h"
#import "LoginViewController.h"
#import "UserCenterViewController.h"

@interface BERMainViewController ()


@property (nonatomic, strong) BERRightViewController *rightVC;

@property (nonatomic, strong) UINavigationController *centerVC;

@property NSInteger lastIndex;
@property BOOL inited; //yes表示非首次加载，no为首次加载

@end

@implementation BERMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.leftVC = [[BERLeftViewController alloc] init];
    
    self.rightVC = [[BERRightViewController alloc] init];
    
    self.leftPanel = self.leftVC;
    self.rightPanel = self.rightVC;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //设置滑动距离
    CGFloat sliderPercentage = [[BERMainCenter sharedInstance] sliderPercentage];
    CGFloat rightSlider = (float)650/750;
    [self setLeftGapPercentage:sliderPercentage];
    [self setRightGapPercentage:rightSlider];
    
    self.bouncePercentage = 0.1;
    self.bounceOnCenterPanelChange = NO;
    
    self.lastIndex = -1;
    [[AppDelegate sharedInstance] toggleLeftDrawer:self animated:NO];
    [[AppDelegate sharedInstance] toggleRightDrawer:self animated:NO];
    [self setCenterVCWithIndex:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([BERMainCenter sharedInstance].shouldAppRotateForRootVC) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Public Method

- (void)setCenterVCWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            [NFLAppLogManager sendLogWithEventID:EventID_Topbar withKeyName:KN_MainNav andValueName:@"TabUserInfo"];
            break;
        case 1:
            [NFLAppLogManager sendLogWithEventID:EventID_Topbar withKeyName:KN_MainNav andValueName:@"TabIndex"];
            break;
        case 2:
            [NFLAppLogManager sendLogWithEventID:EventID_Topbar withKeyName:KN_MainNav andValueName:@"TabNews"];
            break;
        case 3:
            [NFLAppLogManager sendLogWithEventID:EventID_Topbar withKeyName:KN_MainNav andValueName:@"TabPhotos"];
            break;
        case 4:
            [NFLAppLogManager sendLogWithEventID:EventID_Topbar withKeyName:KN_MainNav andValueName:@"TabVideos"];
            break;
        case 5:
            [NFLAppLogManager sendLogWithEventID:EventID_Topbar withKeyName:KN_MainNav andValueName:@"TabFixtures"];
        case 6:
            [NFLAppLogManager sendLogWithEventID:EventID_Topbar withKeyName:KN_MainNav andValueName:@"TabStandings"];
        case 7:
            [NFLAppLogManager sendLogWithEventID:EventID_Topbar withKeyName:KN_MainNav andValueName:@"TabTeam"];
        case 8:
            [NFLAppLogManager sendLogWithEventID:EventID_Topbar withKeyName:KN_MainNav andValueName:@"TabClub"];
        case 9:
            [NFLAppLogManager sendLogWithEventID:EventID_Topbar withKeyName:KN_MainNav andValueName:@"TabShop"];
            break;
        case 10:
            [NFLAppLogManager sendLogWithEventID:EventID_Topbar withKeyName:KN_MainNav andValueName:@"TabSettings"];
            break;
        default:
            break;
    }
    
    if (self.lastIndex == index) {
        self.centerPanel = self.centerVC;
        [[AppDelegate sharedInstance] toggleLeftDrawer:self animated:YES];
        return;
    }
    
    switch (index) {
        case 0:
        {
            UIViewController * ml;
            NSNumber * userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
            if (userID && userID.intValue>0) {
                ml = [[UserCenterViewController alloc]init];
            }else{
                ml = [[LoginViewController alloc]init];
            }
//            UserCenterViewController *
//            LoginViewController *
            BERNavigationController *nav = [[BERNavigationController alloc] initWithRootViewController:ml];
            self.centerVC = nav;
        }
            break;

        case 1:
        {
            HomePageViewController *ml = [[HomePageViewController alloc] init];
            BERNavigationController *nav = [[BERNavigationController alloc] initWithRootViewController:ml];
            self.centerVC = nav;
        }
            break;
        case 2:
        {
            BERNewsListViewController *ml = [[BERNewsListViewController alloc] init];
            ml.newsListType = NewsListTypeNews;
            BERNavigationController *nav = [[BERNavigationController alloc] initWithRootViewController:ml];
            self.centerVC = nav;
        }
            break;
        case 3:
        {
            BERNewsListViewController *ml = [[BERNewsListViewController alloc] init];
            ml.newsListType = NewsListTypePic;
            BERNavigationController *nav = [[BERNavigationController alloc] initWithRootViewController:ml];
            self.centerVC = nav;
        }
            break;
        case 4:
        {
            BERVideoListViewController *ml = [[BERVideoListViewController alloc] init];
            BERNavigationController *nav = [[BERNavigationController alloc] initWithRootViewController:ml];
            self.centerVC = nav;
        }
            break;
        case 5:
        {
            BERFixturesViewController *ml = [[BERFixturesViewController alloc] init];
            BERNavigationController *nav = [[BERNavigationController alloc] initWithRootViewController:ml];
            self.centerVC = nav;
        }
            break;
        case 6:
        {
            BERStandingsViewController *ml = [[BERStandingsViewController alloc] init];
            BERNavigationController *nav = [[BERNavigationController alloc] initWithRootViewController:ml];
            self.centerVC = nav;
        }
            break;
        case 7:
        {
            BERTeamViewController *ml = [[BERTeamViewController alloc] init];
            BERNavigationController *nav = [[BERNavigationController alloc] initWithRootViewController:ml];
            self.centerVC = nav;
        }
            break;
        case 8:
        {
            BERClubViewController *ml = [[BERClubViewController alloc] init];
            ml.url=@"http://www.fcbayern.cn/club?app=1";
            BERNavigationController *nav = [[BERNavigationController alloc] initWithRootViewController:ml];
            self.centerVC = nav;
        }
            break;
        case 9:
        {
            BERShopViewController *ml = [[BERShopViewController alloc] init];
            BERNavigationController *nav = [[BERNavigationController alloc] initWithRootViewController:ml];
            ml.url = [NSURL URLWithString:@"http://fcb.tmall.hk"];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SHOP"] != nil) {
                NSString * urlStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"SHOP"];
                ml.url = [NSURL URLWithString:urlStr];
            }
            self.centerVC = nav;
        }
            break;
        case 10:
        {
            BERSettingsViewController *ml = [[BERSettingsViewController alloc] init];
            BERNavigationController *nav = [[BERNavigationController alloc] initWithRootViewController:ml];
            self.centerVC = nav;
        }
            break;
        
        default:
            break;
    }
    
    self.centerPanel = self.centerVC;
    if (self.inited) {
        [[AppDelegate sharedInstance] toggleLeftDrawer:self animated:YES];
    } else {
        self.inited = !self.inited; //首次启动不需要显示或隐藏leftPanel，其他点击情况下需要
    }
    
    self.lastIndex = index;
}

@end
