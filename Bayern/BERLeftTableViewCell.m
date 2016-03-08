//
//  BERLeftTableViewCell.m
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERLeftTableViewCell.h"

@implementation BERLeftTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        self.titleLabel.textColor = [UIColor whiteColor];
        self.contentLabel.textColor = [UIColor whiteColor];
        
        self.imgView.image = [UIImage imageNamed:self.selectedIconName];
    } else {
        self.titleLabel.textColor = [UIColor colorWithHex:0x999999 alpha:1];
        self.contentLabel.textColor = [UIColor colorWithHex:0x444444 alpha:1];
        
        self.imgView.image = [UIImage imageNamed:self.iconName];
    }
}

- (void)initUI {
    self.backgroundColor = [UIColor blackColor];
    
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sliderWidth, LeftCellHeight)];
    selectedView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    UIView *redLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, LeftCellHeight)];
    redLine.backgroundColor = [UIColor colorWithRed:0.9 green:0 blue:0.22 alpha:1];
    [selectedView addSubview:redLine];
    self.selectedBackgroundView = selectedView;
    
    CGFloat gap = 120/2;
    CGFloat imgH = 48/2;
    CGFloat imgW = imgH;
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(gap, (LeftCellHeight - imgH)/2, imgW, imgH)];
    self.imgView = img;
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    img.clipsToBounds = YES;
    [self.contentView addSubview:img];
    
    CGFloat titleLbW = 60;
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(img.frame.origin.x + img.frame.size.width+ 10, img.frame.origin.y, titleLbW, imgH)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.font = [UIFont systemFontOfSize:18];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor colorWithHex:0x999999 alpha:1];
    self.titleLabel = titleLb;
    [self.contentView addSubview:titleLb];
    
    UILabel *contentLb = [[UILabel alloc] initWithFrame:CGRectMake(titleLb.frame.origin.x + titleLb.frame.size.width + 10, titleLb.frame.origin.y + 7, titleLbW + 10, 15)];
    contentLb.backgroundColor = [UIColor clearColor];
    contentLb.font = [UIFont boldSystemFontOfSize:10];
    contentLb.textAlignment = NSTextAlignmentLeft;
    contentLb.textColor = [UIColor colorWithHex:0x444444 alpha:1];
    contentLb.numberOfLines = 0;
    self.contentLabel = contentLb;
    [self.contentView addSubview:contentLb];
}

@end
