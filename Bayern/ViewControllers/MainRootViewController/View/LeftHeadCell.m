//
//  LeftHeadCell.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/23.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "LeftHeadCell.h"

@implementation LeftHeadCell

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
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

- (void)creatUI{
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.75 * SCREENWIDTH, Anno750(210))];
    selectedView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    UIView *redLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, Anno750(210))];
    redLine.backgroundColor = COLOR_MAIN_RED;
    [selectedView addSubview:redLine];
    self.selectedBackgroundView = selectedView;
    self.UserIcon = [Factory creatImageViewWithImageName:@"leftnav_avatar"];
    self.loginLabel = [Factory creatLabelWithTitle:@"登 录 / 注 册" textColor:COLOR_MAIN_RED textFont:font750(30)
                                     textAlignment:NSTextAlignmentCenter];
    self.UserIcon.layer.masksToBounds = YES;
    self.UserIcon.layer.cornerRadius = Anno750(50);
    [self addSubview:self.UserIcon];
    [self addSubview:self.loginLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.UserIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Anno750(20)));
        make.centerX.equalTo(@0);
        make.height.equalTo(@(Anno750(100)));
        make.width.equalTo(@(Anno750(100)));
    }];
    [self.loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.UserIcon.mas_bottom).offset(Anno750(30));
        make.centerX.equalTo(@0);
    }];
}
- (void)updateStatus{
    NSNumber * userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    if ([UserInfo defaultInfo].username && userID && [UserInfo defaultInfo].username.length>0 && userID.intValue>0) {
        [self.UserIcon sd_setImageWithURL:[NSURL URLWithString:[UserInfo defaultInfo].avatar]];
        self.loginLabel.text = [UserInfo defaultInfo].username;
    }else{
        self.UserIcon.image = [UIImage imageNamed:@"leftnav_avatar"];
        self.loginLabel.text = @"登 录 / 注 册";
    }
}

@end
