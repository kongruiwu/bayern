//
//  BERRootViewController.m
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERRootViewController.h"
#import "SearchViewController.h"
@interface BERRootViewController ()

@end

@implementation BERRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.sliderWidth = [BERMainCenter sharedInstance].getSliderContainerWidth;
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

- (void)drawTitle:(NSString *)title {
    CGFloat titleViewH = 24;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, titleViewH)];
    titleView.backgroundColor = [UIColor clearColor];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    icon.frame = CGRectMake(0, 0, 24, 24);
    [titleView addSubview:icon];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 100, titleViewH)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textColor = [UIColor whiteColor];
    titleLb.font = [UIFont systemFontOfSize:18];
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.text = title;
    [titleView addSubview:titleLb];
    
    self.navigationItem.titleView = titleView;
}

//用于首页，左右切换页面滑动
- (void)drawMainTabItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"item"] style:UIBarButtonItemStyleBordered target:self action:@selector(leftDidScroll)];
    self.navigationItem.leftBarButtonItem = item;
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"game"] style:UIBarButtonItemStyleBordered target:self action:@selector(rightDidScroll)];
    self.navigationItem.rightBarButtonItem = item2;
}
- (void)drawMainTabItemWithSearchItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"item"] style:UIBarButtonItemStyleBordered target:self action:@selector(leftDidScroll)];
    self.navigationItem.leftBarButtonItem = item;
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"game"] style:UIBarButtonItemStyleBordered target:self action:@selector(rightDidScroll)];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_search"] style:UIBarButtonItemStyleBordered target:self action:@selector(searchBtnSelect)];
    self.navigationItem.rightBarButtonItems = @[item2,item3];
}
- (void)searchBtnSelect{
    [self.navigationController pushViewController:[SearchViewController new] animated:YES];
}
- (void)drawBackButton {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_2"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)drawShareButton {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(doShare)];
    self.navigationItem.rightBarButtonItem = leftItem;
}

#pragma mark - Selector Method

- (void)leftDidScroll {
    [[AppDelegate sharedInstance] toggleLeftDrawer:self animated:YES];
}

- (void)rightDidScroll {
    [[AppDelegate sharedInstance] toggleRightDrawer:self animated:YES];
}

- (void)doBack {
    switch (self.backType) {
        case RTSelectorBackTypeDismiss:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case RTSelectorBackTypePopBack:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case RTSelectorBackTypePopToRoot:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}

- (void)doShare {
    
}

#pragma mark - NFLShareViewDelegate

- (void)shareBackgroundDidClick {
    [self.shareView removeFromSuperview];
    self.shareView = nil;
}

- (void)shareCancleButtonDidClick {
    [self.shareView removeFromSuperview];
    self.shareView = nil;
}

#pragma mark - Getter

- (NFLShareView *)shareView {
    if (!_shareView) {
        _shareView = [[NFLShareView alloc] initWithFrame:CGRectMake(0, 0, WindowWidth, WindowHeight)];
        _shareView.delegate = self;
    }
    
    return _shareView;
}

- (void)setBackGroundImage{
    UIImageView * imageView = [Factory creatImageViewWithImageName:@"groundImage"];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}
- (void)setNavAlpha{
    self.navigationController.navigationBar.translucent = YES;
    UIView * clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    [self.view addSubview:clearView];
    //    导航栏变为透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //    让黑线消失的方法
    self.navigationController.navigationBar.shadowImage=[UIImage new];
}
- (void)setNavUnAlpha{
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    self.navigationController.navigationBar.shadowImage = nil;
}

@end
