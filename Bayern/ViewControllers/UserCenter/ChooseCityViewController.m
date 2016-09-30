//
//  ChooseCityViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/26.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "ChooseCityViewController.h"

@interface ChooseCityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tabview;
@end

@implementation ChooseCityViewController
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
    [self drawBackButton];
    [self drawTitle:@"选择地址"];
    [self creatUI];
}
- (void)creatUI{
    
    self.tabview = [Factory creatTabbleViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH - 64) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(90);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID =@"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView * lineview = [Factory creatViewWithColor:COLOR_LINECOLOR];
        [cell addSubview:lineview];
        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.height.equalTo(@1);
        }];
    }
    NSDictionary * dic = self.dataArray[indexPath.row];
    cell.textLabel.text = dic[@"city"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSString * address = [NSString stringWithFormat:@"%@-%@",self.addressPre,dic[@"city"]];
    [self changeUserInfoWithAddress:address];
}
- (void)changeUserInfoWithAddress:(NSString *)address{
    NSNumber * userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    NSString * callBack = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSDictionary * params = @{@"uid":userID,
                              @"callback_verify":callBack,
                              @"field_name":@"area",
                              @"field_value":address};
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:[BERApiProxy urlWithAction:@"user"] parameters:[BERApiProxy paramsWithDataDic:params action:@"profile_update"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        if([dic[@"code"] intValue] == 0){
            [UserInfo defaultInfo].area = address;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:dic[@"msg"] duration:1.0f];
            NSLog(@"%@",dic[@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

@end
