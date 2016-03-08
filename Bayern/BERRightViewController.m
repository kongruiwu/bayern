//
//  BERRightViewController.m
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERRightViewController.h"
#import "BERRightTableViewCell.h"
#import "BERNewsPictureViewController.h"

@interface BERRightViewController () <UITableViewDataSource, UITableViewDelegate, BERRightTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) UITableView *listTableView;

@end

@implementation BERRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    self.contentArray = [NSMutableArray array];
    
    [self.view addSubview:self.listTableView];
    
    CGFloat originX = (1- [BERMainCenter sharedInstance].sliderPercentage) * WindowWidth;
    
    //set header
    CGFloat headerH = STATUS_BAR_H + NAV_BAR_H;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(originX, 0, self.sliderWidth, headerH)];
    header.backgroundColor = [UIColor blackColor];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(originX, (headerH - 20)/2+3, self.sliderWidth, 20)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.text = @"比赛中心";
    titleLb.font = [UIFont systemFontOfSize:18];
    titleLb.textColor = [UIColor colorWithHex:0xe4003a alpha:1];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [header addSubview:titleLb];
    
    [self.listTableView setTableHeaderView:header];
    
    [self request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Request Method

- (void)request {
    __block NSMutableArray *listDataArray = self.contentArray;
    __block UITableView *tableView = self.listTableView;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BERApiProxy urlWithAction:@"match"] parameters:[BERApiProxy paramsWithDataDic:@{} action:@"lastSchedules"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
       // DLog(@"~~~~~lastSchedules response [%@]", responseObject);
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] integerValue] == 0) {
            
            NSArray *dataArr = dic[@"data"];
            
            if (dataArr.count > 0) {
                
                for (int i = 0; i < dataArr.count; i ++) {
                    [listDataArray addObject:dataArr[i]];
                }
                
            } else {
                
            }
            
            [tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
}

#pragma mark - UITableViewDataSource / UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RightCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cell";
    
    BERRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[BERRightTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellStr];
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
    }
    
    cell.index = indexPath.row;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCell:self.contentArray[indexPath.row]];
    
    if (indexPath.row < self.contentArray.count -1) {
        [cell showCellLineWithHeight:RightCellHeight color:[UIColor colorWithHex:0x999999 alpha:1]];
    }
    
    return cell;
}

#pragma mark - 

- (void)BERRightTableViewCellGameButtonClick:(NSInteger)index {
    NSDictionary *dic = self.contentArray[index];
    NSString *newsLink = [dic stringValueForKey:@"news_link"];
    
    NSString *shareTitle = [dic stringValueForKey:@"league_title"];
    if (shareTitle.length == 0 || shareTitle == nil) {
        shareTitle = @"";
    }
    [BERShareModel sharedInstance].shareTitle = shareTitle;
    [BERShareModel sharedInstance].shareID = newsLink;
    
    [[AppDelegate sharedInstance] pushNewsWithNewsLink:newsLink];
}
-(void)BERRightTableViewCellPicButtonClick:(NSInteger)index
{
    NSDictionary *dic = self.contentArray[index];
    NSString *picLink = [dic stringValueForKey:@"album_link"];
    NSString *shareTitle = [dic stringValueForKey:@"league_title"];
    [BERShareModel sharedInstance].shareTitle=shareTitle;
    [BERShareModel sharedInstance].shareID=picLink;
    [BERShareModel sharedInstance].shareUrl=[[BERShareModel sharedInstance]getShareURL:NO];
    [[AppDelegate sharedInstance] pushPicWithPicLink:picLink];
}
#pragma mark - Getter Method

- (UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WindowWidth, WindowHeight) style:UITableViewStylePlain];
        _listTableView.backgroundColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _listTableView;
}

@end
