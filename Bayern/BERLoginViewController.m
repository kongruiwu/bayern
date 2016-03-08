//
//  BERLoginViewController.m
//  Bayern
//
//  Created by wurui on 15/10/25.
//  Copyright © 2015年 Wusicong. All rights reserved.
//

#import "BERLoginViewController.h"
#import "BERHeadFile.h"
#import "BERRegisterViewController.h"
#import "BERFoundPassWordViewController.h"

@interface BERLoginViewController ()

@property (nonatomic, strong) UITextField * emailTextF;

@property (nonatomic, strong) UITextField * passWordTextF;

@property (nonatomic, strong) UIButton    * logInBtn;

@property (nonatomic, strong) UIButton    * registerBtn;

@end

@implementation BERLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawBackButton];
    
    [self drawTitle:@"登录"];
    
    [self creatUI];
}
- (void)creatUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f5f8"];
    
    self.emailTextF = [self creatTextFieldWithPlaceHolder:@"用户名/邮箱" Frame:
                       CGRectMake(10, 40,SCREENWIDTH - 20, 40)];
    self.passWordTextF
                    = [self creatTextFieldWithPlaceHolder:@"密码" Frame:CGRectMake(10, 90, SCREENWIDTH - 20, 40)];
    self.passWordTextF.secureTextEntry = YES;
    
    UIButton * foundPwd =[UIButton buttonWithType:UIButtonTypeCustom];
    foundPwd.frame = CGRectMake(SCREENWIDTH - 100 -20, 140, 100, 20);
    foundPwd.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    foundPwd.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [foundPwd setTitle:@"找回密码" forState:UIControlStateNormal];
    [foundPwd setTitleColor:[UIColor colorWithHexString:BERContentTextColor] forState:UIControlStateNormal];
    [self.view addSubview:foundPwd];
    
    self.logInBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 180, SCREENWIDTH - 20, 44) RedBackGroundColorAndTitle:@"登录"];
    [self.view addSubview:self.logInBtn];
    
    self.registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 180 + 44 +10, SCREENWIDTH - 20, 44) WhiteBackGroundColorAndTitle:@"注册新账号"];
    [self.view addSubview:self.registerBtn];
    
    [self.logInBtn addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.registerBtn addTarget:self action:@selector(goUserRegisterView) forControlEvents:UIControlEventTouchUpInside];
    [foundPwd addTarget:self action:@selector(getBackUserPassWord) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)goUserRegisterView{
    BERRegisterViewController * vc = [[BERRegisterViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)userLogin{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    [manger POST:[BERApiProxy urlWithAction:[self getMainActionName]] parameters:[BERApiProxy paramsWithDataDic:[self getParams] action:[self getActionName]]
    success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",responseObject[@"msg"]);
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] intValue] == 0) {
            NSDictionary * dic = [responseObject objectForKey:@"data"];
            [[BERUserManger shareMangerUserInfo] configModelValueWithDic:dic];
            [LMToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"登录成功" duration:1.0f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self doBack];
            });
        }else{
            NSString * str;
            switch ([[responseObject objectForKey:@"code"] intValue]) {
                case -1:
                    str = @"填写信息不完整";
                    break;
                case -2:
                    str = @"用户不存在";
                    break;
                case -3:
                    str = @"密码错误";
                    break;
                case -4:
                    str = @"发生未知错误";
                    break;
                case -10:
                    str = @"基本参数错误或者用户数据已存在";
                    break;
                case -11:
                    str = @"sign验证错误";
                    break;

                default:
                    break;
            }
            [LMToastView presentToastWithin:self.view withIcon:APToastIconNone text:str duration:1.0f];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [LMToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"网络错误" duration:1.0f];
    }];
    
}
- (NSString *)getMainActionName{
    return @"user";
}
- (NSDictionary *)getParams{
    NSDictionary * params = @{
                       @"username":self.emailTextF.text,
                       @"password":self.passWordTextF.text
                              };
    return params;
}
- (NSString *)getActionName{
    return @"login";
}
- (void)getBackUserPassWord{
    BERFoundPassWordViewController * vc = [[BERFoundPassWordViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (UITextField *)creatTextFieldWithPlaceHolder:(NSString *)placeHolder Frame:(CGRect)frame{
    UIView * view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderColor     = [[UIColor colorWithHexString:BERLineViewColor]CGColor];
    view.layer.borderWidth     = 1.0f;
    view.layer.masksToBounds   = YES;
    view.layer.cornerRadius    = frame.size.height/2;
    [self.view addSubview:view];
    
    
    UITextField * textF = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, frame.size.width - 40, frame.size.height)];
    NSMutableAttributedString * pla = [[NSMutableAttributedString alloc]initWithString:placeHolder];
    [pla addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:BERContentTextColor] range:NSMakeRange(0, placeHolder.length)];
    textF.attributedPlaceholder = pla;
    textF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [view addSubview:textF];
    return textF;
}
- (void)doBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.emailTextF resignFirstResponder];
    [self.passWordTextF resignFirstResponder];
}
@end
