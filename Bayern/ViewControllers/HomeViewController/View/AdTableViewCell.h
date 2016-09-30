//
//  AdTableViewCell.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/17.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
@interface AdTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView * adImage;
- (void)updateWithImageUrlstring:(NSString *)url;
@end
