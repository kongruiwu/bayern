//
//  NFLNewsPicCell.h
//  HupuNFL
//
//  Created by Wusicong on 15/1/5.
//  Copyright (c) 2015年 hupu.com. All rights reserved.
//

#import "BERBaseTableViewCell.h"

#define BER_PIC_GAP 10
#define BER_PIC_TITLELB_H 18
#define BER_PIC_TIMELB_H 18
#define BER_NEWS_PIC_CELL_HEIGHT (((WindowWidth - BER_PIC_GAP * 4) / 3 / 1.78) + BER_PIC_GAP + BER_PIC_TITLELB_H +BER_PIC_GAP+BER_PIC_GAP)

@interface BERNewsPicCell : BERBaseTableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView1;
@property (nonatomic, strong) UIImageView *imgView2;
@property (nonatomic, strong) UIImageView *imgView3;

@property (nonatomic, strong) UILabel *timeLabel;

@end
