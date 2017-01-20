//
//  TagNewsListViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 2016/10/26.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "TagNewsListViewController.h"
#import "BERNewsWordsCell.h"
#import "SearchResultModel.h"
#import "AFLoadingCell.h"
#import "BERNewsDetailViewController.h"
@interface TagNewsListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray<SearchResultModel *> * dataArray;
@property (nonatomic, assign) BOOL needMoreData;
@end

@implementation TagNewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawTitle:@"新闻"];
    [self drawBackButton];
    [self creatUI];
    [self loadRequesr];
    
}
- (void)creatUI{
    self.dataArray = [[NSMutableArray alloc]init];
    self.tabview = [Factory creatTabbleViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH - 64) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.needMoreData) {
        return self.dataArray.count+1;
    }
    return self.dataArray.count;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataArray.count && self.needMoreData) {
        return 50;
    }
     return (112+24+22)/2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataArray.count) {
        static NSString * loadCell = @"AFLoadingCell";
        AFLoadingCell * cell = [tableView dequeueReusableCellWithIdentifier:loadCell];
        if (cell == nil) {
            cell = [[AFLoadingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadCell];
        }
        [cell.spinner startAnimating];
        return cell;
    }
    SearchResultModel * model = self.dataArray[indexPath.row];
    if (model.cont_type.intValue == 1) {
        NSString * searchCellid = @"newsCell";
        BERNewsWordsCell * cell = [tableView dequeueReusableCellWithIdentifier:searchCellid];
        if (cell == nil) {
            cell = [[BERNewsWordsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCellid];
        }
        [cell updateWithModel:model];
        [cell showCellLineWithHeight:(112+24+22)/2];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self.tabview cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[AFLoadingCell class]]) {
        return;
    }
    SearchResultModel * model = self.dataArray[indexPath.row];
    [BERShareModel sharedInstance].shareTitle = model.title;
    [BERShareModel sharedInstance].shareID = [NSString stringWithFormat:@"%@",model.id];
    UIImageView *imgView = [[UIImageView alloc] init];
    __block UIImageView *coverImg = imgView;
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BER_IMAGE_HOST, model.pic]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        coverImg.image = image;
        [BERShareModel sharedInstance].shareImg = coverImg.image;
    }];
    if ([model.cont_type intValue] == 1) {
        BERNewsDetailViewController * vc = [[BERNewsDetailViewController alloc]init];
        vc.news_id = [NSString stringWithFormat:@"%@",model.id];
        vc.isPictureType = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)loadRequesr{
    [self.view showLoadWithAnimated:YES];
    NSString * date = @"";
    if (self.dataArray.count>0) {
        date = self.dataArray.lastObject.date;
    }
    NSDictionary * params = @{
                              @"tag_id":self.tag_id,
                              @"limit":@"10",
                              @"last_time": date
                              };
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    __weak TagNewsListViewController * weakSelf = self;
    [manager GET:[BERApiProxy urlWithAction:[self getMainActionName]] parameters:[BERApiProxy paramsWithDataDic:params action:[self getActionName]] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] integerValue] == 0) {
            NSArray *dataArr = dic[@"data"];
            if (dataArr.count > 0) {
                for (int i = 0; i < dataArr.count; i ++) {
                    NSDictionary * dic = dataArr[i];
                    SearchResultModel * model = [[SearchResultModel alloc]initWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
            }
            if (dataArr.count == 10) {
                self.needMoreData = YES;
            }else{
                self.needMoreData = NO;
            }
        }
        [weakSelf.tabview reloadData];
        [weakSelf.view hideLoadWithAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.view hideLoadWithAnimated:YES];
    }];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!self.needMoreData) {
        return;
    }
    
    if (scrollView == self.tabview) {
        if (scrollView.contentOffset.y + 50 >= scrollView.contentSize.height - scrollView.frame.size.height) {
            [self loadRequesr];
        }
    }
}

-(NSString *)getActionName
{
    return @"get_tag_list";
}
-(NSString *)getMainActionName
{
    return @"news";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
