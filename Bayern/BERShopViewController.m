//
//  BERShopViewController.m
//  Bayern
//
//  Created by wusicong on 15/6/18.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERShopViewController.h"

@interface BERShopViewController ()

@end

@implementation BERShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    if (self.isNormalWebView) {
        [self drawTitle:@"广告"];
    } else {
        [self drawMainTabItem];
        [self drawTitle:@"商店"];
    }
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
