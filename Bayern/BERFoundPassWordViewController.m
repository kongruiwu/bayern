//
//  BERFoundPassWordViewController.m
//  Bayern
//
//  Created by wurui on 15/10/25.
//  Copyright © 2015年 Wusicong. All rights reserved.
//

#import "BERFoundPassWordViewController.h"
#import "BERHeadFile.h"


@interface BERFoundPassWordViewController ()

@property (nonatomic, strong) UITextField * emailTextF;

@property (nonatomic, strong) UITextField * userNameTextF;

@property (nonatomic, strong) UIButton    * getPwdButton;

@end

@implementation BERFoundPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawBackButton];
    
    [self drawTitle:@"找回密码"];
    
    [self creatUI];
    // Do any additional setup after loading the view.
}
- (void)creatUI{
    self.emailTextF = [self creatTextFieldWithPlaceHolder:@"邮箱" Frame:CGRectMake(10, 40, SCREENWIDTH - 20, 40)];
    
    self.userNameTextF = [self creatTextFieldWithPlaceHolder:@"用户名" Frame:CGRectMake(10, 90, SCREENWIDTH - 20, 40)];
    
    self.getPwdButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 140, SCREENWIDTH - 20, 44) RedBackGroundColorAndTitle:@"找回密码"];
    
    [self.view addSubview:self.getPwdButton];
    
    [self.getPwdButton addTarget: self action:@selector(getBackPassWord) forControlEvents:UIControlEventTouchUpInside];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)getBackPassWord{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    [manger POST:[BERApiProxy urlWithAction:[self getMainActionName]] parameters:[BERApiProxy paramsWithDataDic:[self getParams] action:[self getActionName]]
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];

             if ([[responseObject objectForKey:@"code"] intValue] == 0) {
                 [LMToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"密码找回申请成功" duration:1.0f];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self doBack];
                 });
             }else{
                 NSString * str;
                 switch ([[responseObject objectForKey:@"code"] intValue]) {
                     case -1:
                         str = @"请填写完整信息";
                         break;
                     case -2:
                         str = @"Email 格式有误";
                         break;
                     case -3:
                         str = @"密码错误";
                         break;
                     case -4:
                         str = @"用户不存在";
                         break;
                     case -5:
                         str = @"账号与邮箱不匹配";
                         break;
                     case -6:
                         str = @"操作失败";
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
                              @"email":self.emailTextF.text
                              };
    return params;
}
- (NSString *)getActionName{
    return @"getRecode";
}

- (void)doBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.emailTextF resignFirstResponder];
    [self.userNameTextF resignFirstResponder];
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
