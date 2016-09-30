//
//  FindPassWordViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/12.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "FindPassWordViewController.h"
#import "LogBackGroundView.h"
@interface FindPassWordViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField * emailTF;
@property (nonatomic, strong) UITextField * nameTF;
@end

@implementation FindPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawTitle:@"找回密码"];
    [self drawBackButton];
    [self setBackGroundImage];
    [self creatUI];
}

- (void)creatUI{
    LogBackGroundView * headview = [[LogBackGroundView alloc]init];
    [self.view addSubview:headview];
    [headview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Anno750(90)));
        make.left.right.equalTo(@0);
        make.height.equalTo(@(Anno750(400)));
    }];
    
    UIView * groundView = [Factory creatViewWithColor:COLOR_BACK_ALPHA_8];
    [self.view addSubview:groundView];
    [groundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(40)));
        make.right.equalTo(@(-Anno750(40)));
        make.top.equalTo(headview.mas_bottom);
        make.height.equalTo(@(Anno750(420)));
    }];
    self.emailTF = [Factory creatTextFiledWithPlaceHolder:@"电子邮箱"];
    self.nameTF = [Factory creatTextFiledWithPlaceHolder:@"用户名"];
    [groundView addSubview:self.emailTF];
    [groundView addSubview:self.nameTF];
    
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(40)));
        make.right.equalTo(@(-Anno750(40)));
        make.top.equalTo(@0);
        make.height.equalTo(@(Anno750(88)));
    }];
    
    [self.emailTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(40)));
        make.right.equalTo(@(-Anno750(40)));
        make.top.equalTo(self.nameTF.mas_bottom).offset(Anno750(40));
        make.height.equalTo(@(Anno750(88)));
    }];
    
    UIButton * registBtn = [Factory creatButtonWithTitle:@"找回密码"
                                                textFont:font750(32)
                                              titleColor:[UIColor whiteColor]
                                         backGroundColor:COLOR_MAIN_RED];
    [groundView addSubview:registBtn];
    [registBtn addTarget:self action:@selector(findBackPasswordRequest) forControlEvents:UIControlEventTouchUpInside];
    registBtn.layer.cornerRadius = Anno750(44);
    
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(40)));
        make.right.equalTo(@(-Anno750(40)));
        make.top.equalTo(self.emailTF.mas_bottom).offset(Anno750(50));
        make.height.equalTo(@(Anno750(88)));
    }];
    
    self.nameTF.delegate = self;
    self.emailTF.delegate = self;
    self.nameTF.returnKeyType = UIReturnKeyNext;
    self.emailTF.returnKeyType = UIReturnKeyDone;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.nameTF) {
        [self.emailTF becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self findBackPasswordRequest];
        });
    }
    return YES;
}


- (void)findBackPasswordRequest{
    NSDictionary * params = @{@"username":self.nameTF.text,
                              @"email":self.emailTF.text};
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:[BERApiProxy urlWithAction:[self getMainActionName]] parameters:[BERApiProxy paramsWithDataDic:params action:[self getActionName]] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        if ([dic[@"code"] intValue] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            [ToastView presentWhiteToastWithin:self.view.window withIcon:APToastIconNone text:@"修改方式已发送至您的邮箱，修改后请重新登录" duration:3.0];
        }else{
            [ToastView presentWhiteToastWithin:self.view.window withIcon:APToastIconNone text:dic[@"msg"] duration:2.0];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
-(NSString *)getActionName
{
    return @"getRecode";
}
-(NSString *)getMainActionName
{
    return @"user";
}
@end
