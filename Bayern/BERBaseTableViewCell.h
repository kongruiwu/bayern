//
//  NFLBaseTableViewCell.h
//  HupuNFL
//
//  Created by hupu.com on 14/11/18.
//  Copyright (c) 2014年 hupu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BERBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *line;
@property CGFloat sliderWidth; //滑动内嵌页面宽

- (void)initUI;
- (void)configureCell:(id)dataModel;
- (void)cleanCellShow; //清除之前cell的显示

- (void)requestImgWithURL:(NSString *)url andImageView:(UIImageView *)imageView; //简单封装的图片请求

- (void)showCellLineWithHeight:(CGFloat)height; //画line。。。

@end
