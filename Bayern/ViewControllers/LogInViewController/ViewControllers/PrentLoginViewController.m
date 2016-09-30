//
//  PrentLoginViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 2016/9/28.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "PrentLoginViewController.h"
#import "LogBackGroundView.h"
#import "PrentRegisterViewController.h"
#import "FindPassWordViewController.h"
@interface PrentLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField * userName;
@property (nonatomic, strong) UITextField * passWord;


@end

@implementation PrentLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackGroundImage];
    [self drawTitle:@"登陆"];
    self.backType = SelectorBackTypeDismiss;
    [self drawBackButton];
    [self creatUI];
}
- (void)creatUI{
    LogBackGroundView * headView = [[LogBackGroundView alloc]init];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Anno750(90)));
        make.left.right.equalTo(@0);
        make.height.equalTo(@(Anno750(400)));
    }];
    
    UIView * groundView = [Factory creatViewWithColor:COLOR_BACK_ALPHA_8];
    [self.view addSubview:groundView];
    [groundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(40)));
        make.right.equalTo(@(-Anno750(40)));
        make.top.equalTo(headView.mas_bottom);
        make.height.equalTo(@(Anno750(500)));
    }];
    
    UITextField * userName = [Factory creatTextFieldWithPlaceHolder:@"用户名/邮箱"
                                                      textAlignment:NSTextAlignmentCenter
                                                          textColor:[UIColor whiteColor]
                                                          fontValue:font750(28)];
    userName.returnKeyType = UIReturnKeyNext;
    userName.backgroundColor = [UIColor clearColor];
    [groundView addSubview:userName];
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(40)));
        make.right.equalTo(@(-Anno750(40)));
        make.height.equalTo(@(Anno750(88)));
        make.top.equalTo(@0);
    }];
    userName.delegate = self;
    self.userName = userName;
    UITextField * passWord = [Factory creatTextFieldWithPlaceHolder:@"密码"
                                                      textAlignment:NSTextAlignmentCenter
                                                          textColor:[UIColor whiteColor]
                                                          fontValue:font750(28)];
    passWord.delegate = self;
    passWord.secureTextEntry = YES;
    passWord.returnKeyType = UIReturnKeyDone;
    [groundView addSubview:passWord];
    [passWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(40)));
        make.right.equalTo(@(-Anno750(40)));
        make.height.equalTo(@(Anno750(88)));
        make.top.equalTo(userName.mas_bottom).offset(Anno750(40));
    }];
    self.passWord = passWord;
    UIButton * loginButton = [Factory creatButtonWithTitle:@"登陆"
                                                  textFont:font750(32)
                                                titleColor:[UIColor whiteColor]
                                           backGroundColor:COLOR_MAIN_RED];
    [groundView addSubview:loginButton];
    loginButton.layer.cornerRadius = Anno750(44);
    [loginButton addTarget:self action:@selector(userLoginRequest) forControlEvents:UIControlEventTouchUpInside];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(40)));
        make.right.equalTo(@(-Anno750(40)));
        make.height.equalTo(@(Anno750(88)));
        make.top.equalTo(passWord.mas_bottom).offset(Anno750(40));
    }];
    
    UIView * centerLine = [Factory creatViewWithColor:[UIColor whiteColor]];
    [groundView addSubview:centerLine];
    [centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.width.equalTo(@1);
        make.height.equalTo(@(Anno750(25)));
        make.top.equalTo(loginButton.mas_bottom).offset(Anno750(50));
    }];
    
    UIButton * findPwd = [Factory creatButtonWithTitle:@"找回密码"
                                              textFont:font750(30)
                                            titleColor:[UIColor whiteColor] backGroundColor:[UIColor clearColor]];
    [groundView addSubview:findPwd];
    [findPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(centerLine.mas_left).offset(-Anno750(40));
        make.centerY.equalTo(centerLine.mas_centerY);
    }];
    [findPwd addTarget:self action:@selector(pushToFindPassWord) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * resgisterBtn = [Factory creatButtonWithTitle:@"10秒新人注册"
                                                   textFont:font750(30)
                                                 titleColor:[UIColor whiteColor]
                                            backGroundColor:[UIColor clearColor]];
    [groundView addSubview:resgisterBtn];
    [resgisterBtn addTarget:self action:@selector(pushToRegistViewController) forControlEvents:UIControlEventTouchUpInside];
    [resgisterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerLine.mas_right).offset(Anno750(40));
        make.centerY.equalTo(centerLine.mas_centerY);
    }];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.userName) {
        [self.passWord becomeFirstResponder];
    }else if(textField == self.passWord){
        [self userLoginRequest];
    }
    return YES;
}
- (void)userLoginRequest{
    NSDictionary * params = @{@"username":self.userName.text,
                              @"password":self.passWord.text};
    [self.view showLoadWithAnimated:YES];
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    __weak PrentLoginViewController * weakSelf = self;
    [manger GET:[BERApiProxy urlWithAction:[self getMainActionName]] parameters:[BERApiProxy paramsWithDataDic:params action:[self getActionName]] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view hideLoadWithAnimated:YES];
        NSDictionary *dic=(NSDictionary *)responseObject;
        if ([dic[@"code"] intValue] == 0) {
            NSDictionary * data = dic[@"data"];
            [[UserInfo defaultInfo] setKeyValueForKeyWithDictionary:data];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [ToastView presentWhiteToastWithin:weakSelf.view withIcon:APToastIconNone text:dic[@"msg"] duration:1.5f];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.view hideLoadWithAnimated:YES];
    }];
}



-(NSString *)getActionName
{
    return @"login";
}
-(NSString *)getMainActionName
{
    return @"user";
}


- (void)pushToRegistViewController{
    [self.navigationController pushViewController:[PrentRegisterViewController new] animated:YES];
}
- (void)pushToFindPassWord{
    [self.navigationController pushViewController:[FindPassWordViewController new] animated:YES];
}

@end
