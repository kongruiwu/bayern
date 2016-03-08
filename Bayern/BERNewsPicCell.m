//
//  NFLNewsPicCell.m
//  HupuNFL
//
//  Created by Wusicong on 15/1/5.
//  Copyright (c) 2015年 hupu.com. All rights reserved.
//

#import "BERNewsPicCell.h"

@implementation BERNewsPicCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initUI {
    [super initUI];
    
    CGFloat timeLbWidth = 40;
    CGFloat titleLbW = WindowWidth - BER_PIC_GAP*2 - timeLbWidth;
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(BER_PIC_GAP, BER_PIC_GAP, titleLbW, BER_PIC_TITLELB_H)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.font = [UIFont systemFontOfSize:14];
    titleLb.textColor = [UIColor colorWithHex:0x444444 alpha:1];
    self.titleLabel = titleLb;
    [self.contentView addSubview:titleLb];
    
    CGFloat imgW = (WindowWidth - BER_PIC_GAP * 4) / 3;
    CGFloat imgH = imgW / 1.78;
    for (int i = 0; i < 3; i ++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(BER_PIC_GAP +(BER_PIC_GAP + imgW)*i , titleLb.frame.origin.y + titleLb.frame.size.height + BER_PIC_GAP, imgW, imgH)];
        img.backgroundColor = [UIColor clearColor];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.clipsToBounds = YES;
        img.image = [UIImage imageNamed:@"photos_defult"];
        [self.contentView addSubview:img];
        
        switch (i) {
            case 0:
            {
                self.imgView1 = img;
            }
                break;
            case 1:
            {
                self.imgView2 = img;
            }
                break;
            case 2:
            {
                self.imgView3 = img;
            }
                break;
                
            default:
                break;
        }
    }
    
    UILabel *timeLb = [[UILabel alloc] initWithFrame:CGRectMake(WindowWidth - BER_PIC_GAP - timeLbWidth, titleLb.frame.origin.y, timeLbWidth, BER_PIC_TIMELB_H)];
    timeLb.backgroundColor = [UIColor clearColor];
    timeLb.textColor = [UIColor colorWithHex:0x999999 alpha:1];
    timeLb.font = [UIFont systemFontOfSize:12];
    self.timeLabel = timeLb;
    timeLb.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLb];
}

- (void)cleanCellShow {
    self.titleLabel.text = @"";
    
    self.imgView1.image = [UIImage imageNamed:@"photos_defult"];
    [self.imgView1 sd_cancelCurrentAnimationImagesLoad];

    self.imgView2.image = [UIImage imageNamed:@"photos_defult"];
    [self.imgView2 sd_cancelCurrentAnimationImagesLoad];

    self.imgView3.image = [UIImage imageNamed:@"photos_defult"];
    [self.imgView3 sd_cancelCurrentAnimationImagesLoad];
    
    self.timeLabel.text = @"";
}

- (void)configureCell:(id)dataModel {
    if (![dataModel isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    [self cleanCellShow];
    
    NSDictionary *dic = dataModel;
    
    self.titleLabel.text = dic[@"title"];
    self.timeLabel.text = [NSString reformForListTimeShowWithDate:dic[@"date"]];//dic[@"date"];
    
    NSArray *picArr = dic[@"thmub"];
    
    for (int i = 0; i < picArr.count; i ++) {
        NSString *requestURL = [NSString stringWithFormat:@"%@%@", BER_IMAGE_HOST, picArr[i]];
        switch (i) {
            case 0:
            {
                [self.imgView1 sd_setImageWithURL:[NSURL URLWithString:requestURL] placeholderImage:[UIImage imageNamed:@"photos_defult"]];
            }
                break;
            case 1:
            {
                [self.imgView2 sd_setImageWithURL:[NSURL URLWithString:requestURL] placeholderImage:[UIImage imageNamed:@"photos_defult"]];
            }
                break;
            case 2:
            {
                [self.imgView3 sd_setImageWithURL:[NSURL URLWithString:requestURL] placeholderImage:[UIImage imageNamed:@"photos_defult"]];
            }
                break;
                
            default:
                break;
        }

    }
}

@end
