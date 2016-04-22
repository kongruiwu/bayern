//
//  BERShowTextView.m
//  Bayern
//
//  Created by wurui on 16/4/22.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BERShowTextView.h"
#import "BERFactory.h"
@implementation BERShowTextView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.titleLabel = [BERFactory creatLabelWithText:@"我是标题"
                                           textColor:[UIColor whiteColor]
                                            textFont:17.0f
                                       textAlignment:NSTextAlignmentLeft];
    self.pageLable = [BERFactory creatLabelWithText:@"8/10"
                                          textColor:[UIColor whiteColor]
                                           textFont:15.0f
                                      textAlignment:NSTextAlignmentRight];
    self.descLabel = [BERFactory creatLabelWithText:@"描述文字"
                                          textColor:[UIColor whiteColor]
                                           textFont:14.0f
                                      textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.titleLabel];
    [self addSubview:self.pageLable];
    [self addSubview:self.descLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.pageLable.frame = CGRectMake(SCREENWIDTH - 50, 10, 45, 20);
    self.titleLabel.frame = CGRectMake(10, 5, SCREENWIDTH - 65, 30);
    CGSize size = [BERFactory getSize:self.descLabel.text maxSize:CGSizeMake(SCREENWIDTH - 20, 99999) font:self.descLabel.font];
    self.descLabel.frame = CGRectMake(10, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+5, SCREENWIDTH - 20, size.height);
    self.descLabel.numberOfLines = 0;
    
}
@end
