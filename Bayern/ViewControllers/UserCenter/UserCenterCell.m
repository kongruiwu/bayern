//
//  UserCenterCell.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/3.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "UserCenterCell.h"

@implementation UserCenterCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)creatUI{
    self.icon = [Factory creatImageViewWithImageName:@"porfile_sex"];
    self.titleLabel = [Factory creatLabelWithTitle:@"性别"
                                         textColor:COLOR_CONTENT_GRAY_6
                                          textFont:font750(30)
                                     textAlignment:NSTextAlignmentLeft];
    self.nextIcon = [Factory creatImageViewWithImageName:@"arrows"];
    self.descLabel = [Factory creatLabelWithTitle:@"男"
                                        textColor:COLOR_CONTENT_GRAY_6 textFont:font750(30) textAlignment:NSTextAlignmentRight];
    self.lineView = [Factory creatViewWithColor:COLOR_LINECOLOR];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.nextIcon];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.lineView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.width.height.equalTo(@(Anno750(30)));
        make.centerY.equalTo(@0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(Anno750(30));
        make.centerY.equalTo(@0);
    }];
    [self.nextIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(30)));
        make.centerY.equalTo(@0);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.arrowHiden) {
            make.right.equalTo(@(-Anno750(30)));
        }else{
            make.right.equalTo(self.nextIcon.mas_left).offset(-Anno750(20));
        }
        make.centerY.equalTo(@0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
}
- (void)hideArrowIcon:(BOOL)rec{
    self.arrowHiden = rec;
    self.nextIcon.hidden = rec;
}
- (void)configUIwithTitle:(NSString *)title imageName:(NSString *)imageName descText:(NSString *)descStr
{
    self.titleLabel.text = title;
    self.icon.image = [UIImage imageNamed:imageName];
    if (descStr && descStr.length>0) {
        self.descLabel.text = descStr;
    }
}
@end
