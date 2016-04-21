//
//  BERClubViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 15/7/31.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERClubViewController.h"
#import "BERHeadFile.h"
@interface BERClubViewController ()

@end

@implementation BERClubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self drawTitle:@"俱乐部"];
    [self drawMainTabItem];
    [self initWeb];
}
-(void)initWeb
{
    UIWebView *web=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0,SCREENWIDTH , SCREENHEIGHT-64)];
    self.url=@"http://www.fcbayern.cn/club?app=1";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CLUB"] != nil) {
        self.url=[[NSUserDefaults standardUserDefaults] objectForKey:@"CLUB"];
    }
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    web.delegate=self;
    [self.view addSubview:web];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.view hideLoadWithAnimated:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.view hideLoadWithAnimated:YES];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.view showLoadWithAnimated:YES];
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
