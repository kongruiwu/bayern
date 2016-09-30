//
//  BERDownLoadView.m
//  Bayern
//
//  Created by wurui on 16/4/25.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BERDownLoadView.h"
#import "BERFactory.h"
@implementation BERDownLoadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
    
    self.pageLable = [BERFactory creatLabelWithText:@""
                                          textColor:[UIColor whiteColor]
                                           textFont:14.0f
                                      textAlignment:NSTextAlignmentLeft];
    self.downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.downButton setBackgroundImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    [self.downButton addTarget:self action:@selector(downLoadImg) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.lineView];
    [self addSubview:self.pageLable];
    [self addSubview:self.downButton];
}
- (void)layoutSubviews{
    self.lineView.frame = CGRectMake(0, 0, SCREENWIDTH, 0.5);
    self.pageLable.frame = CGRectMake(10, 10, 100, 20);
    self.downButton.frame = CGRectMake(SCREENWIDTH - 40 - 10, 5, 30, 30);
}
-(void)downLoadImg{
    if ([self.delegate respondsToSelector:@selector(downLoadImage)]) {
        [self.delegate downLoadImage];
    }
}
@end
