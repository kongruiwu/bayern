//
//  TeamerDeatilHeadView.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/20.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "TeamerDeatilHeadView.h"

@implementation TeamerDeatilHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    
    self.numberLabel = [self creatLabelWithTitle:@""
                                       textColor:[UIColor whiteColor]
                                        textFont:font750(60) andTextAlignment:NSTextAlignmentCenter];
    self.numberLabel.backgroundColor = COLOR_MAIN_RED;
    self.cateLabel = [self creatLabelWithTitle:@""
                                     textColor:COLOR_CONTENT_GRAY_9 textFont:font750(30)
                              andTextAlignment:NSTextAlignmentLeft];
    self.cnNameLable = [self creatLabelWithTitle:@""
                                       textColor:COLOR_MAIN_RED
                                        textFont:font750(30) andTextAlignment:NSTextAlignmentLeft];
    self.enNameLabel = [self creatLabelWithTitle:@"" textColor:COLOR_MAIN_RED
                                        textFont:font750(30) andTextAlignment:NSTextAlignmentLeft];
    self.icon = [Factory creatImageViewWithImageName:@"photos_defult"];
    self.bottomLine = [Factory creatViewWithColor:UIColorFromRGB(0x111111)];
    self.bottomTitle = [self creatLabelWithTitle:@"个人简介"
                                       textColor:[UIColor blackColor] textFont:font750(28) andTextAlignment:NSTextAlignmentLeft];
    [self addSubview:self.numberLabel];
    [self addSubview:self.cateLabel];
    [self addSubview:self.cnNameLable];
    [self addSubview:self.enNameLabel];
    [self addSubview:self.icon];
    [self addSubview:self.bottomTitle];
    [self addSubview:self.bottomLine];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Anno750(30)));
        make.left.equalTo(@(Anno750(20)));
        make.width.equalTo(@(Anno750(80)));
        make.height.equalTo(@(Anno750(120)));
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Anno750(30)));
        make.right.equalTo(@(-Anno750(20)));
        make.height.equalTo(@(Anno750(450)));
        make.width.equalTo(@(Anno750(270)));
    }];
    [self.cateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberLabel.mas_right).offset(Anno750(20));
        make.right.equalTo(self.icon.mas_right).offset(-Anno750(20));
        make.top.equalTo(@(Anno750(30)));
    }];
    [self.cnNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cateLabel.mas_left);
        make.right.equalTo(self.cateLabel.mas_right);
        make.centerY.equalTo(self.numberLabel.mas_centerY);
    }];
    [self.enNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cateLabel.mas_left);
        make.right.equalTo(self.cateLabel.mas_right);
        make.bottom.equalTo(self.numberLabel.mas_bottom);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(20)));
        make.right.equalTo(@(-Anno750(20)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@1);
    }];
    [self.bottomTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(60)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@30);
    }];
}
- (UILabel *)creatLabelWithTitle:(NSString *)title textColor:(UIColor *)color textFont:(CGFloat)fontValue andTextAlignment:(NSTextAlignment)alignment{
    UILabel * label = [Factory creatLabelWithTitle:title textColor:color
                                          textFont:fontValue textAlignment:alignment];
    label.font = [UIFont boldSystemFontOfSize:fontValue];
    return label;
}
- (void)updateWithModel:(BERTeamerModel *)model{
    if (model.is_coach) {
        self.numberLabel.text = [NSString stringWithFormat:@"%@",model.No];
        self.cateLabel.text = model.type;
    }else{
        self.numberLabel.text = @"";
        self.cateLabel.text = model.title;
    }
//    CGSize size = [Factory getSize:model.name maxSize:CGSizeMake(SCREENWIDTH, 9999) font:[UIFont boldSystemFontOfSize:font750(32)]];
//    if (size.width> Anno750(410)) {
//        self.cnNameLable.font = [UIFont boldSystemFontOfSize:font750(24)];
//    }
//    size = [Factory getSize:model.name_en maxSize:CGSizeMake(SCREENWIDTH, 9999) font:[UIFont boldSystemFontOfSize:font750(32)]];
//    if (size.width> Anno750(410)) {
//        self.enNameLabel.font = [UIFont boldSystemFontOfSize:font750(26)];
//    }
    self.cnNameLable.text = model.name;
    self.enNameLabel.text = model.name_en;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BER_IMAGE_HOST,model.pic]]];
}
@end
