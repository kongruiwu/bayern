//
//  BERVideosTableViewCell.h
//  Bayern
//
//  Created by 吴孔锐 on 15/7/22.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BERVideosModel.h"
#import "SearchResultModel.h"
@interface BERVideosTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet UIImageView *IconImage;
@property (strong, nonatomic) IBOutlet UILabel *tagLabel;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

-(void)cellConfigUIWithModel:(BERVideosModel *)model;
- (void)updateWithModel:(SearchResultModel *)model;
@end
