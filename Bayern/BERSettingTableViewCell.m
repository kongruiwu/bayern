//
//  BERSettingTableViewCell.m
//  Bayern
//
//  Created by 吴孔锐 on 15/8/3.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERSettingTableViewCell.h"
#import "BERHeadFile.h"
@implementation BERSettingTableViewCell

- (void)awakeFromNib {
    self.contenLabel.textColor=[UIColor colorWithHexString:@"999999"];
    self.stateLabel.textColor=[UIColor colorWithHexString:@"999999"];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
