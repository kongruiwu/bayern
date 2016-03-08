//
//  BERTeamCell.m
//  Bayern
//
//  Created by wusicong on 15/6/19.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERTeamCell.h"

@implementation BERTeamCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initUI {
//    [super initUI];
    
    CGFloat gap = 10;
    CGFloat gapH = 15;
    CGFloat imgH = TeamCellHeight - gapH;
    CGFloat imgW = 190/2;
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(gap, gapH, imgW, imgH)];
    self.imgView = img;
    //self.imgView.backgroundColor = [UIColor bayernImgDefaultColor];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.image = [UIImage imageNamed:@""];
    img.clipsToBounds = YES;
    [self.contentView addSubview:img];
    
    CGFloat numberLbW = 30;
    CGFloat titleLbW = WindowWidth - gap*4 - imgW - numberLbW;
    CGFloat lbH = 20;
    
    CGFloat labelOriginY = 0;
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(img.frame.origin.x + img.frame.size.width+ gap, gapH*2, titleLbW, lbH)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.font = [UIFont systemFontOfSize:15];
    titleLb.textColor = [UIColor colorWithHex:0x444444 alpha:1];
    self.positionLalel = titleLb;
    [self.contentView addSubview:titleLb];
    
    labelOriginY += titleLb.frame.origin.y + titleLb.frame.size.height + gapH;
    
    UILabel *contentLb = [[UILabel alloc] initWithFrame:CGRectMake(titleLb.frame.origin.x, labelOriginY, titleLbW, lbH)];
    contentLb.backgroundColor = [UIColor clearColor];
    contentLb.font = [UIFont systemFontOfSize:18];
    contentLb.textColor = [UIColor colorWithHex:0x444444 alpha:1];
    contentLb.textAlignment = NSTextAlignmentLeft;
    self.nameLabel = contentLb;
    [self.contentView addSubview:contentLb];
    
    labelOriginY += contentLb.frame.size.height + gapH;
    
    UILabel *timeLb = [[UILabel alloc] initWithFrame:CGRectMake(titleLb.frame.origin.x, labelOriginY, titleLbW, lbH)];
    timeLb.backgroundColor = [UIColor clearColor];
    timeLb.textColor = [UIColor colorWithHex:0x444444 alpha:1];
    timeLb.font = [UIFont systemFontOfSize:18];
    self.ennameLabel = timeLb;
    timeLb.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:timeLb];
    
    labelOriginY += timeLb.frame.size.height + gapH;
    
    UILabel *timeLb2 = [[UILabel alloc] initWithFrame:CGRectMake(titleLb.frame.origin.x, labelOriginY, titleLbW, lbH)];
    timeLb2.backgroundColor = [UIColor clearColor];
    timeLb2.textColor = [UIColor colorWithHex:0x999999 alpha:1];
    timeLb2.font = [UIFont systemFontOfSize:15];
    self.birthLabel = timeLb2;
    timeLb2.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:timeLb2];
    
    UILabel *timeLb21 = [[UILabel alloc] initWithFrame:CGRectMake(WindowWidth - 20 - numberLbW, titleLb.frame.origin.y, numberLbW, 25)];
    timeLb21.backgroundColor = [UIColor clearColor];
    timeLb21.textColor = [UIColor colorWithHex:0x444444 alpha:1];
    timeLb21.font = [UIFont systemFontOfSize:21];
    self.numberLabel = timeLb21;
    timeLb21.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLb21];
    
}

- (void)cleanCellShow {
    self.imgView.image = [UIImage imageNamed:@""];
    [self.imgView sd_cancelCurrentAnimationImagesLoad];
    
    self.positionLalel.text = @"";
    self.nameLabel.text = @"";
    self.birthLabel.text = @"";
    self.ennameLabel.text = @"";
    self.numberLabel.text = @"";
}

- (void)configureCell:(id)dataModel {
    if (![dataModel isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    [self cleanCellShow];
    
    NSDictionary *dic = dataModel;
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", BER_IMAGE_HOST, dic[@"pic"]];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:requestURL] placeholderImage:[UIImage imageNamed:@""]];
    CGFloat gap = 10;
    CGFloat gapH = 15;
    CGFloat imgH = TeamCellHeight - gapH;
    
    CGFloat imgW =imgH*[dic[@"pic_width"] intValue]/[dic[@"pic_height"] intValue];
    self.imgView.frame=CGRectMake(gap, gapH, imgW, imgH);
    
    self.nameLabel.text = dic[@"name"];
    self.ennameLabel.text = dic[@"name_en"];
    self.birthLabel.text = dic[@"birthday"];
    
    
    self.numberLabel.text = [dic[@"No"] isKindOfClass:[NSNumber class]] ? [dic[@"No"] stringValue] : dic[@"No"];
}

@end
