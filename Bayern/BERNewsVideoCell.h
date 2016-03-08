//
//  BERNewsVideoCell.h
//  Bayern
//
//  Created by 吴孔锐 on 15/7/30.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BERNewsVideoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *videoImgView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
@property (strong, nonatomic) IBOutlet UILabel *tagLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIView *lineView;
-(void)configUIwith:(NSDictionary *)dic;
@end
