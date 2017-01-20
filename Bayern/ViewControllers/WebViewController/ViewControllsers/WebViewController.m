//
//  WebViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 2016/10/24.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView * webviw;
@property (nonatomic, strong) NSString * navtitle;
@property (nonatomic, strong) NSString * url;
@end

@implementation WebViewController

- (instancetype)initWithUrl:(NSString *)urlStr andTitle:(NSString *)title{
    self = [super init];
    if (self) {
        _url = urlStr;
        _navtitle = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawTitle:_navtitle];
    [self drawBackButton];
    self.webviw = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH - 64)];
    [self.view addSubview:self.webviw];
    self.webviw.scalesPageToFit = YES;
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_url]];
    [self.webviw loadRequest:request];
}
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//
//}
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
