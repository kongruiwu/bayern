//
//  SearchCateTableViewCell.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/19.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "SearchCateTableViewCell.h"

@implementation SearchCateTableViewCell

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
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)creatUI{
    self.icon = [Factory creatImageViewWithImageName:@"search_news"];
    self.nameLabel = [Factory creatLabelWithTitle:@"新闻"
                                        textColor:COLOR_CONTENT_GRAY_9 textFont:font750(28)
                                    textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.nameLabel];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.centerY.equalTo(@0);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(Anno750(20));
        make.centerY.equalTo(@0);
    }];
}
- (void)updateWithSearchCateModel:(SearchCateModel *)model{
    self.icon.image = [UIImage imageNamed:model.imageName];
    self.nameLabel.text = model.name;
    if (model.isSelect) {
        self.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.91 alpha:1.00];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}
@end
