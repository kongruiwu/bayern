//
//  AdTableViewCell.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/17.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "AdTableViewCell.h"

@implementation AdTableViewCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)creatUI{
    self.adImage = [Factory creatImageViewWithImageName:@"photos_defult"];
    [self.contentView addSubview:self.adImage];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.adImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(@0);
        make.left.equalTo(@(Anno750(30)));
        make.right.equalTo(@(-Anno750(30)));
    }];
}
- (void)updateWithImageUrlstring:(NSString *)url{
    NSURL * URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BER_IMAGE_HOST,url]];
    [self.adImage sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"photos_defult"]];
}

@end
