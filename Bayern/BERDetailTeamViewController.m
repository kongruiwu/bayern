//
//  BERDetailTeamViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 15/7/28.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERDetailTeamViewController.h"
#import "BERHeadFile.h"
#import "BERTeamerModel.h"
@interface BERDetailTeamViewController ()
{
    UIScrollView *mainScrView;
}
@end

@implementation BERDetailTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view showLoadWithAnimated:YES];
    
    [self drawBackButton];
    [self drawTitle:@"球队"];
    
    [self loadData];
    
    // Do any additional setup after loading the view.
}
-(void)creatMainUIwithModel:(BERTeamerModel *)model
{
    [self initModel:model];
    [self creatUI:model];
}
-(void)initModel:(BERTeamerModel *)model
{
    [self configInfoArrayWithModel:model];
    [self configArrayWithString:model.desc];
}
-(void)creatUI:(BERTeamerModel *)model
{
    mainScrView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    mainScrView.contentSize=CGSizeMake(SCREENWIDTH, (SCREENHEIGHT-64)*2);
    mainScrView.showsHorizontalScrollIndicator=NO;
    mainScrView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:mainScrView];
    
    self.numLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 40, 57)];
    self.numLabel.backgroundColor=[UIColor colorWithHexString:@"e4003a"];
    self.numLabel.textColor=[UIColor whiteColor];
    self.numLabel.textAlignment=NSTextAlignmentCenter;
    self.numLabel.font=[UIFont boldSystemFontOfSize:30.0f];
    if(self.isTeamer){
    self.numLabel.text=[NSString stringWithFormat:@"%@",model.No];
    }else
    {
        self.numLabel.text=@"";
    }
    
    CGFloat cateX=self.numLabel.frame.origin.x+self.numLabel.frame.size.width+10;
    CGFloat cateW=SCREENWIDTH-10-137-cateX-10;
    self.cateLabel=[[UILabel alloc]initWithFrame:CGRectMake(cateX, 15, cateW, 20)];
    self.cateLabel.textColor=[UIColor colorWithHexString:@"999999"];
    self.cateLabel.font=[UIFont boldSystemFontOfSize:14.0f];
    if (self.isTeamer) {
        self.cateLabel.text=model.type;
    }else{
        self.cateLabel.text=model.title;
    }
    CGFloat chinaH=self.cateLabel.frame.origin.y+self.cateLabel.frame.size.height;
    self.chinaName=[[UILabel alloc]initWithFrame:CGRectMake(cateX, chinaH, cateW, 20)];
    self.chinaName.textColor=[UIColor colorWithHexString:@"e4003a"];
    self.chinaName.font=[UIFont boldSystemFontOfSize:16.0f];
    self.chinaName.text=model.name;
    
    CGFloat enlisH=self.chinaName.frame.origin.y+self.chinaName.frame.size.height;
    self.englishName=[[UILabel alloc]initWithFrame:CGRectMake(cateX, enlisH, cateW, 20)];
    self.englishName.textColor=[UIColor colorWithHexString:@"e4003a"];
    self.englishName.font=[UIFont boldSystemFontOfSize:16.0f];
    self.englishName.text=model.name_en;
    if (SCREENWIDTH<330) {
        self.englishName.font=[UIFont boldSystemFontOfSize:14.0f];
        self.chinaName.font=[UIFont boldSystemFontOfSize:14.0f];
    }
    float ImgHeigh=230;
    float ImgWith=ImgHeigh*[model.pic_width intValue]/[model.pic_height intValue];;
    self.teamerImgView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-ImgWith-10, 15, ImgWith,ImgHeigh)];
    [self.teamerImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BER_IMAGE_HOST,model.pic]]];
    
    [mainScrView addSubview:self.numLabel];
    [mainScrView addSubview:self.cateLabel];
    [mainScrView addSubview:self.chinaName];
    [mainScrView addSubview:self.englishName];
    [mainScrView addSubview:self.teamerImgView];
    
    CGFloat lineH=self.teamerImgView.frame.origin.y+self.teamerImgView.frame.size.height;
    UIView *line1View=[[UIView alloc]initWithFrame:CGRectMake(10, lineH, SCREENWIDTH-20, 1)];
    line1View.backgroundColor=[UIColor colorWithHexString:@"111111"];
    [mainScrView addSubview:line1View];
    
    CGFloat introX=line1View.frame.origin.x+20;
    CGFloat introY=line1View.frame.origin.y-20;
    UILabel *introLabel=[[UILabel alloc]initWithFrame:CGRectMake(introX, introY, 100, 20)];
    introLabel.textColor=[UIColor colorWithHexString:@"111111"];
    introLabel.font=[UIFont boldSystemFontOfSize:14.0f];
    introLabel.text=@"个人简介";
    [mainScrView addSubview:introLabel];
    
    NSArray *arrLabel=@[@"出生日期",@"出生地点",@"星座",@"身高/体重/鞋码",@"婚姻状况",@"学历"];
    CGFloat inLabelY=line1View.frame.size.height+line1View.frame.origin.y;
    for (int i=0; i<arrLabel.count; i++) {
        UILabel *inLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 5+5*(i+1)+20*i+inLabelY, 100, 20)];
        inLabel.textColor=[UIColor colorWithHexString:@"999999"];
        inLabel.font=[UIFont boldSystemFontOfSize:12.0f];
        inLabel.text=arrLabel[i];
        inLabel.tag=111+i;
        [mainScrView addSubview:inLabel];
    }
    UILabel *intLabel=(UILabel *)[mainScrView viewWithTag:111];
    
    //球员个人信息
    CGFloat teLabelX=intLabel.frame.origin.x+intLabel.frame.size.width+10;
    for (int i=0; i<self.teamerinfoArray.count; i++) {
        UILabel *teLabel=[[UILabel alloc]initWithFrame:CGRectMake(teLabelX, 5+5*(i+1)+20*i+inLabelY, SCREENWIDTH-teLabelX, 20)];
        teLabel.font=[UIFont systemFontOfSize:12.0f];
        teLabel.textColor=[UIColor colorWithHexString:@"999999"];
        teLabel.text=self.teamerinfoArray[i];
        [mainScrView addSubview:teLabel];
    }
    
    UILabel *int6Label=(UILabel *)[mainScrView viewWithTag:116];
    CGFloat hisLBY=int6Label.frame.size.height+int6Label.frame.origin.y+10;
    UILabel *historyLabel=[[UILabel alloc]initWithFrame:CGRectMake(introX, hisLBY, SCREENWIDTH-introX, 20)];
    historyLabel.textColor=[UIColor colorWithHexString:@"111111"];
    historyLabel.font=[UIFont boldSystemFontOfSize:14.0f];
    
    [mainScrView addSubview:historyLabel];
    
    CGFloat line2Y=historyLabel.frame.size.height+historyLabel.frame.origin.y;
    UIView *line2View=[[UIView alloc]initWithFrame:CGRectMake(10, line2Y, SCREENWIDTH-20, 1)];
    line2View.backgroundColor=[UIColor colorWithHexString:@"111111"];
    [mainScrView addSubview:line2View];
    
    
    
//    if (_isTeamer) {
//        historyLabel.text=@"球员介绍";//球员界面
//        CGFloat barLabelY=line2View.frame.size.height+line2View.frame.origin.y;
//        CGFloat nextY1=[self creatLabelWithTitle:@"前俱乐部"
//                                      andDataArr:self.barArray
//                                       andLabelY:barLabelY];
//        CGFloat nextY2=[self creatLabelWithTitle:@"荣誉"
//                                      andDataArr:self.teamerHonourArray
//                                       andLabelY:nextY1];
//        CGFloat nextY3=[self creatLabelWithTitle:@"加盟拜仁时间/合同到期"
//                                      andDataArr:self.timeArray
//                                       andLabelY:nextY2];
//        mainScrView.contentSize=CGSizeMake(SCREENWIDTH, nextY3);
//
//    }else
//    {
//        historyLabel.text=@"教练介绍";
//        CGFloat coaY=line2View.frame.size.height+line2View.frame.origin.y;
//        CGFloat nextY1=[self creatLabelWithTitle:@"执教生涯"
//                                      andDataArr:self.teachArray
//                                       andLabelY:coaY];
//        CGFloat nextY2=[self creatLabelWithTitle:@"执教荣誉"
//                                      andDataArr:self.coaHonourArray
//                                       andLabelY:nextY1];
//        CGFloat nextY3=[self creatLabelWithTitle:@"球员生涯"
//                                      andDataArr:self.teamerLifeArray
//                                       andLabelY:nextY2];
//        CGFloat nextY4=[self creatLabelWithTitle:@"球员荣誉"
//                                      andDataArr:self.teamerHonourArray
//                                       andLabelY:nextY3];
//        CGFloat nextY5=[self creatLabelWithTitle:@"加盟拜仁时间/合同到期"
//                                      andDataArr:self.timeArray
//                                       andLabelY:nextY4];
//        mainScrView.contentSize=CGSizeMake(SCREENWIDTH, nextY5);
//    }
    if (_isTeamer) {
        historyLabel.text=@"球员介绍";
    }else{
        historyLabel.text=@"教练介绍";
    }
    float originY = line2View.frame.size.height+line2View.frame.origin.y;
    
    CGSize size = [Util_UI sizeOfString:model.desc maxWidth:SCREENWIDTH -20 withFontSize:12.0f];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(30, originY + 10, SCREENWIDTH - 40, size.height)];
    label.numberOfLines = 0;
    label.text = model.desc;
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor=[UIColor colorWithHexString:@"999999"];
    [mainScrView addSubview:label];
    mainScrView.contentSize = CGSizeMake(SCREENWIDTH, originY + size.height +20);
    [self.view hideLoadWithAnimated:YES];
}


-(void)loadData
{
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:[BERApiProxy urlWithAction:[self getMainActionName]] parameters:[BERApiProxy paramsWithDataDic:[self getParamWithIsTeamer:self.isTeamer] action:[self getActionName]] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic=[responseObject objectForKey:@"data"];
        
        BERTeamerModel *model=[[BERTeamerModel alloc]init];
        
        [model setValuesForKeysWithDictionary:dic];
        
        [self creatMainUIwithModel:model];
        
        NSLog(@"球员数据解析成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"球员数据解析失败");
    }];
}
-(NSDictionary *)getParamWithIsTeamer:(BOOL)rec
{
    if (rec) {
        NSDictionary *param=@{
                              @"id":self.teamerID,
                        @"is_coach":@"0"
                              };
        return param;
    }
    NSDictionary *param=@{
                          @"id":self.teamerID,
                          @"is_coach":@"1"
                          };
    return param;
}
-(NSString *)getActionName
{
    return @"get_detail";
}
-(NSString *)getMainActionName
{
    return @"team";
}
-(void)configInfoArrayWithModel:(BERTeamerModel *)model
{
    NSString *birthdays=model.birthday;
    NSString *birthplace=model.birthplace;
    NSString *zodiac=model.zodiac;
    NSString *info=[NSString stringWithFormat:@"%@/%@/%@",model.height,model.weight,model.shoesize];
    NSString *family=model.family;
    NSString *edu=model.edu;
    self.teamerinfoArray=@[birthdays,birthplace,zodiac,info,family,edu];
}

-(void)configArrayWithString:(NSString *)desc
{
    NSArray * arr = [desc componentsSeparatedByString:@"\r\n"];
    self.descArray = arr;
}
-(NSArray *)configWithArray:(NSArray *)arr
{
    NSMutableArray *arr1=[NSMutableArray arrayWithArray:arr];
    [arr1 removeObjectAtIndex:0];
    NSArray *arr2=[NSArray arrayWithArray:arr1];
    return arr2;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
