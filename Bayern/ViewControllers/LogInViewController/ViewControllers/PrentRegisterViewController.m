//
//  PrentRegisterViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 2016/9/28.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "PrentRegisterViewController.h"
#import "LogBackGroundView.h"
@interface PrentRegisterViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField * userName;
@property (nonatomic, strong) UITextField * email;
@property (nonatomic, strong) UITextField * password;

@end

@implementation PrentRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawTitle:@"注册"];
    [self setBackGroundImage];
    [self drawBackButton];
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
        make.height.equalTo(@(Anno750(630)));
    }];
    
    self.userName = [Factory creatTextFiledWithPlaceHolder:@"用户名，长度为3-15个字符"];
    self.email = [Factory creatTextFiledWithPlaceHolder:@"电子邮箱"];
    self.password = [Factory creatTextFiledWithPlaceHolder:@"填写密码，最小长度为6个字符"];
    self.password.secureTextEntry = YES;
    self.userName.delegate = self;
    self.email.delegate = self;
    self.password.delegate = self;
    self.userName.returnKeyType = UIReturnKeyNext;
    self.email.returnKeyType = UIReturnKeyNext;
    self.password.returnKeyType = UIReturnKeyDone;
    [groundView addSubview:self.userName];
    [groundView addSubview:self.email];
    [groundView addSubview:self.password];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(40)));
        make.right.equalTo(@(-Anno750(40)));
        make.top.equalTo(@0);
        make.height.equalTo(@(Anno750(88)));
    }];
    [self.email mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(40)));
        make.right.equalTo(@(-Anno750(40)));
        make.top.equalTo(self.userName.mas_bottom).offset(Anno750(40));
        make.height.equalTo(@(Anno750(88)));
    }];
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(40)));
        make.right.equalTo(@(-Anno750(40)));
        make.top.equalTo(self.email.mas_bottom).offset(Anno750(40));
        make.height.equalTo(@(Anno750(88)));
    }];
    UIButton * registBtn = [Factory creatButtonWithTitle:@"注册"
                                                textFont:font750(32)
                                              titleColor:[UIColor whiteColor]
                                         backGroundColor:COLOR_MAIN_RED];
    [groundView addSubview:registBtn];
    [registBtn addTarget:self action:@selector(userRegistRequest) forControlEvents:UIControlEventTouchUpInside];
    registBtn.layer.cornerRadius = Anno750(44);
    
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(40)));
        make.right.equalTo(@(-Anno750(40)));
        make.top.equalTo(self.password.mas_bottom).offset(Anno750(50));
        make.height.equalTo(@(Anno750(88)));
    }];
    
    NSString *logStr = @"已有账户？立即登陆";
    UIButton * loginBtn = [Factory creatButtonWithTitle:logStr
                                               textFont:font750(30)
                                             titleColor:[UIColor whiteColor] backGroundColor:[UIColor clearColor]];
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:logStr];
    [attStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(logStr.length - 4, 4)];
    [loginBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, logStr.length)];
    [groundView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(registBtn.mas_bottom).offset(Anno750(40));
    }];
    [loginBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.userName) {
        [self.email becomeFirstResponder];
    }else if(textField == self.email){
        [self.password becomeFirstResponder];
    }else if(textField == self.password){
        [self userRegistRequest];
    }
    return YES;
}

- (void)userRegistRequest{
    [self.view showLoadWithAnimated:YES];
    NSDictionary * params = @{@"username":self.userName.text,
                              @"password":self.password.text,
                              @"email":self.email.text};
    __weak PrentRegisterViewController * weakSelf = self;
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
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
    return @"register";
}
-(NSString *)getMainActionName
{
    return @"user";
}


@end
