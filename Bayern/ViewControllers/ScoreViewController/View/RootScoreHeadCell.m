//
//  RootScoreHeadCell.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/17.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "RootScoreHeadCell.h"

@implementation RootScoreHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/*@property (nonatomic, strong) UILabel * nameLabel;
 @property (nonatomic, strong) UILabel * winLabel;
 @property (nonatomic, strong) UILabel * ballLabel;
 @property (nonatomic, strong) UILabel * scroeLabel;*/
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
    self.nameLabel = [self creatLabelWithTitle:@"俱乐部"];
    self.winLabel = [self creatLabelWithTitle:@"胜/平/负"];
    self.ballLabel = [self creatLabelWithTitle:@"进/失球"];
    self.scroeLabel = [self creatLabelWithTitle:@"积分"];
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.winLabel];
    [self.contentView addSubview:self.ballLabel];
    [self.contentView addSubview:self.scroeLabel];
    
}
- (UILabel *)creatLabelWithTitle:(NSString *)title{
    UILabel * label = [Factory creatLabelWithTitle:title textColor:[UIColor whiteColor] textFont:font750(28) textAlignment:NSTextAlignmentCenter];
    label.font = [UIFont boldSystemFontOfSize:font750(28)];
    return label;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.width.equalTo(@(Anno750(270)));
        make.centerY.equalTo(@0);
    }];
    [self.winLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right);
        make.width.equalTo(@(Anno750(140)));
        make.centerY.equalTo(@0);
    }];
    [self.ballLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.winLabel.mas_right);
        make.width.equalTo(@(Anno750(140)));
        make.centerY.equalTo(@0);
    }];
    [self.scroeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ballLabel.mas_right);
        make.width.equalTo(@(Anno750(100)));
        make.centerY.equalTo(@0);
    }];
}
@end
