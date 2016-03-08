//
//  BERRootViewController.m
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERRootViewController.h"

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

@end
