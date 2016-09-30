//
//  NFLNewsWordsCell.h
//  HupuNFL
//
//  Created by Wusicong on 15/1/5.
//  Copyright (c) 2015年 hupu.com. All rights reserved.
//

#import "BERBaseTableViewCell.h"
#import "SearchResultModel.h"
#define BER_NEWS_WORDS_CELL_HEIGHT (112+24+22)/2

@interface BERNewsWordsCell : BERBaseTableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
- (void)updateWithModel:(SearchResultModel *)model;
@end
