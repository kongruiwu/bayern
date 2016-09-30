//
//  teamerShowView.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/17.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "teamerShowView.h"

@implementation teamerShowView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.groundView = [Factory creatViewWithColor:COLOR_BACK_ALPHA_5];
    self.teamImage = [Factory creatImageViewWithImageName:@"photos_defult"];
    self.countLabel = [Factory creatLabelWithTitle:@"25"
                                         textColor:[UIColor whiteColor] textFont:font750(24)
                                     textAlignment:NSTextAlignmentCenter];
    self.countLabel.backgroundColor = COLOR_MAIN_RED;
    self.nameView = [Factory creatViewWithColor:COLOR_BACK_ALPHA_3];
    self.namelabel= [Factory creatLabelWithTitle:@"托马斯*穆勒"
                                       textColor:[UIColor whiteColor] textFont:font750(26) textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.groundView];
    [self.groundView addSubview:self.teamImage];
    [self.groundView addSubview:self.countLabel];
    [self.groundView addSubview:self.nameView];
    [self.nameView addSubview:self.namelabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.groundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(@0);
    }];
    [self.teamImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(Anno750(50)));
//        make.right.equalTo(@(-Anno750(50)));
        make.left.right.top.bottom.equalTo(@0);
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(@0);
        make.width.equalTo(@(Anno750(50)));
        make.height.equalTo(@(Anno750(40)));
    }];
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countLabel.mas_right);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@(Anno750(40)));
    }];
    [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(20)));
        make.right.top.bottom.equalTo(@0);
    }];
}
- (void)updateWithHomeTeamerModel:(HomeTeamerModel *)model{
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",model.pic]];
    [self.teamImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"photos_defult"]];
    self.countLabel.text = [NSString stringWithFormat:@"%@",model.number];
    self.namelabel.text = model.name;
}
@end
