//
//  ChangeGenerViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/26.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "ChangeGenerViewController.h"

@interface ChangeGenerViewController ()

@end

@implementation ChangeGenerViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavUnAlpha];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setNavAlpha];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self drawTitle:@"设置性别"];
}
- (void)creatUI{
    UIButton * manButton = [Factory creatButtonWithTitle:@"男" textFont:font750(30)
                                              titleColor:[UIColor whiteColor] backGroundColor:COLOR_MAIN_RED];
    UIButton * womenButton = [Factory creatButtonWithTitle:@"女" textFont:font750(30)
                                              titleColor:[UIColor whiteColor] backGroundColor:COLOR_MAIN_RED];
    [manButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [womenButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    manButton.layer.cornerRadius = Anno750(10);
    womenButton.layer.cornerRadius = Anno750(10);
    manButton.tag = 101;
    womenButton.tag = 102;
    [self.view addSubview:manButton];
    [self.view addSubview:womenButton];
    [manButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.right.equalTo(@(-Anno750(30)));
        make.height.equalTo(@(Anno750(100)));
        make.top.equalTo(@(64+ Anno750(40)));
    }];
    [womenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.right.equalTo(@(-Anno750(30)));
        make.height.equalTo(@(Anno750(100)));
        make.top.equalTo(manButton.mas_bottom).offset(Anno750(40));
    }];
    
}
- (void)buttonClick:(UIButton *)btn{
    NSString * gender = @"男";
    if (btn.tag == 102) {
        gender = @"女";
    }
    [self changeUserInfoWithGender:gender];
}
- (void)changeUserInfoWithGender:(NSString *)gender{
    NSNumber * userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    NSString * callBack = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSDictionary * params = @{@"uid":userID,
                              @"callback_verify":callBack,
                              @"field_name":@"gender",
                              @"field_value":gender};
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:[BERApiProxy urlWithAction:@"user"] parameters:[BERApiProxy paramsWithDataDic:params action:@"profile_update"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        if([dic[@"code"] intValue] == 0){
            [UserInfo defaultInfo].gender = gender;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:dic[@"msg"] duration:1.0f];
            NSLog(@"%@",dic[@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
@end
