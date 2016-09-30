//
//  LeftRootScoreTableViewCell.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/17.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "LeftRootScoreTableViewCell.h"

@implementation LeftRootScoreTableViewCell

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
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)creatUI{
    self.countLabel = [Factory creatLabelWithTitle:@"1"
                                         textColor:[UIColor whiteColor] textFont:font750(28)
                                     textAlignment:NSTextAlignmentCenter];
    self.icon = [Factory creatImageViewWithImageName:@"logo"];
    self.nameLabel = [Factory creatLabelWithTitle:@"拜仁"
                                        textColor:[UIColor whiteColor] textFont:font750(28) textAlignment:NSTextAlignmentLeft];
    self.winScoreLabel = [Factory creatLabelWithTitle:@"20/4/12"
                                            textColor:[UIColor whiteColor] textFont:font750(28) textAlignment:NSTextAlignmentCenter];
    self.ballCountLabel = [Factory creatLabelWithTitle:@"23/12"
                                             textColor:[UIColor whiteColor] textFont:font750(28) textAlignment:NSTextAlignmentCenter];
    self.scoreLabel = [Factory creatLabelWithTitle:@"73"
                                         textColor:[UIColor whiteColor] textFont:font750(28) textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.winScoreLabel];
    [self.contentView addSubview:self.ballCountLabel];
    [self.contentView addSubview:self.scoreLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@((Anno750(20))));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(30)));
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countLabel.mas_right).offset(Anno750(5));
        make.centerY.equalTo(@0);
        make.height.width.equalTo(@(Anno750(50)));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(Anno750(15));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(150)));
    }];
    [self.winScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right);
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(140)));
    }];
    [self.ballCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.winScoreLabel.mas_right);
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(140)));
    }];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ballCountLabel.mas_right);
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(100)));
    }];
}
- (void)updateWithTeamRankModel:(TeamRankModel *)model{
    self.nameLabel.text = model.name_zh;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.team_logo] placeholderImage:[UIImage imageNamed:@"logoDefalut"]];
    self.winScoreLabel.text = model.winString;
    self.ballCountLabel.text = model.basllNumberStr;
    self.scoreLabel.text = [NSString stringWithFormat:@"%@",model.score];
    self.countLabel.text = [NSString stringWithFormat:@"%@",model.rank_index];
    if (model.isHomeTeam) {
        self.backgroundColor = COLOR_MAIN_RED;
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
}
@end
