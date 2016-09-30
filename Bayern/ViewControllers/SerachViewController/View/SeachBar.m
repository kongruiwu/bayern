//
//  SeachBar.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/13.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "SeachBar.h"

@implementation SeachBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.cateButton = [Factory creatButtonWithTitle:@"新闻" textFont:font750(28) titleColor:COLOR_CONTENT_GRAY_9 backGroundColor:[UIColor clearColor]];
    self.line = [Factory creatViewWithColor:COLOR_CONTENT_GRAY_9];
    self.searchTF = [Factory creatTextFieldWithPlaceHolder:@"搜索" textAlignment:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    self.searchTF.font = [UIFont systemFontOfSize:font750(28)];
    self.searchTF.tintColor = COLOR_MAIN_RED;
    self.bottomIcon = [Factory creatImageViewWithImageName:@"search_select"];
    [self addSubview:self.bottomIcon];
    [self addSubview:self.cateButton];
    [self addSubview:self.line];
    [self addSubview:self.searchTF];
    
    self.searchIcon = [Factory creatImageViewWithImageName:@"nav_search_gray"];
    [self addSubview:self.searchIcon];
    
    self.layer.cornerRadius = Anno750(30);
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.cateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(20)));
        make.width.equalTo(@(Anno750(100)));
        make.top.equalTo(@(Anno750(10)));
        make.bottom.equalTo(@(-Anno750(10)));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cateButton.mas_right).offset(Anno750(20));
        make.top.equalTo(@(Anno750(15)));
        make.bottom.equalTo(@(-Anno750(15)));
        make.width.equalTo(@1);
    }];
    [self.bottomIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line.mas_left).offset(Anno750(5));
        make.centerY.equalTo(@0);
    }];
    [self.searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line.mas_right).offset(Anno750(10));
        make.width.equalTo(@(Anno750(30)));
        make.height.equalTo(@(Anno750(30)));
        make.centerY.equalTo(@0);
    }];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchIcon.mas_right).offset(Anno750(10));
        make.right.equalTo(@(-Anno750(20)));
        make.centerY.equalTo(@0);
    }];
}
@end
