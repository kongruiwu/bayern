//
//  NFLNewsWordsCell.m
//  HupuNFL
//
//  Created by Wusicong on 15/1/5.
//  Copyright (c) 2015年 hupu.com. All rights reserved.
//

#import "BERNewsWordsCell.h"

@implementation BERNewsWordsCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initUI {
    [super initUI];
    
    CGFloat gap = 8;
    CGFloat imgH = BER_NEWS_WORDS_CELL_HEIGHT - gap*2;
    CGFloat imgW = imgH * 1.78;
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(gap, gap, imgW, imgH)];
    self.imgView = img;
    self.imgView.backgroundColor = [UIColor clearColor];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.image = [UIImage imageNamed:@"news_defult"];
    img.clipsToBounds = YES;
    [self.contentView addSubview:img];
    
    CGFloat titleLbW = WindowWidth - gap*3 - imgW;
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(img.frame.origin.x + img.frame.size.width+ gap, img.frame.origin.y, titleLbW, 16)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.font = [UIFont systemFontOfSize:14];
    titleLb.textColor = [UIColor colorWithHex:0x444444 alpha:1];
    self.titleLabel = titleLb;
    [self.contentView addSubview:titleLb];
    
    UILabel *contentLb = [[UILabel alloc] initWithFrame:CGRectMake(titleLb.frame.origin.x, titleLb.frame.origin.y + titleLb.frame.size.height + 0, titleLbW, (BER_NEWS_WORDS_CELL_HEIGHT - 20 - titleLb.frame.size.height-3))];
    contentLb.backgroundColor = [UIColor clearColor];
    contentLb.font = [UIFont systemFontOfSize:12];
    contentLb.textColor = [UIColor colorWithHex:0x999999 alpha:1];
    contentLb.textAlignment = NSTextAlignmentLeft;
    contentLb.numberOfLines = 0;
    self.contentLabel = contentLb;
    [self.contentView addSubview:contentLb];
    
    UILabel *timeLb = [[UILabel alloc] initWithFrame:CGRectMake(WindowWidth - gap - 150, BER_NEWS_WORDS_CELL_HEIGHT - 15- 5, 150, 15)];
    timeLb.backgroundColor = [UIColor clearColor];
    timeLb.textColor = [UIColor colorWithHex:0x999999 alpha:1];
    timeLb.font = [UIFont systemFontOfSize:12];
    self.timeLabel = timeLb;
    timeLb.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLb];
}

- (void)cleanCellShow {
    self.imgView.image = [UIImage imageNamed:@"news_defult"];
    [self.imgView sd_cancelCurrentAnimationImagesLoad];
    
    self.titleLabel.text = @"";
    self.timeLabel.text = @"";
    self.contentLabel.text = @"";
}

- (void)configureCell:(id)dataModel {
    if (![dataModel isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    [self cleanCellShow];
    
    NSDictionary *dic = dataModel;
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", BER_IMAGE_HOST, dic[@"pic"]];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:requestURL] placeholderImage:[UIImage imageNamed:@"news_defult"]];
    
    self.titleLabel.text = dic[@"title"];
    self.contentLabel.text = dic[@"content"];
    
    self.timeLabel.text = [NSString reformForListTimeShowWithDate:dic[@"date"]];//dic[@"date"];

}

@end
