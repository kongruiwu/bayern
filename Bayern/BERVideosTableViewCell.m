//
//  BERVideosTableViewCell.m
//  Bayern
//
//  Created by 吴孔锐 on 15/7/22.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERVideosTableViewCell.h"
#import "BERHeadFile.h"
@implementation BERVideosTableViewCell

- (void)awakeFromNib {
    self.nameLabel.font=[UIFont systemFontOfSize:14.0f];
    self.nameLabel.textColor=[UIColor colorWithHexString:@"444444"];
    self.tagLabel.font=[UIFont boldSystemFontOfSize:12.0f];
    self.tagLabel.textColor=[UIColor colorWithHexString:@"999999"];

    self.IconImage.backgroundColor=[UIColor blackColor];
    UIImageView *videoPlayImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.IconImage.frame.size.width-23-5, self.IconImage.frame.size.height-23-5, 23, 23)];
    videoPlayImg.image=[UIImage imageNamed:@"videosPlay"];
    [self.IconImage addSubview:videoPlayImg];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellConfigUIWithModel:(BERVideosModel *)model
{
    self.nameLabel.text=model.title;
    [self.IconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BER_IMAGE_HOST,model.pic]] placeholderImage:nil];
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    NSString *currDay=[currentTime substringToIndex:10];
    NSString *matcDay=[model.date substringToIndex:10];
    NSString *currTime=[model.date substringToIndex:16];
    NSString *lastTime=[model.date substringToIndex:10];
    if ([currDay isEqualToString:matcDay]) {
        self.timeLabel.text=[currTime substringFromIndex:11];
    }else
    {
        self.timeLabel.text=[lastTime substringFromIndex:5];
    }
    
    
    NSString *tagStr=[[NSString alloc]init];
    if (model.tags.count<1) {
        tagStr=@"";
    }else if (model.tags.count<2){
        tagStr=[NSString stringWithFormat:@"%@",model.tags[0]];
    }else if(model.tags.count<3)
    {
        tagStr=[NSString stringWithFormat:@"%@  %@",model.tags[0],model.tags[1]];
    }else if(model.tags.count<4)
    {
        tagStr=[NSString stringWithFormat:@"%@  %@  %@",model.tags[0],model.tags[1],model.tags[2]];
    }else
    {
        tagStr=[NSString stringWithFormat:@"%@  %@  %@",model.tags[0],model.tags[1],model.tags[2]];
    }
    self.tagLabel.text=tagStr;
}
- (void)updateWithModel:(SearchResultModel *)model{
    self.nameLabel.text=model.title;
    [self.IconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BER_IMAGE_HOST,model.pic]] placeholderImage:nil];
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    NSString *currDay=[currentTime substringToIndex:10];
    NSString *matcDay=[model.date substringToIndex:10];
    NSString *currTime=[model.date substringToIndex:16];
    NSString *lastTime=[model.date substringToIndex:10];
    if ([currDay isEqualToString:matcDay]) {
        self.timeLabel.text=[currTime substringFromIndex:11];
    }else
    {
        self.timeLabel.text=[lastTime substringFromIndex:5];
    }
    NSString *tagStr=[[NSString alloc]init];
    if (model.tags.count<1) {
        tagStr=@"";
    }else if (model.tags.count<2){
        tagStr=[NSString stringWithFormat:@"%@",model.tags[0]];
    }else if(model.tags.count<3)
    {
        tagStr=[NSString stringWithFormat:@"%@  %@",model.tags[0],model.tags[1]];
    }else if(model.tags.count<4)
    {
        tagStr=[NSString stringWithFormat:@"%@  %@  %@",model.tags[0],model.tags[1],model.tags[2]];
    }else
    {
        tagStr=[NSString stringWithFormat:@"%@  %@  %@",model.tags[0],model.tags[1],model.tags[2]];
    }
    self.tagLabel.text=tagStr;
}
@end
