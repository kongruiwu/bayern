//
//  HotSearcherTableViewCell.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/19.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "HotSearcherTableViewCell.h"

@implementation HotSearcherTableViewCell

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
    self.titleLabel = [Factory creatLabelWithTitle:@"好困"
                                         textColor:[UIColor whiteColor] textFont:font750(28)
                                     textAlignment:NSTextAlignmentLeft];
    self.deleteBtn = [Factory creatButtonWithNormalImage:@"search_close" selectImage:nil];
    [self.deleteBtn addTarget:self action:@selector(deletButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.deleteBtn];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.centerY.equalTo(@0);
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(30)));
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@(Anno750(60)));
    }];
}
- (void)deletButtonClick:(UIButton *)deleBtn{
    if ([self.delegate respondsToSelector:@selector(deleteHistorySearchWord:)]) {
        [self.delegate deleteHistorySearchWord:deleBtn];
    }
}
@end
