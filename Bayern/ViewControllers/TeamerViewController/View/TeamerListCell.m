//
//  TeamerListCell.m
//  Bayern
//
//  Created by 吴孔锐 on 2016/10/13.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "TeamerListCell.h"

@implementation TeamerListCell

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
    self.icon = [Factory creatImageViewWithImageName:@"teamerDefault"];
    self.cateLabel = [Factory creatLabelWithTitle:@""
                                        textColor:COLOR_CONTENT_GRAY_3 textFont:font750(30)
                                    textAlignment:NSTextAlignmentLeft];
    self.CHNameLabel = [Factory creatLabelWithTitle:@"" textColor:COLOR_CONTENT_GRAY_3 textFont:font750(36)
                                      textAlignment:NSTextAlignmentLeft];
    self.ENNameLabel = [Factory creatLabelWithTitle:@"" textColor:COLOR_CONTENT_GRAY_3 textFont:font750(36)
                                      textAlignment:NSTextAlignmentLeft];
    self.birthLabel = [Factory creatLabelWithTitle:@"" textColor:COLOR_CONTENT_GRAY_9 textFont:font750(28)
                                     textAlignment:NSTextAlignmentLeft];
    self.lineView = [Factory creatViewWithColor:COLOR_LINECOLOR];
    self.teamNum = [Factory creatLabelWithTitle:@"" textColor:COLOR_CONTENT_GRAY_3 textFont:font750(42)
                                  textAlignment:NSTextAlignmentCenter];
    
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.cateLabel];
    [self.contentView addSubview:self.CHNameLabel];
    [self.contentView addSubview:self.ENNameLabel];
    [self.contentView addSubview:self.birthLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.teamNum];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(20)));
        make.top.equalTo(@(Anno750(30)));
        make.height.equalTo(@(Anno750(320)));
        make.width.equalTo(@(Anno750(190)));
    }];
    [self.cateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(Anno750(20));
        make.top.equalTo(@(Anno750(60)));
    }];
    [self.CHNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cateLabel.mas_left);
        make.top.equalTo(self.cateLabel.mas_bottom).offset(Anno750(30));
    }];
    [self.ENNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.CHNameLabel.mas_left);
        make.top.equalTo(self.CHNameLabel.mas_bottom).offset(Anno750(30));
    }];
    [self.birthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ENNameLabel.mas_left);
        make.top.equalTo(self.ENNameLabel.mas_bottom).offset(Anno750(30));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@1);
    }];
    [self.teamNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(40)));
        make.top.equalTo(@(Anno750(40)));
    }];
}
- (void)updateWithModel:(ListTeamerModel *)model{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BER_IMAGE_HOST,model.pic]]];
    self.teamNum.text = [NSString stringWithFormat:@"%@",model.No];
    self.cateLabel.text = model.cate;
    self.ENNameLabel.text = model.name_en;
    self.CHNameLabel.text = model.name;
    self.birthLabel.text = model.birthday;
}

@end
