//
//  LogBackGroundView.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/8.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "LogBackGroundView.h"

@implementation LogBackGroundView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.groundView = [Factory creatViewWithColor:COLOR_BACK_ALPHA_8];
    [self addSubview:self.groundView];
    
    self.icon = [Factory creatImageViewWithImageName:@"Logo_big"];
    [self addSubview:self.icon];
    
    self.ChNameLabel = [Factory creatLabelWithTitle:@"拜仁慕尼黑"
                                              textColor:[UIColor whiteColor]
                                               textFont:font750(46) textAlignment:NSTextAlignmentCenter];
    self.ChNameLabel.font = [UIFont boldSystemFontOfSize:font750(46)];
    [self addSubview:self.ChNameLabel];
    
    self.EnNameLabel = [Factory creatLabelWithTitle:@"FC Bayern Munchen"
                                                textColor:[UIColor whiteColor]
                                                 textFont:font750(28)
                                            textAlignment:NSTextAlignmentCenter];
    self.EnNameLabel.font = [UIFont boldSystemFontOfSize:font750(26)];
    [self addSubview:self.EnNameLabel];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.groundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(40)));
        make.right.equalTo(@(-Anno750(40)));
        make.top.equalTo(@(Anno750(100)));
        make.bottom.equalTo(@0);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.centerX.equalTo(@0);
        make.width.height.equalTo(@(Anno750(200)));
    }];
    [self.ChNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.icon.mas_bottom).offset(Anno750(40));
    }];
    [self.EnNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ChNameLabel.mas_bottom).offset(Anno750(10));
        make.centerX.equalTo(@0);
    }];
}
@end
