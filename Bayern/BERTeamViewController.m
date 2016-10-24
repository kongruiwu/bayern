//
//  BERTeamViewController.m
//  Bayern
//
//  Created by wusicong on 15/6/18.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERTeamViewController.h"
#import "BERDetailTeamViewController.h"
#import "HMSegmentedControl.h"
#import "ListTeamerModel.h"
@interface BERTeamViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) HMSegmentedControl * segmentControl;
@property (nonatomic, strong) NSArray * titles;
@property (nonatomic, strong) UIScrollView * mainScroll;
@property (nonatomic, strong) NSMutableArray * viewControllers;
@property (nonatomic, strong) NSMutableArray * dataArray;
@end

@implementation BERTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self drawMainTabItem];
    [self drawTitle:@"球队"];

    
    [self doRequest];
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
    self.titles = @[@"门将",@"后卫",@"中场",@"前锋",@"教练"];
    self.dataArray = [[NSMutableArray alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BERApiProxy urlWithAction:@"team"] parameters:[BERApiProxy paramsWithDataDic:params action:@"get_list"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] integerValue] == 0) {
            
            NSDictionary *teamDataDic = dic[@"data"];
            
            if (teamDataDic.count > 0) {
                for (int i = 0; i < teamDataDic.count; i ++) {
                    NSString *key = [NSString stringWithFormat:@"%d",i+1];
                    NSArray * arr = teamDataDic[key];
                    NSMutableArray * muArr = [NSMutableArray new];
                    for (int j = 0; j<arr.count; j++) {
                        ListTeamerModel * model = [[ListTeamerModel alloc]initWithDictionary:arr[j]];
                        model.cate = self.titles[i];
                        [muArr addObject:model];
                    }
                    [self.dataArray addObject:muArr];
                }
            }
        }
        [self creatUI];
        [self.view hideLoadWithAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view hideLoadWithAnimated:YES];
    }];
}



- (void)creatUI{
    
    self.segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:self.titles];
    self.segmentControl.frame = CGRectMake(0, 0, SCREENWIDTH, Anno750(80));
    //设置字体
    self.segmentControl.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:font750(30)],
                                                NSForegroundColorAttributeName : COLOR_CONTENT_GRAY_9};
    self.segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:font750(30)],
                                                        NSForegroundColorAttributeName : COLOR_MAIN_RED};
    
    //设置移动线条属性
    self.segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentControl.selectionIndicatorHeight = Anno750(6);
    self.segmentControl.selectionIndicatorColor = COLOR_MAIN_RED;
    self.segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    [self.view addSubview:self.segmentControl];
    
    UIView * lineView = [Factory creatViewWithColor:COLOR_LINECOLOR];
    [self.segmentControl addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,Anno750(80), SCREENWIDTH,  SCREENHEIGH - Anno750(80))];
    self.mainScroll.contentSize = CGSizeMake(self.titles.count * SCREENWIDTH, 0);
    [self.mainScroll autoresizingMask];
    self.mainScroll.pagingEnabled = YES;
    self.mainScroll.showsVerticalScrollIndicator = NO;
    self.mainScroll.showsHorizontalScrollIndicator = NO;
    self.mainScroll.backgroundColor = [UIColor whiteColor];
    self.mainScroll.delegate = self;
    [self.view addSubview:self.mainScroll];
    self.viewControllers = [NSMutableArray new];
    for (int i = 0 ; i<self.titles.count; i++) {
        if (i == 0) {
            BERTeamListController *vc = [BERTeamListController new];
            vc.view.frame = CGRectMake(SCREENWIDTH * i, 0, SCREENWIDTH , SCREENHEIGH - Anno750(80));
            vc.dataArray = self.dataArray[i];
            [self.mainScroll addSubview:vc.view];
            [self addChildViewController:vc];
            [self.viewControllers addObject:vc];
        }else{
            [self.viewControllers addObject:@"BERTeamListController"];
        }
        
    }
    
    //这里 是是用时进行创建 避免内存浪费
    __weak BERTeamViewController * weakSelf = self;
    [self.segmentControl setIndexChangeBlock:^(NSInteger index) {
        if (![weakSelf.viewControllers[index] isKindOfClass:[UIViewController class]]) {
            BERTeamListController *vc = [BERTeamListController new];
            vc.dataArray = weakSelf.dataArray[index];
            vc.view.frame = CGRectMake(SCREENWIDTH * index, 0, SCREENWIDTH , SCREENHEIGH - Anno750(80));
            [weakSelf.mainScroll addSubview:vc.view];
            [weakSelf addChildViewController:vc];
            [weakSelf.viewControllers replaceObjectAtIndex:index withObject:vc];
        }
        [UIView animateWithDuration:0.3f animations:^{
            weakSelf.mainScroll.contentOffset = CGPointMake(SCREENWIDTH * index, 0);
        }];
    }];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x / SCREENWIDTH;
    [self.segmentControl setSelectedSegmentIndex:index animated:YES];
    if (![self.viewControllers[index] isKindOfClass:[UIViewController class]]) {
        BERTeamListController *vc = [BERTeamListController new];
        vc.dataArray = self.dataArray[index];
        vc.view.frame = CGRectMake(SCREENWIDTH * index, 0, SCREENWIDTH , SCREENHEIGH - Anno750(80));
        [self.mainScroll addSubview:vc.view];
        [self addChildViewController:vc];
        [self.viewControllers replaceObjectAtIndex:index withObject:vc];
    }
}

@end
