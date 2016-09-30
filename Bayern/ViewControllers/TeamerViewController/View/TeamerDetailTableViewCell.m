//
//  TeamerDetailTableViewCell.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/20.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "TeamerDetailTableViewCell.h"

@implementation TeamerDetailTableViewCell

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
    self.titleLabel = [Factory creatLabelWithTitle:@"生日"
                                         textColor:COLOR_CONTENT_GRAY_9
                                          textFont:font750(26) textAlignment:NSTextAlignmentLeft];
    self.descLabel = [Factory creatLabelWithTitle:@"1983/01/02"
                                        textColor:COLOR_CONTENT_GRAY_9 textFont:font750(26)
                                    textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(60)));
        make.centerY.equalTo(@0);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(300)));
        make.centerY.equalTo(@0);
    }];
}
- (void)updateWithTitle:(NSString *)titles descs:(NSString *)desc{
    self.titleLabel.text = titles;
    self.descLabel.text = desc;
}
@end
