//
//  SearchViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/13.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "SearchViewController.h"
#import "SeachBar.h"
#import "SearchCateTableViewCell.h"
#import "HotSearcherTableViewCell.h"
#import "SearchResultViewController.h"
@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,HotSearcherCellDelegate,UITextFieldDelegate>
@property (nonatomic, strong) SeachBar * searchView;
@property (nonatomic, strong) UITableView * cateTab;//搜索种类所在tab
@property (nonatomic, strong) UITableView * searchHisTab;//搜索历史tab
@property (nonatomic, strong) NSMutableArray * cateArray;
@property (nonatomic, strong) NSMutableArray * hisArray;
@property (nonatomic, strong) SearchCateModel * curSearchModel;//search TYPE

@end

@implementation SearchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackGroundImage];
    [self setFristValue];
    [self creatUI];
    
}
- (void)setFristValue{
    self.cateArray = [NSMutableArray new];
    NSArray * arr = [self loadHisArray];
    if (!arr) {
        self.hisArray = [NSMutableArray new];
    }else{
        self.hisArray = [NSMutableArray arrayWithArray:arr];
    }
    
    NSArray * types = @[@"news",@"video",@"album"];
    NSArray * names = @[@"新闻",@"视频",@"图集"];
    NSArray * images = @[@"search_news",@"search_videos",@"search_fixtures"];
    NSArray * selects = @[@1,@0,@0];
    for (int i = 0; i<names.count; i++) {
        SearchCateModel * model = [[SearchCateModel alloc]init];
        model.name = names[i];
        model.imageName = images[i];
        model.type = types[i];
        model.isSelect = [selects[i] boolValue];
        if (i == 0) {
            self.curSearchModel = model;
        }
        [self.cateArray addObject:model];
    }
}
- (void)creatUI{
    self.searchView = [[SeachBar alloc]init];
    self.searchView.frame = CGRectMake(0, 0, Anno750(600), Anno750(60));
    self.searchView.searchTF.returnKeyType = UIReturnKeySearch;
    self.searchView.searchTF.delegate = self;
    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:self.searchView];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    [self.searchView.cateButton  addTarget:self action:@selector(showCateTab) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    self.cateTab = [Factory creatTabbleViewWithFrame:CGRectMake(Anno750(30), 0, Anno750(170), 0) style:UITableViewStylePlain];
    self.cateTab.scrollEnabled = NO;
    self.cateTab.delegate = self;
    self.cateTab.dataSource = self;
    [self.view addSubview:self.cateTab];
    
    self.searchHisTab = [Factory creatTabbleViewWithFrame:CGRectMake(Anno750(40), Anno750(40), SCREENWIDTH - Anno750(80), SCREENHEIGH - 64 - Anno750(100)) style:UITableViewStylePlain];
    self.searchHisTab.dataSource = self;
    self.searchHisTab.delegate = self;
    self.searchHisTab.backgroundColor = COLOR_BACK_ALPHA_5;
    [self.view addSubview:self.searchHisTab];

    
    UIView * header = [Factory creatViewWithColor:[UIColor clearColor]];
    header.frame = CGRectMake(0, 0, SCREENWIDTH - Anno750(80), Anno750(80));
    UILabel * hotSearch = [Factory creatLabelWithTitle:@"历史搜索"
                                             textColor:[UIColor whiteColor] textFont:font750(28) textAlignment:NSTextAlignmentLeft];
    UIView * line = [Factory creatViewWithColor:[UIColor whiteColor]];
    [header addSubview:hotSearch];
    [header addSubview:line];
    [hotSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.centerY.equalTo(@0);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.right.equalTo(@(-Anno750(30)));
        make.height.equalTo(@1);
        make.bottom.equalTo(@0);
    }];
    self.searchHisTab.tableHeaderView = header;
    [self.view bringSubviewToFront:self.cateTab];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.searchView.searchTF) {
        if (textField.text.length>0) {
            SearchResultViewController * vc = [SearchResultViewController new];
            vc.searchTypeModel = self.curSearchModel;
            vc.searchWord = self.searchView.searchTF.text;
            [self addSearchWord:self.searchView.searchTF.text];
            vc.hisArray = self.hisArray;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    return NO;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.cateTab) {
        return self.cateArray.count;
    }else if(tableView == self.searchHisTab){
        return self.hisArray.count;
    }
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.cateTab) {
        return Anno750(60);
    }else if (tableView == self.searchHisTab){
        return Anno750(80);
    }
    return Anno750(60);
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
    }else if(tableView == self.searchHisTab){
        static NSString * hisCell = @"HotSearcherTableViewCell";
        HotSearcherTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:hisCell];
        if (cell == nil) {
            cell = [[HotSearcherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hisCell];
        }
        cell.delegate = self;
        cell.titleLabel.text = self.hisArray[indexPath.row];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.cateTab) {
        for (int i = 0; i<self.cateArray.count; i++) {
            SearchCateModel * model = self.cateArray[i];
            if (i == indexPath.row) {
                model.isSelect = YES;
                self.curSearchModel = model;
                [self.searchView.cateButton setTitle:model.name forState:UIControlStateNormal];
            }else{
                model.isSelect = NO;
            }
        }
        [self showCateList:NO];
    }else if(tableView == self.searchHisTab){
        SearchResultViewController * vc = [SearchResultViewController new];
        vc.searchWord = self.hisArray[indexPath.row];
        vc.searchTypeModel = self.curSearchModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)showCateTab{
    [self showCateList:YES];
}
- (void)showCateList:(BOOL)isShow{
    __weak SearchViewController * weakSelf = self;
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

- (void)deleteHistorySearchWord:(UIButton *)btn{
    UITableViewCell * cell = (UITableViewCell *)[[btn superview] superview];
    NSIndexPath * indexPath = [self.searchHisTab indexPathForCell:cell];
    NSMutableArray * arr = [[NSMutableArray alloc]initWithArray:self.hisArray];
    [arr removeObjectAtIndex:indexPath.row];
    self.hisArray = arr;
    [self saveArrayToDocument:self.hisArray];
    [self.searchHisTab reloadData];
}
- (NSArray *)loadHisArray{
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
    NSString * newFielPath = [documentsPath stringByAppendingPathComponent:@"data.plist"];
    NSArray * arr = [NSArray arrayWithContentsOfFile:newFielPath];
    return arr;
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


@end
