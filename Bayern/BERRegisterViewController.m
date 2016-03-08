//
//  BERRegisterViewController.m
//  Bayern
//
//  Created by wurui on 15/10/25.
//  Copyright © 2015年 Wusicong. All rights reserved.
//

#import "BERRegisterViewController.h"
#import "BERHeadFile.h"


@interface BERRegisterViewController ()

@property (nonatomic, strong) UITextField * emailTextF;

@property (nonatomic, strong) UITextField * passWordTextF;

@property (nonatomic, strong) UITextField * userNameTextF;

@property (nonatomic, strong) UIButton    * registerBtn;

@end

@implementation BERRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawBackButton];
    
    [self drawTitle:@"注册"];
    
    [self creatUI];
    
}
- (void)creatUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f5f8"];
    
    self.emailTextF = [self creatTextFieldWithPlaceHolder:@"填写常用邮箱" Frame:
                       CGRectMake(10, 40, SCREENWIDTH - 20, 40)];
    
    self.userNameTextF
    = [self creatTextFieldWithPlaceHolder:@"填写用户名，长度为2-15个字符"
                                    Frame:CGRectMake(10, 90, SCREENWIDTH - 20, 40)];
    
    self.passWordTextF
    = [self creatTextFieldWithPlaceHolder:@"填写密码，最小长度为6个字符"
                                    Frame:CGRectMake(10, 140, SCREENWIDTH -20, 40)];
    
    self.registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 140 +40 +24, SCREENWIDTH - 20, 44) RedBackGroundColorAndTitle:@"注册"];
    [self.view addSubview: self.registerBtn];
    [self.registerBtn addTarget:self action:@selector(userRegister) forControlEvents:UIControlEventTouchUpInside];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userRegister{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    [manger POST:[BERApiProxy urlWithAction:[self getMainActionName]] parameters:[BERApiProxy paramsWithDataDic:[self getParams] action:[self getActionName]]
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if ([[responseObject objectForKey:@"code"] intValue] == 0) {
                 NSDictionary * dic = [responseObject objectForKey:@"data"];
                 [[BERUserManger shareMangerUserInfo] configModelValueWithDic:dic];
                 [LMToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"注册成功" duration:1.0f];
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
                         str = @"用户已存在";
                         break;
                     case -3:
                         str = @"用户名不合法";
                         break;
                     case -4:
                         str = @"包含要允许注册的词语";
                         break;
                     case -6:
                         str = @"Email 格式有误";
                         break;
                     case -7:
                         str = @"Email 不允许注册";
                         break;
                     case -8:
                         str = @"该 Email 已经被注册";
                         break;
                     case -9:
                         str = @"其他错误";
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
                              @"username":self.userNameTextF.text,
                              @"password":self.passWordTextF.text,
                              @"email"   :self.emailTextF.text
                              };
    return params;
}
- (NSString *)getActionName{
    return @"register";
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
    [self.userNameTextF resignFirstResponder];
}
@end
