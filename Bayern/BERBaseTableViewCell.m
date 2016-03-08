//
//  NFLBaseTableViewCell.m
//  HupuNFL
//
//  Created by hupu.com on 14/11/18.
//  Copyright (c) 2014年 hupu.com. All rights reserved.
//

#import "BERBaseTableViewCell.h"
#import "BERApiProxy.h"

@implementation BERBaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.backgroundColor = [UIColor whiteColor];
        
        self.sliderWidth = [BERMainCenter sharedInstance].getSliderContainerWidth;
        
        [self initUI];
        
    }
    return self;
}

#pragma mark - Private Method

- (void)initUI {
    UIView *bg = [[UIView alloc] initWithFrame:self.contentView.bounds];
    bg.backgroundColor = [UIColor colorWithHex:0xf2f3f5 alpha:1];
    self.selectedBackgroundView = bg;
    
}

- (void)cleanCellShow {
    
}

- (void)configureCell:(id)dataModel {
    
}

- (void)requestImgWithURL:(NSString *)url andImageView:(UIImageView *)imageView {
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", BER_IMAGE_HOST, url];
    [imageView sd_setImageWithURL:[NSURL URLWithString:requestURL] placeholderImage:[UIImage imageNamed:nil]];
}

- (void)showCellLineWithHeight:(CGFloat)height {    
    if (self.line == nil) {
        self.line = [[UIView alloc] init];
        self.line.backgroundColor = [UIColor colorWithHex:0xeeeeee alpha:1];
        [self.contentView addSubview:self.line];
    }
    
    self.line.frame = CGRectMake(15, height - 1, WindowWidth - 15, 1);
}

@end
