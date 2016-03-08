//
//  BERFixtureTableViewCell.m
//  Bayern
//
//  Created by 吴孔锐 on 15/7/23.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERFixtureTableViewCell.h"
#import "BERHeadFile.h"
@implementation BERFixtureTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI
{
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, SCREENWIDTH, 20)];
    titleLabel.textColor=[UIColor colorWithHexString:@"999999"];
    titleLabel.font=[UIFont systemFontOfSize:14.0f];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    
    CGFloat halfWith=SCREENWIDTH/2;
    CGFloat imgOriginH=titleLabel.frame.size.height+titleLabel.frame.origin.y+20;
    homeImgView=[[UIImageView alloc]initWithFrame:CGRectMake((halfWith-40-15)/2+15, imgOriginH, 40, 40)];
    [self.contentView addSubview:homeImgView];
    
    CGFloat awayIconX=SCREENWIDTH-homeImgView.frame.origin.x-40;
    awayImgView=[[UIImageView alloc]initWithFrame:CGRectMake(awayIconX, imgOriginH, 40, 40)];
    [self.contentView addSubview:awayImgView];
    
    CGFloat matchX=homeImgView.frame.size.width+homeImgView.frame.origin.x;
    CGFloat matchW=SCREENWIDTH-2*matchX;
    matchScoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(matchX, imgOriginH, matchW, 30)];
    matchScoreLabel.textColor=[UIColor colorWithHexString:@"444444"];
    matchScoreLabel.font=[UIFont systemFontOfSize:28.0f];
    matchScoreLabel.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:matchScoreLabel];
    
    CGFloat halfScoreX=(SCREENWIDTH-60)/2;
    CGFloat halfScoreY=matchScoreLabel.frame.size.height+matchScoreLabel.frame.origin.y+15;
    halfScoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(halfScoreX, halfScoreY, 60, 20)];
    halfScoreLabel.textColor=[UIColor colorWithHexString:@"999999"];
    halfScoreLabel.textAlignment=NSTextAlignmentCenter;
    halfScoreLabel.font=[UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:halfScoreLabel];
    
    CGFloat homeNameX=45;
    CGFloat homeNameW=SCREENWIDTH/2-30-45;
    homeNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(homeNameX, halfScoreY, homeNameW, 20)];
    homeNameLabel.textAlignment=NSTextAlignmentCenter;
    homeNameLabel.textColor=[UIColor colorWithHexString:@"444444"];
    homeNameLabel.font=[UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:homeNameLabel];
    
    CGFloat awayNameX=SCREENWIDTH/2+30;
    awayNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(awayNameX, halfScoreY, homeNameW, 20)];
    awayNameLabel.textColor=[UIColor colorWithHexString:@"444444"];
    awayNameLabel.textAlignment=NSTextAlignmentCenter;
    awayNameLabel.font=[UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:awayNameLabel];
    
    CGFloat replayY=homeNameLabel.frame.size.height+10+homeNameLabel.frame.origin.y;
    relay_infoLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, replayY, SCREENWIDTH, 20)];
    relay_infoLabel.textAlignment=NSTextAlignmentCenter;
    relay_infoLabel.textColor=[UIColor colorWithHexString:@"999999"];
    relay_infoLabel.font=[UIFont systemFontOfSize:14.0f];
    
    CGFloat newsX=SCREENWIDTH/2-15-90;
    CGFloat newsY=homeNameLabel.frame.size.height+homeNameLabel.frame.origin.y+20;
    //单独 本地战报BTN
    self.onceButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.onceButton.frame=CGRectMake((SCREENWIDTH-120)/2, newsY, 120, 30);
    [self.onceButton setBackgroundImage:[UIImage imageNamed:@"button-1"] forState:UIControlStateNormal];
    [self.onceButton setBackgroundImage:[UIImage imageNamed:@"button-2"] forState:UIControlStateHighlighted];
    [self.onceButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    self.onceButton.layer.masksToBounds=YES;
    self.onceButton.layer.cornerRadius=15.0f;
    self.onceButton.tag=10002;
    
    
    
    newsButton=[UIButton buttonWithType:UIButtonTypeCustom];
    newsButton.frame=CGRectMake(newsX, newsY, 90, 30 );
    [newsButton setBackgroundImage:[UIImage imageNamed:@"buttonunSelect"] forState:UIControlStateNormal];
    [newsButton setBackgroundImage:[UIImage imageNamed:@"buttonSelect"] forState:UIControlStateHighlighted];
    [newsButton setTitle:@"战报" forState:UIControlStateNormal];
    [newsButton setTitleColor:[UIColor colorWithHexString:@"e4003a"] forState:UIControlStateNormal];
    [newsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [newsButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    albumButton=[UIButton buttonWithType:UIButtonTypeCustom];
    albumButton.frame=CGRectMake(SCREENWIDTH/2+15, newsY, 90, 30);
    [albumButton setBackgroundImage:[UIImage imageNamed:@"buttonunSelect"] forState:UIControlStateNormal];
    [albumButton setBackgroundImage:[UIImage imageNamed:@"buttonSelect"] forState:UIControlStateHighlighted];
    [albumButton setTitleColor:[UIColor colorWithHexString:@"e4003a"] forState:UIControlStateNormal];
    [albumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [albumButton setTitle:@"图集" forState:UIControlStateNormal];
    [albumButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    newsButton.layer.masksToBounds=YES;
    newsButton.layer.cornerRadius=15.0f;
    newsButton.tag=10000;
    albumButton.tag=10001;
    albumButton.layer.masksToBounds=YES;
    albumButton.layer.cornerRadius=15.0f;

    
    newsButton.titleLabel.font=[UIFont boldSystemFontOfSize:15.0f];
    albumButton.titleLabel.font=[UIFont boldSystemFontOfSize:15.0f];
    
    self.detailButton=newsButton;
    self.pictureButton=albumButton;
    self.relayLabel=relay_infoLabel;
    
    lastLine=[[UIView alloc]init];
    lastLine.backgroundColor=[UIColor colorWithHexString:@"eeeeee"];
    [self.contentView addSubview:lastLine];
    
}
-(void)btnClick:(UIButton *)btn
{
    if (btn.tag==10000||btn.tag==10002) {
        if ([self.delegat respondsToSelector:@selector(BERFixtureBtnClickWith:)]) {
            [self.delegat BERFixtureBtnClickWith:self.model1];
        }
    }else if(btn.tag==10001)
    {
        if([self.delegat respondsToSelector:@selector(BERFixturePicBtnClickWith:)]){
            [self.delegat BERFixturePicBtnClickWith:self.model1];
        }
    }
    
}
-(void)configUIwithModel:(BERFixtureModel *)model
{
    NSDate *postDate = [NSDate dateWithTimeIntervalSince1970:[model.match_date_cn doubleValue]];
    self.model1=model;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd   HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:postDate];
    titleLabel.text=[NSString stringWithFormat:@"%@   %@",model.league_title,dateStr];
    
    [homeImgView sd_setImageWithURL:[NSURL URLWithString:model.home_logo] placeholderImage:nil];
    [awayImgView sd_setImageWithURL:[NSURL URLWithString:model.away_logo] placeholderImage:nil];
    
    matchScoreLabel.text=[NSString stringWithFormat:@"%@ : %@",model.home_score,model.away_score];
    
    homeNameLabel.text=model.home_name;
    awayNameLabel.text=model.away_name;
    
    halfScoreLabel.text=[NSString stringWithFormat:@"(%@)",model.half_score];
    
    self.relayLabel.text=model.relay_info;
    //self.relayLabel.text=@"CCTV   虎扑体育   五星体育";
    BOOL rec=[self gameStatus:model];
    if (rec) {
        [self removeAllview];
        if ([model.album_link intValue]==0) {
            [self.contentView addSubview:self.onceButton];
            lastLine.frame=CGRectMake(5, self.onceButton.frame.size.height+self.onceButton.frame.origin.y+20, SCREENWIDTH-10, 1);
        }else{
        [self.contentView addSubview:self.detailButton];
        [self.contentView addSubview:self.pictureButton];
        lastLine.frame=CGRectMake(5, newsButton.frame.size.height+newsButton.frame.origin.y+20, SCREENWIDTH-10, 1);
        }
    }else
    {
        [self removeAllview];
        [self.contentView addSubview:self.relayLabel];
        lastLine.frame=CGRectMake(5, relay_infoLabel.frame.size.height+relay_infoLabel.frame.origin.y+20, SCREENWIDTH-10, 1);
    }
}
-(void)removeAllview
{
    [self.onceButton removeFromSuperview];
    [self.detailButton removeFromSuperview];
    [self.pictureButton removeFromSuperview];
    [self.relayLabel removeFromSuperview];
}
-(BOOL)gameStatus:(BERFixtureModel *)model
{
    int num=[model.game_status intValue];
    if (num==0) {
        return NO;
    }
    return YES;
    
}
- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
