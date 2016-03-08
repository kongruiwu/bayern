//
//  BERTeamViewController.m
//  Bayern
//
//  Created by wusicong on 15/6/18.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERTeamViewController.h"
#import "BERDetailTeamViewController.h"

@interface BERTeamViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BERTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self drawMainTabItem];
    [self drawTitle:@"球队"];

    [self initModel];
    
    [self doRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DLog(@"dealloc BERTeamViewController");
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
    self.navScrollTitleArray = [NSMutableArray arrayWithObjects:@"门将",@"后卫",@"中场",@"前锋",@"教练", nil]; //暂时写死
    self.dataArray = [NSMutableArray array];
}

- (void)setDisplay {
    [self setNavigationBar];
    
    //容错
    if (self.navScrollTitleArray.count != self.dataArray.count) {
        [self.view showInfo:@"数据错误" autoHidden:YES];
        return;
    }
    
    for (NSInteger i = 0; i < self.dataArray.count; i ++) {
        BERTeamListViewController *tl = [[BERTeamListViewController alloc] init];
        tl.delegate=self;
        tl.listArr = self.dataArray[i];
        tl.teamPosition = self.navScrollTitleArray[i];
        [self.contentControllerArray addObject:tl];
    }
    
    [self addContentControllers];
}
#pragma mark - TEAMLIST代理 页面跳转
-(void)pushtoTeamerViewWithID:(NSString *)teamerid andIsTeamer:(BOOL)rec
{
    BERDetailTeamViewController *vc=[[BERDetailTeamViewController alloc]init];
    vc.isTeamer=rec;
    vc.teamerID=teamerid;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Request Method

- (void)doRequest {
    if (![BERNetworkManager isNetworkOkay]) {
        [self.view showInfo:NetworkErrorTips autoHidden:YES];
        return;
    }
    
    [self.view showLoadWithAnimated:YES];
    [self requestDataParams:@{}];
}

- (void)requestDataParams:(NSDictionary *)params {
    
    __block NSMutableArray *listDataArray = self.dataArray;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BERApiProxy urlWithAction:@"team"] parameters:[BERApiProxy paramsWithDataDic:params action:@"get_list"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        DLog(@"~~~~~team response [%@]", responseObject);
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] integerValue] == 0) {
            
            NSDictionary *teamDataDic = dic[@"data"];
            
            if (teamDataDic.count > 0) {
                for (NSInteger i = 0; i < teamDataDic.count; i ++) {
                    NSString *key = [NSString stringWithFormat:@"%ld",i+1];
                    
                    [listDataArray addObject:teamDataDic[key]];
                }
                
                [self setDisplay];
            }
        }
        
        [self.view hideLoadWithAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        [self.view hideLoadWithAnimated:YES];
    }];
}

@end
