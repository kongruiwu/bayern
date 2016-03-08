//
//  BERStandingTableViewCell.h
//  Bayern
//
//  Created by 吴孔锐 on 15/7/22.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BERStandModel.h"
#import "BERHeadFile.h"
@interface BERStandingTableViewCell : UITableViewCell
{
    UIView *fristView;
    UIView *secondView;
    UIView *thirdView;
    UILabel *rankLabel;
    UIImageView *iconImg;
    UILabel *nameLabel;
    UILabel *winLabel;
    UILabel *drawLabel;
    UILabel *lostLabel;
    UILabel *hitLabel;
    UILabel *scoreLabel;
    UIView *lineView;
}
-(void)configUIWithModel:(BERStandModel *)model;
@end
