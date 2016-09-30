//
//  ChangeBirthViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/26.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "ChangeBirthViewController.h"

@interface ChangeBirthViewController ()
@property (nonatomic ,strong) UIDatePicker * datePicker;
@property (nonatomic, strong) UILabel * dateLabel;
@property (nonatomic, strong) NSString * date;
@end

@implementation ChangeBirthViewController
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
    [self drawTitle:@"设置生日"];
    [self creatUI];
}
- (void)creatUI{
    UIDatePicker * datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 216)];
    [self.view addSubview:datePicker];
    datePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    datePicker.locale = locale;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:0];//设置最大时间为：当前时间推后十年
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-100];//设置最小时间为：当前时间前推十年
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [datePicker setMaximumDate:maxDate];
    [datePicker setMinimumDate:minDate];
    [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged ];
    self.datePicker = datePicker;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * dateString = [NSString stringWithFormat:@"修改生日为：%@",[dateFormatter stringFromDate:[NSDate date]]];
    self.date = [dateFormatter stringFromDate:[NSDate date]];
    self.dateLabel = [Factory creatLabelWithTitle:dateString
                                        textColor:COLOR_CONTENT_GRAY_3 textFont:font750(32)
                                    textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(datePicker.mas_bottom).offset(Anno750(30));
        make.height.equalTo(@20);
    }];
    
    UIButton * sureButton = [Factory creatButtonWithTitle:@"确定"
                                                 textFont:font750(36)
                                               titleColor:[UIColor whiteColor]
                                          backGroundColor:COLOR_MAIN_RED];
    [self.view addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.right.equalTo(@(-Anno750(30)));
        make.height.equalTo(@(Anno750(100)));
        make.top.equalTo(self.dateLabel.mas_bottom).offset(Anno750(30));
    }];
    [sureButton addTarget:self action:@selector(changeUserInfoWithBirth) forControlEvents:UIControlEventTouchUpInside];
    sureButton.layer.cornerRadius = Anno750(10);
}
- (void)dateChanged{
    NSDate* date = self.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * dateString = [dateFormatter stringFromDate:date];
    self.dateLabel.text = [NSString stringWithFormat:@"修改生日为：%@",dateString];
    self.date = dateString;
}
- (void)changeUserInfoWithBirth{
    NSNumber * userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    NSString * callBack = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSDictionary * params = @{@"uid":userID,
                              @"callback_verify":callBack,
                              @"field_name":@"birth",
                              @"field_value":self.date};
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:[BERApiProxy urlWithAction:@"user"] parameters:[BERApiProxy paramsWithDataDic:params action:@"profile_update"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        if([dic[@"code"] intValue] == 0){
            [UserInfo defaultInfo].birth = self.date;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:dic[@"msg"] duration:1.0f];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
@end
