//
//  BaseViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 16/8/31.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)drawBackButton{
    UIImage * image = [[UIImage imageNamed:@"back_2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)doBack{
    switch (self.backType) {
        case SelectorBackTypeDismiss:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case SelectorBackTypePopBack:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case SelectorBackTypePoptoRoot:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}
- (void)setNavigationTitle:(NSString *)title{
    
    UIView * titleView = [Factory creatViewWithColor:[UIColor clearColor]];
    titleView.frame = CGRectMake(0, 0, 100, 40);
    
    UIImageView * icon = [Factory creatImageViewWithImageName:@"logo"];
    UILabel * titleLabel = [Factory creatLabelWithTitle:title
                                              textColor:[UIColor whiteColor]
                                               textFont:font750(36) textAlignment:NSTextAlignmentLeft];
    [titleView addSubview:icon];
    [titleView addSubview:titleLabel];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@0);
        make.height.with.equalTo(@(Anno750(48)));
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(Anno750(20));
        make.centerY.equalTo(@0);
    }];
    
    self.navigationItem.titleView = titleView;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = COLOR_MAIN_RED;
}
- (void)setBackGroundImage{
    UIImageView * imageView = [Factory creatImageViewWithImageName:@"groundImage"];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

@end
