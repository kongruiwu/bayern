//
//  ChangePasswordVC.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/17.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "LogBackGroundView.h"
@interface ChangePasswordVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField * oldPwdTF;
@property (nonatomic, strong) UITextField * currentPwdTF;
@property (nonatomic, strong) UITextField * surePwdTF;
@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawTitle:@"修改密码"];
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
        make.height.equalTo(@(Anno750(548)));
    }];
    self.currentPwdTF = [Factory creatTextFiledWithPlaceHolder:@"请输入新密码"];
    self.oldPwdTF = [Factory creatTextFiledWithPlaceHolder:@"请输入旧密码"];
    self.surePwdTF = [Factory creatTextFiledWithPlaceHolder:@"确认新密码"];
    self.currentPwdTF.secureTextEntry = YES;
    self.oldPwdTF.secureTextEntry = YES;
    self.surePwdTF.secureTextEntry = YES;
    self.currentPwdTF.returnKeyType = UIReturnKeyNext;
    self.oldPwdTF.returnKeyType = UIReturnKeyNext;
    self.currentPwdTF.returnKeyType = UIReturnKeyDone;
    
    self.currentPwdTF.delegate = self;
    self.oldPwdTF.delegate= self;
    self.surePwdTF.delegate = self;
    [groundView addSubview:self.currentPwdTF];
    [groundView addSubview:self.oldPwdTF];
    [groundView addSubview:self.surePwdTF];
    [self.oldPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(40)));
        make.right.equalTo(@(-Anno750(40)));
        make.top.equalTo(@0);
        make.height.equalTo(@(Anno750(88)));
    }];
    
    [self.currentPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(40)));
        make.right.equalTo(@(-Anno750(40)));
        make.top.equalTo(self.oldPwdTF.mas_bottom).offset(Anno750(40));
        make.height.equalTo(@(Anno750(88)));
    }];
    [self.surePwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(40)));
        make.right.equalTo(@(-Anno750(40)));
        make.top.equalTo(self.currentPwdTF.mas_bottom).offset(Anno750(40));
        make.height.equalTo(@(Anno750(88)));
    }];
    UIButton * registBtn = [Factory creatButtonWithTitle:@"修改密码"
                                                textFont:font750(32)
                                              titleColor:[UIColor whiteColor]
                                         backGroundColor:COLOR_MAIN_RED];
    [groundView addSubview:registBtn];
    registBtn.layer.cornerRadius = Anno750(44);
    [registBtn addTarget:self action:@selector(changeUserPassword) forControlEvents:UIControlEventTouchUpInside];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(40)));
        make.right.equalTo(@(-Anno750(40)));
        make.top.equalTo(self.surePwdTF.mas_bottom).offset(Anno750(50));
        make.height.equalTo(@(Anno750(88)));
    }];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.oldPwdTF) {
        [self.currentPwdTF becomeFirstResponder];
    }else if(textField == self.currentPwdTF){
        [self.surePwdTF becomeFirstResponder];
    }else{
        [self changeUserPassword];
    }
    return YES;
}
- (void)changeUserPassword{
    [self.view endEditing:YES];
    if ([self.currentPwdTF.text isEqualToString:self.surePwdTF.text]) {
        NSNumber * userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
        NSString * callBack = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSDictionary * params = @{@"uid":userID,
                                  @"callback_verify":callBack,
                                  @"original_password":self.oldPwdTF.text,
                                  @"new_password":self.currentPwdTF.text};
        AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
        [manger GET:[BERApiProxy urlWithAction:@"user"] parameters:[BERApiProxy paramsWithDataDic:params action:@"modify_password"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic=(NSDictionary *)responseObject;
            if([dic[@"code"] intValue] == 0){
                [ToastView presentToastWithin:self.view.window withIcon:APToastIconNone text:@"密码修改成功" duration:2.0f];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [ToastView presentWhiteToastWithin:self.view withIcon:APToastIconNone text:dic[@"msg"] duration:1.0f];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else{
        [ToastView presentWhiteToastWithin:self.view withIcon:APToastIconNone text:@"两次密码输入不一致，请检查后重新填写" duration:1.0f];
    }
    
    
}
@end
