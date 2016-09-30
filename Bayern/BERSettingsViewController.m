//
//  BERSettingsViewController.m
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERSettingsViewController.h"
#import "BERSettingTableViewCell.h"
#import "BERHeadFile.h"
#import "ChangePasswordVC.h"
#define SetUpCellHeight 45

@interface BERSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UITableView *listTableView;

@end

@implementation BERSettingsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawMainTabItem];
    [self drawTitle:@"设置"];
    
    [self initModel];
    [self initDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    
    DLog(@"dealloc BERSetupListViewController");
}


#pragma mark - Private Method

- (void)initModel {

    self.titleArray = [NSArray arrayWithObjects:@"修改密码",@"清除缓存", @"版本",@"消息通知", nil];
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
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if (indexPath.row==3) {
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
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cell";
    
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
    
    if (indexPath.row == 1) {
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0,0, WindowWidth, 0.5)];
        line.backgroundColor = [UIColor colorWithHex:0xeeeeee alpha:1];
        [cell.contentView addSubview:line];
        
        CGFloat cachefileSize = [self cachefileSize];
        
        if(cachefileSize<1.0){
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1f KB",self.cachefileSize*1000];
        }else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2f MB", self.cachefileSize];
        }
    } else if (indexPath.row == 2) {
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"v%@", appVersion];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    if (indexPath.row==3) {
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
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                [self.navigationController pushViewController:[ChangePasswordVC new] animated:YES];
            }
                break;
            case 1:
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
@end
