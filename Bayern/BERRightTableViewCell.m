//
//  BERRightTableViewCell.m
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERRightTableViewCell.h"
#import "BERHeadFile.h"
@implementation BERRightTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initUI {
    
    CGFloat originY = 20;
    CGFloat originX = (1- [BERMainCenter sharedInstance].sliderPercentage) * WindowWidth;
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, self.sliderWidth, 20)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.font = [UIFont systemFontOfSize:14];
    titleLb.textColor = [UIColor whiteColor];
    titleLb.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = titleLb;
    [self.contentView addSubview:titleLb];
    
    originY += titleLb.frame.size.height + 20;
    
    CGFloat iconGap = 40;
    CGFloat imgW = 40;
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(originX +iconGap, originY, imgW, imgW)];
    self.homeIcon = img;
    self.homeIcon.backgroundColor = [UIColor clearColor];
    self.homeIcon.contentMode = UIViewContentModeScaleAspectFill;
    img.clipsToBounds = YES;
    [self.contentView addSubview:img];
    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(originX +self.sliderWidth - iconGap - imgW, originY, imgW, imgW)];
    self.awayIcon = img2;
    self.awayIcon.backgroundColor = [UIColor clearColor];
    self.awayIcon.contentMode = UIViewContentModeScaleAspectFill;
    img2.clipsToBounds = YES;
    [self.contentView addSubview:img2];
    
    UILabel *scLb = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, self.sliderWidth, imgW)];
    scLb.backgroundColor = [UIColor clearColor];
    scLb.textColor = [UIColor whiteColor];
    self.scoreLabel = scLb;
    scLb.textAlignment = NSTextAlignmentCenter;
    scLb.font = [UIFont systemFontOfSize:28];
    [self.contentView addSubview:scLb];
    
    originY += self.homeIcon.frame.size.height + 20;
    
    CGFloat teamLbW = self.sliderWidth /3;
    CGFloat teamNameLbW = imgW + 30;
    UILabel *homeLb = [[UILabel alloc] initWithFrame:CGRectMake(img.frame.origin.x-15, originY, teamNameLbW, 20)];
    homeLb.backgroundColor = [UIColor clearColor];
    homeLb.font = [UIFont systemFontOfSize:14];
    homeLb.textColor = [UIColor whiteColor];
    self.homeLabel = homeLb;
    homeLb.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:homeLb];
    
    UILabel *homeLb2 = [[UILabel alloc] initWithFrame:CGRectMake(img2.frame.origin.x - 15, originY, teamNameLbW, 20)];
    homeLb2.backgroundColor = [UIColor clearColor];
    homeLb2.font = [UIFont systemFontOfSize:14];
    homeLb2.textColor = [UIColor whiteColor];
    self.awayLabel = homeLb2;
    homeLb2.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:homeLb2];
    
    UILabel *ssLb = [[UILabel alloc] initWithFrame:CGRectMake(originX +teamLbW, originY, teamLbW, 20)];
    ssLb.backgroundColor = [UIColor clearColor];
    ssLb.font = [UIFont systemFontOfSize:14];
    ssLb.textColor = [UIColor colorWithHex:0x999999 alpha:1];
    self.scoreSmallLabel = ssLb;
    ssLb.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:ssLb];
    
    originY += self.homeLabel.frame.size.height + 20;
    
    //set hidden
    CGFloat btnW = 120;
    CGFloat btnH = 30;
    UIButton *dBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.detailButton = dBtn;
    dBtn.frame = CGRectMake(originX +(self.sliderWidth - btnW)/2, originY, btnW, btnH);
    [dBtn setBackgroundImage:[UIImage imageNamed:@"button-1"] forState:UIControlStateNormal];
    [dBtn setBackgroundImage:[UIImage imageNamed:@"button-2"] forState:UIControlStateHighlighted];
    [dBtn addTarget:self action:@selector(showNews) forControlEvents:UIControlEventTouchUpInside];
    
    //两个Btn
    CGFloat newsX=originX+self.sliderWidth/2-20-70;
    CGFloat newsY=originY;
    UIButton * newsButton=[UIButton buttonWithType:UIButtonTypeCustom];
    newsButton.frame=CGRectMake(newsX, newsY, 70, 30 );
    newsButton.backgroundColor=[UIColor clearColor];
    [newsButton setTitle:@"战报" forState:UIControlStateNormal];
    [newsButton setTitleColor:[UIColor colorWithHexString:@"e4003a"] forState:UIControlStateNormal];
    [newsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [newsButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    newsButton.layer.borderColor=[[UIColor colorWithHexString:@"e4003a"]CGColor];
    newsButton.layer.borderWidth=1.0f;
    [newsButton setBackgroundImage:[UIImage imageNamed:@"buttonSelect"] forState:UIControlStateHighlighted];
    
    UIButton * albumButton=[UIButton buttonWithType:UIButtonTypeCustom];
    albumButton.frame=CGRectMake(newsButton.frame.size.width+newsButton.frame.origin.x+40, newsY, 70, 30);
    newsButton.backgroundColor=[UIColor clearColor];
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
    albumButton.layer.borderColor=[[UIColor colorWithHexString:@"e4003a"]CGColor];
    albumButton.layer.borderWidth=1.0f;
    [albumButton setBackgroundImage:[UIImage imageNamed:@"buttonSelect"] forState:UIControlStateHighlighted];
    newsButton.titleLabel.font=[UIFont boldSystemFontOfSize:15.0f];
    albumButton.titleLabel.font=[UIFont boldSystemFontOfSize:15.0f];
    
    self.newsButton=newsButton;
    self.picButton=albumButton;
    
    
    
    originY += 5;
    
    UILabel *infoLb = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, self.sliderWidth, 20)];
    infoLb.backgroundColor = [UIColor clearColor];
    infoLb.font = [UIFont systemFontOfSize:12];
    infoLb.textColor = [UIColor colorWithHex:0x999999 alpha:1];
    self.infoLabel = infoLb;
    infoLb.textAlignment = NSTextAlignmentCenter;
    
}
-(void)btnClick:(UIButton *)btn
{
    if (btn.tag==10000) {
        [self showNews];
        NSLog(@"%f",self.sliderWidth);
    }else if(btn.tag==10001)
    {
        if ([self.delegate respondsToSelector:@selector(BERRightTableViewCellPicButtonClick:)]) {
            [self.delegate BERRightTableViewCellPicButtonClick:self.index];
        }
    }
}
- (void)cleanCellShow {
    [self.detailButton removeFromSuperview];
    [self.infoLabel removeFromSuperview];
}

- (void)configureCell:(id)dataModel {
    if (![dataModel isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    [self cleanCellShow];
    
    NSDictionary *dic = dataModel;
    
    NSString *requestURL = [NSString stringWithFormat:@"%@", dic[@"home_logo"]];
    [self.homeIcon sd_setImageWithURL:[NSURL URLWithString:requestURL] placeholderImage:nil];
    
    NSString *requestURL2 = [NSString stringWithFormat:@"%@", dic[@"away_logo"]];
    [self.awayIcon sd_setImageWithURL:[NSURL URLWithString:requestURL2] placeholderImage:nil];
    
    
    NSString *leagueStr = dic[@"league_title"];
    
    NSDate *postDate = [NSDate dateWithTimeIntervalSince1970:[dic[@"match_date_cn"] doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd   HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:postDate];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@    %@",leagueStr,dateStr];
    
    self.homeLabel.text = dic[@"home_name"];
    self.awayLabel.text = dic[@"away_name"];
    
    self.scoreSmallLabel.text = [NSString stringWithFormat:@"%@",dic[@"half_score"]];
    self.scoreLabel.text = [NSString stringWithFormat:@"%@ : %@", dic[@"home_score"], dic[@"away_score"]];
    
    BOOL isOver = [self isGameOverWithDate:dic[@"match_date_cn"]];
    
    if (isOver) {
        NSString *news_link = [dic stringValueForKey:@"news_link"];
        
        if (news_link.length > 0 && [news_link integerValue] > 0) {
            //比赛结束且没有图集，显示跳转按钮
            if ([dic[@"album_link"] integerValue]==0 ) {
                [self.contentView addSubview:self.detailButton];
            }else
            {
                [self.contentView addSubview:self.newsButton];
                [self.contentView addSubview:self.picButton];
            }
            
        } else {
            //比赛未开始，显示直播信息
            self.infoLabel.text = [NSString stringWithFormat:@"%@",dic[@"relay_info"]];
            [self.contentView addSubview:self.infoLabel];
        }
    } else {
        //比赛未开始，显示直播信息
        self.infoLabel.text = [NSString stringWithFormat:@"%@",dic[@"relay_info"]];
        [self.contentView addSubview:self.infoLabel];
    }
}

- (BOOL)isGameOverWithDate:(NSString *)dateStr {
    
    NSDate *postDate = [NSDate dateWithTimeIntervalSince1970:[dateStr doubleValue]];
    NSDate *nowDate = [NSDate date];
    
    if ([postDate compare:nowDate] == NSOrderedAscending) {
        //比赛结束
        return YES;
    } else if ([postDate compare:nowDate] == NSOrderedSame || [postDate compare:nowDate] == NSOrderedDescending) {
        return NO;
    }
    
    return YES;
}

- (void)showNews {
    if ([self.delegate respondsToSelector:@selector(BERRightTableViewCellGameButtonClick:)]) {
        [self.delegate BERRightTableViewCellGameButtonClick:self.index];
    }
}

- (void)showCellLineWithHeight:(CGFloat)height color:(UIColor *)color {
    if (self.line == nil) {
        self.line = [[UIView alloc] init];
        self.line.backgroundColor = color;
        [self.contentView addSubview:self.line];
    }
    
    CGFloat originX = (1- [BERMainCenter sharedInstance].sliderPercentage) * WindowWidth;
    self.line.frame = CGRectMake(20+originX, height - 1, self.sliderWidth - 20*2, 1);
}

@end
