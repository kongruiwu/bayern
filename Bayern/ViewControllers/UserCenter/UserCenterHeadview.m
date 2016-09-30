//
//  UserCenterHeadview.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/3.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "UserCenterHeadview.h"

@implementation UserCenterHeadview

- (instancetype)initWithFrame:(CGRect)frame{
    self =  [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.topImageView = [Factory creatImageViewWithImageName:@"regist_back"];
    [self addSubview:self.topImageView];

    
    self.userIcon = [Factory creatImageViewWithImageName:@"porfile_avatar"];
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.cornerRadius = Anno750(80);
    [self addSubview:self.userIcon];
    
    UILabel * nameLabel = [Factory creatLabelWithTitle:@"阿里卡卡" textColor:COLOR_MAIN_RED
                                              textFont:font750(30) textAlignment:NSTextAlignmentCenter];
    [self addSubview:nameLabel];
    self.userName = nameLabel;
    UILabel * timeLabel = [Factory creatLabelWithTitle:@"注册时时：2016-08－12"
                                             textColor:COLOR_CONTENT_GRAY_9 textFont:font750(24)
                                         textAlignment:NSTextAlignmentCenter];
    self.timeLabel = timeLabel;
    [self addSubview:timeLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@(Anno750(200)+64));
    }];
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topImageView.mas_bottom);
        make.centerX.equalTo(@0);
        make.width.height.equalTo(@(Anno750(160)));
    }];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userIcon.mas_bottom).offset(Anno750(30));
        make.centerX.equalTo(@0);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userName.mas_bottom).offset(Anno750(30));
        make.centerX.equalTo(@0);
    }];
}
- (void)updateUI{
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:[UserInfo defaultInfo].avatar] placeholderImage:[UIImage imageNamed:@"porfile_avatar"]];
    self.userName.text = [UserInfo defaultInfo].username;
    self.timeLabel.text = [NSString stringWithFormat:@"注册时间：%@",[UserInfo defaultInfo].reg_date];
}
@end
