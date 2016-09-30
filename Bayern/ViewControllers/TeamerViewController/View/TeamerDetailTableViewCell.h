//
//  TeamerDetailTableViewCell.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/20.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
@interface TeamerDetailTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * descLabel;
- (void)updateWithTitle:(NSString *)titles descs:(NSString *)desc;
@end
