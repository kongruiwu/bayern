//
//  BERAdvCell.m
//  Bayern
//
//  Created by wusicong on 15/6/25.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERAdvCell.h"

@implementation BERAdvCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initUI {
    [super initUI];
    
    CGFloat imgH = ADV_CELL_HEIGHT;
    CGFloat imgW = WindowWidth;
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgW, imgH)];
    self.imgView = img;
    self.imgView.backgroundColor = [UIColor bayernImgDefaultColor];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    img.clipsToBounds = YES;
    [self.contentView addSubview:img];
    
}

- (void)cleanCellShow {
    self.imgView.image = [UIImage imageNamed:@"news_defult"];
    [self.imgView sd_cancelCurrentAnimationImagesLoad];
}

- (void)configureCell:(id)dataModel {
    if (![dataModel isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    [self cleanCellShow];
    
    NSDictionary *dic = dataModel;
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", BER_IMAGE_HOST, dic[@"pic"]];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:requestURL] placeholderImage:nil];
}

@end
