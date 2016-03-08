//
//  BERSettingsViewController.m
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERSettingsViewController.h"
#import "BERSettingTableViewCell.h"
#import "BERLoginTableViewCell.h"
#import "BERLoginViewController.h"
#import "BERRegisterViewController.h"
#import "BERUserManger.h"
#import "BERHeadFile.h"
#define SetUpCellHeight 45

@interface BERSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) UIButton  * logOutBtn;

@end

@implementation BERSettingsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.listTableView reloadData];
    if ([BERUserManger shareMangerUserInfo].isLogin) {
        self.logOutBtn.hidden = NO;
    }else{
        self.logOutBtn.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self drawMainTabItem];
    [self drawTitle:@"设置"];
    
    [self initModel];
    [self initDisplay];
    
    [self creatLogOutBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    
    DLog(@"dealloc BERSetupListViewController");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)creatLogOutBtn{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.listTableView.frame.size.width, 60)];
    bgView.backgroundColor = [UIColor clearColor];
    UIButton * logOutBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, bgView.frame.size.width - 20, 40) RedBackGroundColorAndTitle:@"退出"];
    [bgView addSubview:logOutBtn];
    [logOutBtn addTarget:self action:@selector(userLogoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.logOutBtn = logOutBtn;
    self.listTableView.tableFooterView = bgView;
    
}

#pragma mark - Private Method

- (void)initModel {

    self.titleArray = [NSArray arrayWithObjects:@"清除缓存", @"版本",@"消息通知", nil];
}

- (void)initDisplay {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WindowWidth, WindowHeight - NAV_BAR_H - STATUS_BAR_H) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableView = tableView;
    [self.view addSubview:tableView];
}

- (CGFloat)cachefileSize{
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSUInteger cachesize = [cache getSize];
    NSString *stringInt = [NSString stringWithFormat:@"%lu",(unsigned long)cachesize];
    return [stringInt floatValue]/1024/1024;
}

#pragma mark - UITableViewDataSource / UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1  ;
    }else if(section == 1){
        return self.titleArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 120  ;
    }else if(indexPath.section == 1){
        if (indexPath.row==2) {
            return 65.0f;
        }
        return SetUpCellHeight;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cell";
    static NSString *cellLogin = @"loginCell";
    
    if (indexPath.section == 0) {
        BERLoginTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellLogin   ];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BERLoginTableViewCell" owner:self options:nil] lastObject];
        }
        [cell configCell];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    UIView *line = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellStr];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, SetUpCellHeight - 0.5, WindowWidth, 0.5)];
        line.backgroundColor = [UIColor colorWithHex:0xeeeeee alpha:1];
        line.tag = 100001;
        [cell.contentView addSubview:line];
        
    } else {
        line = (UIView *)[self.view viewWithTag:100001];
    }
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor colorWithHex:0x999999 alpha:1];
    
    if (indexPath.row == 0) {
        CGFloat cachefileSize = [self cachefileSize];
        
        if(cachefileSize<1.0){
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1f KB",self.cachefileSize*1000];
        }else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2f MB", self.cachefileSize];
        }
    } else if (indexPath.row == 1) {
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"v%@", appVersion];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    if (indexPath.row==2) {
        BERSettingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"BERSettingTableViewCell" owner:self options:nil] lastObject];
        }
        line = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 0.5, WindowWidth, 0.5)];
        line.backgroundColor = [UIColor colorWithHex:0xeeeeee alpha:1];
        line.tag = 100001;
        [cell.contentView addSubview:line];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        BOOL rec=[self isAllowedNotification];
        if (rec) {
            cell.stateLabel.text=@"已开启";
        }else
        {
            cell.stateLabel.text=@"已关闭";
        }
        return cell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - 检测是否开启推送服务
-(BOOL)isAllowedNotification
{
    if ([self isSystemVersioniOS8]) {// system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    } else {//iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }
    
    return NO;
}
-(BOOL)isSystemVersioniOS8
{
    UIDevice *device = [UIDevice currentDevice];
    float sysVersion;
    sysVersion = [device.systemVersion floatValue];
    if (sysVersion >= 8.0f) {
        return YES;
    }
    return NO;
}
#pragma mark - 清理缓存
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                [self.view showInfo:@"正在清理中..." activity:YES];
                __weak __typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[SDImageCache sharedImageCache]clearMemory];
                    [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"缓存已清除" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                        [av show];
                        
                        [weakSelf.view hideLoadWithAnimated:NO];
                        [weakSelf.listTableView reloadData];
                    }];
                });
                
            }
                break;
                
            default:
                break;
        }
    }
    
}
- (void)presentRegisterViewController{
    BERRegisterViewController * vc = [[BERRegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)presentLoginViewController{
    BERLoginViewController * vc = [[BERLoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)userLogoutBtnClick{
    [[BERUserManger shareMangerUserInfo] userLogOut];
    
    [self.listTableView reloadData];
}
@end
