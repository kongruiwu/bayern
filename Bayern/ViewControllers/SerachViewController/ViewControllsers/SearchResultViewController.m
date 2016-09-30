//
//  SearchResultViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/26.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SeachBar.h"
#import "SearchResultModel.h"
#import "BERNewsWordsCell.h"
#import "BERVideosTableViewCell.h"
#import "BERNewsPicCell.h"
#import "SearchInfoModel.h"
#import "BERNewsPictureViewController.h"
#import "BERNewsDetailViewController.h"
#import "BERVideoPlayerViewController.h"

#import "AFLoadingCell.h"
@interface SearchResultViewController()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) UITableView * cateTab;//搜索种类所在tab
@property (nonatomic, strong) SeachBar * searchView;
@property (nonatomic, strong) NSMutableArray * resultArray;
@property (nonatomic, strong) SearchInfoModel * infoModel;
@property (nonatomic, strong) NSMutableArray * cateArray;

@property (nonatomic, assign) BOOL needMoreData;

@end
@implementation SearchResultViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setFristValue];
    [self creatUI];
    [self searchRequest];
}
- (void)setFristValue{
    self.needMoreData = NO;
    self.cateArray = [NSMutableArray new];
    NSArray * types = @[@"news",@"video",@"album"];
    NSArray * names = @[@"新闻",@"视频",@"图集"];
    NSArray * images = @[@"search_news",@"search_videos",@"search_fixtures"];
    NSArray * selects = @[@0,@0,@0];
    for (int i = 0; i<names.count; i++) {
        SearchCateModel * model = [[SearchCateModel alloc]init];
        model.name = names[i];
        model.imageName = images[i];
        model.type = types[i];
        model.isSelect = [selects[i] boolValue];
        if ([model.name isEqualToString:self.searchTypeModel.name]) {
            model.isSelect = YES;
        }
        [self.cateArray addObject:model];
    }
}
- (void)creatUI{
    
    self.resultArray = [NSMutableArray new];
    self.infoModel = [[SearchInfoModel alloc]init];
    self.infoModel.search_count = @0;
    self.cateTab = [Factory creatTabbleViewWithFrame:CGRectMake(Anno750(30), 0, Anno750(170), 0) style:UITableViewStylePlain];
    self.cateTab.scrollEnabled = NO;
    self.cateTab.delegate = self;
    self.cateTab.dataSource = self;
    [self.view addSubview:self.cateTab];
    
    self.searchView = [[SeachBar alloc]init];
    [self.searchView.cateButton setTitle:self.searchTypeModel.name forState:UIControlStateNormal];
    self.searchView.frame = CGRectMake(0, 0, Anno750(600), Anno750(60));
    self.searchView.searchTF.returnKeyType = UIReturnKeySearch;
    self.searchView.searchTF.delegate = self;
    self.searchView.searchTF.text = self.searchWord;
    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:self.searchView];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    [self.searchView.cateButton  addTarget:self action:@selector(showCateTab) forControlEvents:UIControlEventTouchUpInside];
    self.backType = SelectorBackTypePoptoRoot;
    UIBarButtonItem * rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    self.tabview = [Factory creatTabbleViewWithFrame:CGRectMake(0, 0,SCREENWIDTH,SCREENHEIGH - 64) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    [self.view bringSubviewToFront:self.cateTab];

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.tabview) {
        return Anno750(80);
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.tabview) {
        UIView * headerView = [Factory creatViewWithColor:COLOR_BACKGROUND];
        headerView.frame = CGRectMake(0, 0, SCREENWIDTH, Anno750(80));
        UILabel * headLabel = [Factory creatLabelWithTitle:[NSString stringWithFormat:@"为您找到相关结果%@条",self.infoModel.search_count]
                                                 textColor:COLOR_CONTENT_GRAY_6
                                                  textFont:font750(30) textAlignment:NSTextAlignmentLeft];
        [headerView addSubview:headLabel];
        [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(Anno750(20)));
            make.centerY.equalTo(@0);
        }];
        return headerView;
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.cateTab) {
        return self.cateArray.count;
    }
    if (self.needMoreData) {
        return self.resultArray.count+1;
    }
    return self.resultArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.cateTab) {
        return Anno750(60);
    }
    if (indexPath.row == self.resultArray.count && self.needMoreData) {
        return 50;
    }
    SearchResultModel * model = self.resultArray[indexPath.row];
    if (model.cont_type.intValue == 1) {
        return (112+24+22)/2;
    }else if(model.cont_type.intValue == 9){
        return 80;
    }else{
        return BER_NEWS_PIC_CELL_HEIGHT;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.cateTab) {
        static NSString * cellid = @"SearchCateTableViewCell";
        SearchCateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell == nil) {
            cell = [[SearchCateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        SearchCateModel * model = self.cateArray[indexPath.row];
        [cell updateWithSearchCateModel:model];
        return cell;
    }else{
        if (indexPath.row == self.resultArray.count) {
            static NSString * loadCell = @"AFLoadingCell";
            AFLoadingCell * cell = [tableView dequeueReusableCellWithIdentifier:loadCell];
            if (cell == nil) {
                cell = [[AFLoadingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadCell];
            }
            [cell.spinner startAnimating];
            return cell;
        }
        SearchResultModel * model = self.resultArray[indexPath.row];
        if (model.cont_type.intValue == 1) {
            NSString * searchCellid = @"newsCell";
            BERNewsWordsCell * cell = [tableView dequeueReusableCellWithIdentifier:searchCellid];
            if (cell == nil) {
                cell = [[BERNewsWordsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCellid];
            }
            [cell updateWithModel:model];
            [cell showCellLineWithHeight:(112+24+22)/2];
            return cell;
        }else if(model.cont_type.intValue == 9){
            NSString * searchCellid = @"videosCell";
            BERVideosTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:searchCellid];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle] loadNibNamed:@"BERVideosTableViewCell" owner:self options:nil] lastObject];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell updateWithModel:model];
            return cell;
        }else{
            NSString * searchCellid = @"PictureCell";
            BERNewsPicCell * cell = [tableView dequeueReusableCellWithIdentifier:searchCellid];
            if (cell == nil) {
                cell = [[BERNewsPicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCellid];
            }
            [cell updateWithModel:model];
            [cell showCellLineWithHeight:BER_NEWS_PIC_CELL_HEIGHT];
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.cateTab) {
        for (int i = 0; i<self.cateArray.count; i++) {
            SearchCateModel * model = self.cateArray[i];
            if (i == indexPath.row) {
                model.isSelect = YES;
                self.searchTypeModel = model;
                [self.searchView.cateButton setTitle:model.name forState:UIControlStateNormal];
            }else{
                model.isSelect = NO;
            }
        }
        [self showCateList:NO];
    }else{
        UITableViewCell * cell = [self.tabview cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[AFLoadingCell class]]) {
            
            return;
        }
        SearchResultModel * model = self.resultArray[indexPath.row];
        
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
        }else if([model.cont_type intValue] == 2){
            BERNewsPictureViewController * vc = [[BERNewsPictureViewController alloc]init];
            vc.news_id = [NSString stringWithFormat:@"%@",model.id];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if([model.cont_type intValue] == 9){
            BERVideoPlayerViewController * vc = [[BERVideoPlayerViewController alloc]init];
            vc.videoUrl = model.link;
            vc.url = [NSURL URLWithString:model.link];
            vc.videotitle = model.title;
            vc.videoiconUrl = model.pic;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!self.needMoreData) {
        return;
    }
    
    if (scrollView == self.tabview) {
        if (scrollView.contentOffset.y + 50 >= scrollView.contentSize.height - scrollView.frame.size.height) {
            [self loadMoreResulutData];
        }
    }
}

- (void)showCateTab{
    [self showCateList:YES];
}
- (void)showCateList:(BOOL)isShow{
    __weak SearchResultViewController * weakSelf = self;
    float height = Anno750(180);
    if (!isShow) {
        height = 0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.cateTab.frame = CGRectMake(Anno750(30), 0, Anno750(170), height);
    }];
    if (!isShow) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.cateTab reloadData];
        });
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length>0) {
        [self addSearchWord:textField.text];
        [self searchRequest];
        [self.searchView.searchTF resignFirstResponder];
    }
    return YES;
}
- (BOOL)saveArrayToDocument:(NSMutableArray *)arr{
    NSArray * saveArray = [NSArray arrayWithArray:arr];
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
    NSString * newFielPath = [documentsPath stringByAppendingPathComponent:@"data.plist"];
    NSFileManager * manager = [NSFileManager defaultManager];
    [manager createFileAtPath:newFielPath contents:nil attributes:nil];
    
    BOOL isSuccess = [saveArray writeToFile:newFielPath atomically:YES];
    return isSuccess;
}
- (void)addSearchWord:(NSString *)string{
    for (int i = 0; i<self.hisArray.count; i++) {
        NSString * hisString = self.hisArray[i];
        if ([hisString isEqualToString:string]) {
            [self.hisArray removeObjectAtIndex:i];
        }
    }
    if (self.hisArray.count>9) {
        [self.hisArray removeLastObject];
    }
    [self.hisArray insertObject:string atIndex:0];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self saveArrayToDocument:self.hisArray];
    });
}
- (void)loadMoreResulutData{
    [self.view showLoadWithAnimated:YES];
    SearchResultModel * model = [self.resultArray lastObject];
    NSDictionary * params = @{
                              @"search_word":self.searchView.searchTF.text,
                              @"search_type":self.searchTypeModel.type,
                              @"last_id":[NSString stringWithFormat:@"%@",model.id]
                              };
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    __weak SearchResultViewController * weakSelf = self;
    [manager GET:[BERApiProxy urlWithAction:[self getMainActionName]] parameters:[BERApiProxy paramsWithDataDic:params action:[self getActionName]] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] integerValue] == 0) {
            NSArray *dataArr = dic[@"data"];
            if (dataArr.count > 0) {
                for (int i = 0; i < dataArr.count; i ++) {
                    NSDictionary * dic = dataArr[i];
                    SearchResultModel * model = [[SearchResultModel alloc]initWithDictionary:dic];
                    [self.resultArray addObject:model];
                }
            }
        }
        if (self.resultArray.count<self.infoModel.search_count.intValue) {
            self.needMoreData = YES;
        }else{
            self.needMoreData = NO;
        }
        [weakSelf.tabview reloadData];
        [weakSelf.view hideLoadWithAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.view hideLoadWithAnimated:YES];
    }];

}
- (void)searchRequest{
    [self.view showLoadWithAnimated:YES];
    [self.resultArray removeAllObjects];
    NSDictionary * params = @{@"search_word":self.searchView.searchTF.text,
                              @"search_type":self.searchTypeModel.type
                              };
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    __weak SearchResultViewController * weakSelf = self;
    [manager GET:[BERApiProxy urlWithAction:[self getMainActionName]] parameters:[BERApiProxy paramsWithDataDic:params action:[self getActionName]] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] integerValue] == 0) {
            
            NSDictionary * infoDic = dic[@"info"];
            self.infoModel = [[SearchInfoModel alloc]initWithDictionary:infoDic];
            
            NSArray *dataArr = dic[@"data"];
            if (dataArr.count > 0) {
                for (int i = 0; i < dataArr.count; i ++) {
                    NSDictionary * dic = dataArr[i];
                    SearchResultModel * model = [[SearchResultModel alloc]initWithDictionary:dic];
                    [self.resultArray addObject:model];
                }
            }
        }
        if (self.resultArray.count<self.infoModel.search_count.intValue) {
            self.needMoreData = YES;
        }else{
            self.needMoreData = NO;
        }
        [weakSelf.tabview reloadData];
        [weakSelf.view hideLoadWithAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.view hideLoadWithAnimated:YES];
    }];
    
}
-(NSString *)getActionName
{
    return @"search";
}
-(NSString *)getMainActionName
{
    return @"other";
}

@end
