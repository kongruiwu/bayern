//
//  CommentTableViewCell.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/14.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)creatUI{
    self.userIcon = [Factory creatImageViewWithImageName:@""];
    self.userName = [Factory creatLabelWithTitle:@"拜你所赐"
                                       textColor:COLOR_CONTENT_GRAY_3 textFont:font750(28)
                                   textAlignment:NSTextAlignmentLeft];
    self.creatTime = [Factory creatLabelWithTitle:@"1天前" textColor:COLOR_CONTENT_GRAY_9 textFont:font750(22) textAlignment:NSTextAlignmentLeft];
    self.likeButton = [Factory creatButtonWithNormalImage:@"agree_nor" selectImage:@"agree_sel"];
    [self.likeButton setTitle:@"87" forState:UIControlStateNormal];
    [self.likeButton setTitleColor:COLOR_CONTENT_GRAY_9 forState:UIControlStateNormal];
    [self.likeButton setTitleColor:COLOR_MAIN_RED forState:UIControlStateSelected];
    [self.likeButton addTarget:self action:@selector(liekBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.likeButton.titleLabel.font = [UIFont systemFontOfSize:font750(22)];
    self.content = [Factory creatLabelWithTitle:@"我仁宇宙最强，拜迷银河最帅！我仁宇宙最强，拜迷银河最帅！"
                                      textColor:COLOR_CONTENT_GRAY_6 textFont:font750(26)
                                  textAlignment:NSTextAlignmentLeft];
    self.content.numberOfLines = 0;
    self.bottomLine = [Factory creatViewWithColor:COLOR_LINECOLOR];
    [self addSubview:self.userIcon];
    [self addSubview:self.userName];
    [self addSubview:self.creatTime];
    [self addSubview:self.likeButton];
    [self addSubview:self.bottomLine];
    [self addSubview:self.content];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(Anno750(40)));
        make.height.equalTo(@(Anno750(60)));
        make.width.equalTo(@(Anno750(60)));
    }];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIcon.mas_right).offset(Anno750(20));
        make.centerY.equalTo(self.userIcon.mas_centerY);
    }];
    [self.creatTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userName.mas_right).offset(Anno750(20));
        make.centerY.equalTo(self.userName.mas_centerY);
    }];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(40)));
        make.height.equalTo(@(Anno750(60)));
        make.centerY.equalTo(self.userName.mas_centerY);
    }];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userName.mas_left);
        make.right.equalTo(@(-Anno750(40)));
        make.top.equalTo(self.userName.mas_bottom).offset(Anno750(30));
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@1);
    }];
}
- (void)updateWithModel:(CommentModel *)model{
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"logoDefalut"]];
    self.userName.text = model.username;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd   HH:mm"];
    NSDate *postDate = [NSDate dateWithTimeIntervalSince1970:[model.time doubleValue]];
    NSString *dateStr = [dateFormatter stringFromDate:postDate];
    NSString * timeString ;
    long timeValue = time(NULL);
    if (timeValue - model.time.longValue > 24 * 60 * 60) {
        int num =(int)(timeValue - model.time.longValue)/(24 * 60 * 60);
        if (num>30) { //大于30天 显示具体时间
            timeString = [dateStr substringFromIndex:10];
        }else{
            timeString = [NSString stringWithFormat:@"%d天前",num];
        }
    }else if(timeValue - model.time.longValue > 1 * 60 * 60){
        int num =(int)(timeValue - model.time.longValue)/(60 * 60);
        timeString = [NSString stringWithFormat:@"%d小时前",num];
    }else if(timeValue - model.time.longValue > 60){
        int num =(int)(timeValue - model.time.longValue)/60;
        timeString = [NSString stringWithFormat:@"%d分钟前",num];
    }else{
        timeString = @"刚刚";
    }
    self.creatTime.text = timeString;
    [self.likeButton setTitle:[NSString stringWithFormat:@"%@",model.good] forState:UIControlStateNormal];
    self.likeButton.selected = model.gooded;

    self.content.text = model.content;
}
- (void)liekBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(commenLikeButtonClick:)]) {
        [self.delegate commenLikeButtonClick:btn];
    }
}
@end
