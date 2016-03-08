//
//  BERFixturesViewController.m
//  Bayern
//
//  Created by wurui on 15/7/21.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERFixturesViewController.h"
#import "BERHeadFile.h"
#import "BERNewsPictureViewController.h"
@interface BERFixturesViewController ()

@end

@implementation BERFixturesViewController
{
    UIScrollView *mainScrView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawMainTabItem];
    [self drawTitle:@"赛程"];
    
    [self initUI];
    [self creatTabView];
    // Do any additional setup after loading the view from its nib.
}
-(void)initUI
{
    //头部导航按钮
    NSArray *buttonTitleArr=@[@"德甲",@"欧冠",@"德国杯",@"其他"];
    self.titleArr=buttonTitleArr;
    for (int i=0; i<buttonTitleArr.count; i++)
    {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(0+i*SCREENWIDTH/buttonTitleArr.count, 0, SCREENWIDTH/buttonTitleArr.count, 44);
        [btn setTitle:buttonTitleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"999999"]
                  forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:TEXTFONTSIZE];
        if (i==0) {
            [btn setTitleColor:[UIColor colorWithHexString:@"e4003a"]
                      forState:UIControlStateNormal];
            //btn.titleLabel.font=[UIFont boldSystemFontOfSize:TEXTFONTSIZE];
        }
        btn.tag=1000+i;
        [btn addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    UIButton *btn1=(UIButton *)[self.view viewWithTag:1000];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, btn1.frame.origin.y+btn1.frame.size.height, btn1.frame.size.width, 2)];
    lineView.backgroundColor=[UIColor colorWithHexString:@"e4003a"];
    lineView.tag=1100;
    [self.view addSubview:lineView];
    
    mainScrView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, lineView.frame.origin.y+lineView.frame.size.height, SCREENWIDTH, SCREENHEIGHT-lineView.frame.size.height-lineView.frame.origin.y)];
    mainScrView.contentSize=CGSizeMake(SCREENWIDTH*self.titleArr.count, SCREENHEIGHT-lineView.frame.size.height-lineView.frame.origin.y);
    mainScrView.pagingEnabled=YES;
    mainScrView.showsHorizontalScrollIndicator=NO;
    mainScrView.showsVerticalScrollIndicator=NO;
    mainScrView.delegate=self;
    
    [self.view addSubview:mainScrView];
}
#pragma mark - btn 点击事件
-(void)headButtonClick:(UIButton *)btn
{
    UIView *lineView=[self.view viewWithTag:1100];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame=CGRectMake(btn.frame.origin.x, btn.frame.origin.y+btn.frame.size.height, btn.frame.size.width, 2);
        lineView.frame=frame;
    }];
    for (int i=0; i<self.titleArr.count; i++) {
        UIButton *btn1=(UIButton *)[self.view viewWithTag:1000+i];
        if (btn1.tag==btn.tag) {
            [btn1 setTitleColor:[UIColor colorWithHexString:@"e4003a"]
                       forState:UIControlStateNormal];
        }else
        {
            [btn1 setTitleColor:[UIColor colorWithHexString:@"999999"]
                       forState:UIControlStateNormal];
        }
    }
    CGPoint point=CGPointMake(mainScrView.frame.size.width*(btn.tag-1000), 0);
    mainScrView.contentOffset=point;
    
}
#pragma ScrollView的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==mainScrView)
    {
    UIView *lineView=(UIView *)[self.view viewWithTag:1100];
    CGRect frame=CGRectMake(mainScrView.contentOffset.x/mainScrView.frame.size.width*lineView.frame.size.width, lineView.frame.origin.y, lineView.frame.size.width, lineView.frame.size.height);
    lineView.frame=frame;
    }
    int x=(int)mainScrView.contentOffset.x/mainScrView.frame.size.width;
    for (int i=0; i<self.titleArr.count; i++) {
        UIButton *btn=(UIButton *)[self.view viewWithTag:1000+i];
        if (i==x) {
            [btn setTitleColor:[UIColor colorWithHexString:@"e4003a"]
                      forState:UIControlStateNormal];
        }else
        {
            [btn setTitleColor:[UIColor colorWithHexString:@"999999"]
                      forState:UIControlStateNormal];
        }
    }
    
}
#pragma mark - 创建TB
-(void)creatTabView
{
    NSArray *leadgueIDArray=@[@"5",@"9",@"113",@"0"];

    for (int i=0; i<leadgueIDArray.count; i++) {
        BERFixtureListView *view=[[BERFixtureListView alloc]initWithFrame:CGRectMake(0+i*SCREENWIDTH, 0, SCREENWIDTH, mainScrView.frame.size.height-64)];
        view.delegate=self;
        [view creatTabViewWtihLeadgueID:leadgueIDArray[i]];
        [mainScrView addSubview:view];
    }
}
-(void)pushToImgViewController:(BERFixtureModel *)model
{
    if([model.album_link intValue]==0)
    {
        UIAlertView *aler=[[UIAlertView alloc]initWithTitle:@"提示"
                        message:@"暂无图集，敬请期待"
                        delegate:self
                        cancelButtonTitle:@"退出"
                        otherButtonTitles:nil, nil];
        [aler show];
    }else{
    [NFLAppLogManager sendLogWithEventID:EventID_Photos withKeyName:KN_PhotosList andValueName:@"Photos"];
    [BERShareModel sharedInstance].shareID=[NSString stringWithFormat:@"%@",model.album_link];
    [BERShareModel sharedInstance].shareTitle=[NSString stringWithFormat:@"%@",model.league_title];
    [BERShareModel sharedInstance].shareUrl=[[BERShareModel sharedInstance] getShareURL:NO];
    BERNewsPictureViewController *nd = [[BERNewsPictureViewController alloc] init];
    nd.news_id = [NSString stringWithFormat:@"%@",model.album_link];
    [self.navigationController pushViewController:nd animated:YES];
    }
}
-(void)showLoadView
{
    [self.view showLoadWithAnimated:YES];
}
-(void)hideLoadView
{
    [self.view hideLoadWithAnimated:YES];
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

@end
