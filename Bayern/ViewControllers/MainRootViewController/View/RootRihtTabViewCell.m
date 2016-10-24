//
//  RootRihtTabViewCell.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/21.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "RootRihtTabViewCell.h"

@implementation RootRihtTabViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor= [UIColor clearColor];
    }
    return self;
}
- (void)creatUI{

    self.dayTimeLable = [Factory creatLabelWithTitle:@"2015-3-11"
                                           textColor:[UIColor whiteColor] textFont:font750(26)
                                       textAlignment:NSTextAlignmentCenter];
    self.homeIcon = [Factory creatImageViewWithImageName:@"logoDefalut"];
    self.awayIcon = [Factory creatImageViewWithImageName:@"logoDefalut"];
    self.homeLabel= [Factory creatLabelWithTitle:@"拜仁慕尼黑"
                                       textColor:[UIColor whiteColor] textFont:font750(26)
                                   textAlignment:NSTextAlignmentCenter];
    self.awayLabel = [Factory creatLabelWithTitle:@"尤文图斯"
                                       textColor:[UIColor whiteColor] textFont:font750(26)
                                   textAlignment:NSTextAlignmentCenter];
    self.scoreLabel = [Factory creatLabelWithTitle:@"5:0"
                                         textColor:[UIColor whiteColor] textFont:font750(50)
                                     textAlignment:NSTextAlignmentCenter];
    self.halfScoreLabel = [Factory creatLabelWithTitle:@"3:0"
                                             textColor:COLOR_CONTENT_GRAY_9 textFont:font750(26)
                                         textAlignment:NSTextAlignmentCenter];
    self.detailButton = [Factory creatButtonWithTitle:@"本场战报" textFont:font750(30)
                                           titleColor:[UIColor whiteColor] backGroundColor:COLOR_MAIN_RED];
    self.detailButton.layer.cornerRadius = Anno750(30);
    
    self.infoLabel = [Factory creatLabelWithTitle:@"CCTV  虎扑体育  五星体育"
                                        textColor:COLOR_CONTENT_GRAY_9 textFont:font750(26)
                                    textAlignment:NSTextAlignmentCenter];
    self.newsButton = [Factory creatButtonWithTitle:@"战报"
                                           textFont:font750(30) titleColor:COLOR_MAIN_RED
                                    backGroundColor:[UIColor clearColor]];
    self.picButton = [Factory creatButtonWithTitle:@"图集" textFont:font750(30)
                                        titleColor:COLOR_MAIN_RED backGroundColor:[UIColor clearColor]];
    
    self.newsButton.layer.cornerRadius = Anno750(30);
    self.picButton.layer.cornerRadius = Anno750(30);
    self.newsButton.layer.borderColor = COLOR_MAIN_RED.CGColor;
    self.picButton.layer.borderColor = COLOR_MAIN_RED.CGColor;
    self.newsButton.layer.borderWidth = 1.0f;
    self.picButton.layer.borderWidth = 1.0f;
    
    self.infoLabel.hidden = YES;
    self.detailButton.hidden = YES;
    self.newsButton.hidden = YES;
    self.picButton.hidden = YES;
    
    [self.detailButton addTarget:self action:@selector(newsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.newsButton addTarget:self action:@selector(newsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.picButton addTarget:self action:@selector(picButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.bottomLine = [Factory creatViewWithColor:COLOR_CONTENT_GRAY_9];
    [self.contentView addSubview:self.dayTimeLable];
    [self.contentView addSubview:self.homeLabel];
    [self.contentView addSubview:self.homeIcon];
    [self.contentView addSubview:self.awayLabel];
    [self.contentView addSubview:self.awayIcon];
    [self.contentView addSubview:self.scoreLabel];
    [self.contentView addSubview:self.halfScoreLabel];
    [self.contentView addSubview:self.detailButton];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.newsButton];
    [self.contentView addSubview:self.picButton];
    [self.contentView addSubview:self.bottomLine];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.dayTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@(Anno750(50)));
    }];
    
    [self.homeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scoreLabel.mas_left).offset(-Anno750(80));
        make.top.equalTo(self.dayTimeLable.mas_bottom).offset(Anno750(35));
        make.width.height.equalTo(@(Anno750(100)));
    }];
    [self.awayIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreLabel.mas_right).offset(Anno750(80));
        make.top.equalTo(self.dayTimeLable.mas_bottom).offset(Anno750(35));
        make.width.height.equalTo(@(Anno750(100)));
    }];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(self.awayIcon.mas_centerY);
    }];
    [self.homeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.homeIcon.mas_centerX);
        make.top.equalTo(self.homeIcon.mas_bottom).offset(Anno750(30));
    }];
    [self.awayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.awayIcon.mas_centerX);
        make.top.equalTo(self.awayIcon.mas_bottom).offset(Anno750(30));
    }];
    [self.halfScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.homeLabel.mas_centerY);
        make.centerX.equalTo(@0);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.homeLabel.mas_bottom).offset(Anno750(30));
        make.centerX.equalTo(@0);
    }];
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.homeLabel.mas_bottom).offset(Anno750(30));
        make.centerX.equalTo(@0);
        make.width.equalTo(@(Anno750(300)));
        make.height.equalTo(@(Anno750(60)));
    }];
    [self.newsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_centerX).offset(-Anno750(20));
        make.top.equalTo(self.homeLabel.mas_bottom).offset(Anno750(30));
        make.width.equalTo(@(Anno750(200)));
        make.height.equalTo(@(Anno750(60)));
    }];
    [self.picButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset(Anno750(20));
        make.top.equalTo(self.homeLabel.mas_bottom).offset(Anno750(30));
        make.width.equalTo(@(Anno750(200)));
        make.height.equalTo(@(Anno750(60)));
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(20)));
        make.right.equalTo(@(-Anno750(20)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@1);
    }];
}
- (void)updateWithHomeGameModel:(HomeGameModel *)model{
    [self.homeIcon sd_setImageWithURL:[NSURL URLWithString:model.home_logo] placeholderImage:[UIImage imageNamed:@"logoDefalut"]];
    [self.awayIcon sd_setImageWithURL:[NSURL URLWithString:model.away_logo] placeholderImage:[UIImage imageNamed:@"logoDefalut"]];
    NSDate *postDate = [NSDate dateWithTimeIntervalSince1970:[model.match_date_cn doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd   HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:postDate];
    self.dayTimeLable.text =[NSString stringWithFormat:@"%@    %@",model.league_title,dateStr];
    self.homeLabel.text = model.home_name;
    self.awayLabel.text = model.away_name;
    self.scoreLabel.text = [NSString stringWithFormat:@"%@ : %@",model.home_score,model.away_score];
    self.halfScoreLabel.text = model.half_score;
    self.infoLabel.text = model.relay_info;
    BOOL isOver = [self isGameOverWithDate:model.match_date_cn];
    if (isOver) {
        if([model.news_link intValue]>0){
            if ([model.album_link intValue]>0) {
                self.picButton.hidden = NO;
                self.newsButton.hidden = NO;
                self.detailButton.hidden = YES;
                self.infoLabel.hidden = YES;
            }else{
                self.detailButton.hidden = NO;
                self.picButton.hidden = YES;
                self.newsButton.hidden = YES;
                self.infoLabel.hidden = YES;
            }
        }
    }else{
        self.detailButton.hidden = YES;
        self.newsButton.hidden = YES;
        self.picButton.hidden = YES;
        self.infoLabel.hidden = NO;
    }
}
- (void)scheduUpdateWithHomeGameModel:(HomeGameModel *)model{
    [self.homeIcon sd_setImageWithURL:[NSURL URLWithString:model.home_logo] placeholderImage:[UIImage imageNamed:@"logoDefalut"]];
    [self.awayIcon sd_setImageWithURL:[NSURL URLWithString:model.away_logo] placeholderImage:[UIImage imageNamed:@"logoDefalut"]];
    NSDate *postDate = [NSDate dateWithTimeIntervalSince1970:[model.match_date_cn doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd   HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:postDate];
    self.dayTimeLable.text =[NSString stringWithFormat:@"%@    %@",model.league_title,dateStr];
    self.homeLabel.text = model.home_name;
    self.awayLabel.text = model.away_name;
    self.scoreLabel.text = [NSString stringWithFormat:@"%@ : %@",model.home_score,model.away_score];
    self.halfScoreLabel.text = model.half_score;
    self.infoLabel.text = model.relay_info;
    BOOL isOver = [self isGameOverWithDate:model.match_date_cn];
    if (isOver) {
        if([model.news_link intValue]>0){
            if ([model.album_link intValue]>0) {
                self.picButton.hidden = NO;
                self.newsButton.hidden = NO;
                self.detailButton.hidden = YES;
                self.infoLabel.hidden = YES;
            }else{
                self.detailButton.hidden = NO;
                self.picButton.hidden = YES;
                self.newsButton.hidden = YES;
                self.infoLabel.hidden = YES;
            }
        }
    }else{
        self.detailButton.hidden = YES;
        self.newsButton.hidden = YES;
        self.picButton.hidden = YES;
        self.infoLabel.hidden = NO;
    }
    self.dayTimeLable.textColor = COLOR_CONTENT_GRAY_9;
    self.scoreLabel.textColor = [UIColor blackColor];
    self.homeLabel.textColor = [UIColor blackColor];
    self.awayLabel.textColor = [UIColor blackColor];
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
- (void)newsButtonClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(RootRightCellNewsBtnClick:)]) {
        [self.delegate RootRightCellNewsBtnClick:btn];
    }
}
- (void)picButtonClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(RootRightCellPicBtnClick:)]) {
        [self.delegate RootRightCellPicBtnClick:btn];
    }
}
@end
