//
//  BERStandingTableViewCell.m
//  Bayern
//
//  Created by 吴孔锐 on 15/7/22.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERStandingTableViewCell.h"
#import "Factory.h"
@implementation BERStandingTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
}
-(void)creatUI
{
    for (int i=0; i<3; i++) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0+SCREENWIDTH/3*i,0, SCREENWIDTH/3, Anno750(88))];
        view.tag=1200+i;
        [self.contentView addSubview:view];
    }
    
    fristView = (UIView *)[self.contentView viewWithTag:1200];
    secondView= (UIView *)[self.contentView viewWithTag:1201];
    thirdView = (UIView *)[self.contentView viewWithTag:1202];
    
    rankLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, Anno750(30), 15, Anno750(40))];
    rankLabel.font=[UIFont systemFontOfSize:font750(24)];
    rankLabel.textColor=[UIColor colorWithHexString:@"444444"];
    rankLabel.textAlignment=NSTextAlignmentCenter;
    [fristView addSubview:rankLabel];
    
    iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(rankLabel.frame.origin.x+rankLabel.frame.size.width+Anno750(20), Anno750(30), 20, Anno750(40))];
    [fristView addSubview:iconImg];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconImg.frame.size.width+iconImg.frame.origin.x+Anno750(20), Anno750(30), fristView.frame.size.width-iconImg.frame.size.width-iconImg.frame.origin.x, Anno750(40))];
    nameLabel.font=[UIFont systemFontOfSize:Anno750(24)];
    nameLabel.textColor=[UIColor colorWithHexString:@"444444"];
    [fristView addSubview:nameLabel];
    
    for (int i=0; i<3; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0+i*secondView.frame.size.width/3, Anno750(30), secondView.frame.size.width/3, Anno750(40))];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:Anno750(24)];
        label.textColor=[UIColor colorWithHexString:@"444444"];
        label.tag=1110+i;
        [secondView addSubview:label];
    }
    winLabel=(UILabel *)[self.contentView viewWithTag:1110];
    drawLabel=(UILabel *)[self.contentView viewWithTag:1111];
    lostLabel=(UILabel *)[self.contentView viewWithTag:1112];
    
    for (int i=0; i<2; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0+i*thirdView.frame.size.width/2, Anno750(30), thirdView.frame.size.width/2, Anno750(40))];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:Anno750(24)];
        label.textColor=[UIColor colorWithHexString:@"444444"];
        label.tag=1120+i;
        [thirdView addSubview:label];
    }
    hitLabel = (UILabel *)[self.contentView viewWithTag:1120];
    scoreLabel = (UILabel *)[self.contentView viewWithTag:1121];
    
    lineView=[[UIView alloc]initWithFrame:CGRectMake(Anno750(20), Anno750(98), SCREENWIDTH-20, 1)];
    lineView.backgroundColor=[UIColor colorWithHexString:@"eeeeee"];
    [self addSubview:lineView];
}

-(void)configUIWithModel:(BERStandModel *)model
{
    if (model.isBer) {
        self.contentView.backgroundColor= COLOR_MAIN_RED;
        rankLabel.textColor=[UIColor whiteColor];
        nameLabel.textColor=[UIColor whiteColor];
        winLabel.textColor=[UIColor whiteColor];
        drawLabel.textColor=[UIColor whiteColor];
        lostLabel.textColor=[UIColor whiteColor];
        hitLabel.textColor=[UIColor whiteColor];
        scoreLabel.textColor=[UIColor whiteColor];
        lineView.backgroundColor=COLOR_MAIN_RED;
    }else
    {
        self.contentView.backgroundColor=[UIColor whiteColor];
        rankLabel.textColor=[UIColor blackColor];
        nameLabel.textColor=[UIColor blackColor];
        winLabel.textColor=[UIColor blackColor];
        drawLabel.textColor=[UIColor blackColor];
        lostLabel.textColor=[UIColor blackColor];
        hitLabel.textColor=[UIColor blackColor];
        scoreLabel.textColor=[UIColor blackColor];
        lineView.backgroundColor=[UIColor colorWithHexString:@"eeeeee"];
    }
    rankLabel.text=[NSString stringWithFormat:@"%@",model.rank_index];
    [iconImg sd_setImageWithURL:[NSURL URLWithString:model.team_logo] placeholderImage:nil];
    nameLabel.text=[NSString stringWithFormat:@"%@",model.name_zh];
    winLabel.text=[NSString stringWithFormat:@"%@",model.win];
    drawLabel.text=[NSString stringWithFormat:@"%@",model.draw];
    lostLabel.text=[NSString stringWithFormat:@"%@",model.lost];
    hitLabel.text=[NSString stringWithFormat:@"%@/%@",model.hits,model.miss];
    scoreLabel.text=[NSString stringWithFormat:@"%@",model.score];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
