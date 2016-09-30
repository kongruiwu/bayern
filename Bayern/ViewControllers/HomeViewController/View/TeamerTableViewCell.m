//
//  TeamerTableViewCell.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/17.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "TeamerTableViewCell.h"

@implementation TeamerTableViewCell

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
    self.leftTeamer = [[teamerShowView alloc]init];
    self.rightTeamer = [[teamerShowView alloc]init];
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftTapClick)];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightTapClick)];
    
    [self.leftTeamer addGestureRecognizer:tap1];
    [self.rightTeamer addGestureRecognizer:tap2];
    
    [self.contentView addSubview:self.leftTeamer];
    [self.contentView addSubview:self.rightTeamer];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.leftTeamer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.width.equalTo(@(Anno750(335)));
        make.top.bottom.equalTo(@0);
    }];
    [self.rightTeamer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(30)));
        make.width.equalTo(@(Anno750(335)));
        make.top.bottom.equalTo(@0);
    }];
}
- (void)updateWithArray:(NSArray *)arr{
    HomeTeamerModel * model1 = arr[0];
    HomeTeamerModel * model2 = arr[1];
    self.models = arr;
    [self.leftTeamer updateWithHomeTeamerModel:model1];
    [self.rightTeamer updateWithHomeTeamerModel:model2];
}
-(void)leftTapClick{
    [self clickWithModel:self.models[0]];
}
- (void)rightTapClick{
    [self clickWithModel:self.models[1]];
}
- (void)clickWithModel:(HomeTeamerModel *)model{
    if ([self.delegate respondsToSelector:@selector(teamerClickWithModel:)]) {
        [self.delegate teamerClickWithModel:model];
    }
}
@end
