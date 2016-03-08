//
//  BERNewsVideoCell.m
//  Bayern
//
//  Created by 吴孔锐 on 15/7/30.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERNewsVideoCell.h"
#import "BERHeadFile.h"
@implementation BERNewsVideoCell

- (void)awakeFromNib {
    // Initialization code
    UIImageView *videoPlayImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.videoImgView.frame.size.width-23-5, self.videoImgView.frame.size.height-23-5, 23, 23)];
    videoPlayImg.image=[UIImage imageNamed:@"videosPlay"];
    [self.videoImgView addSubview:videoPlayImg];
}
-(void)configUIwith:(NSDictionary *)dic
{
    [self.videoImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BER_IMAGE_HOST,dic[@"pic"]]] placeholderImage:nil];
    self.titleLabel.text=dic[@"title"];
    self.titleLabel.textColor=[UIColor colorWithHexString:@"444444"];
    self.tagLabel.textColor=[UIColor colorWithHexString:@"e4003a"];
    NSString *tagStr;
    NSArray *tags=dic[@"tags"];
    if (tags.count<1) {
        tagStr=@"";
    }else if (tags.count<2){
        tagStr=[NSString stringWithFormat:@"%@",tags[0]];
    }else if(tags.count<3)
    {
        tagStr=[NSString stringWithFormat:@"%@  %@",tags[0],tags[1]];
    }else if(tags.count<4)
    {
        tagStr=[NSString stringWithFormat:@"%@  %@  %@",tags[0],tags[1],tags[2]];
    }else
    {
        tagStr=[NSString stringWithFormat:@"%@  %@  %@",tags[0],tags[1],tags[2]];
    }
    self.tagLabel.text=tagStr;
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    NSString *currDay=[currentTime substringToIndex:10];
    NSString *matcDay=[dic[@"date"] substringToIndex:10];
    NSString *currTime=[dic[@"date"] substringToIndex:16];
    NSString *lastTime=[dic[@"date"] substringToIndex:10];
    if ([currDay isEqualToString:matcDay]) {
        self.timeLabel.text=[currTime substringFromIndex:11];
    }else
    {
        self.timeLabel.text=[lastTime substringFromIndex:5];
    }
    self.lineView.backgroundColor=[UIColor colorWithHex:0xeeeeee alpha:1];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
