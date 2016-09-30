//
//  HotSearcherTableViewCell.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/19.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
@protocol HotSearcherCellDelegate <NSObject>

- (void)deleteHistorySearchWord:(UIButton *)btn;

@end


@interface HotSearcherTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * deleteBtn;
@property (nonatomic, assign) id<HotSearcherCellDelegate>delegate;
@end
