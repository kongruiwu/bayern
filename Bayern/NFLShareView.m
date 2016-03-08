//
//  NFLShareView.m
//  HupuNFL
//
//  Created by Wusicong on 14/12/9.
//  Copyright (c) 2014年 hupu.com. All rights reserved.
//

#import "NFLShareView.h"

#define shareCount 5

@implementation NFLShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    UIButton *translucentBG = [[UIButton alloc] initWithFrame:self.bounds];
    translucentBG.backgroundColor = [UIColor blackColor];
    translucentBG.alpha = 0.7;
    [translucentBG addTarget:self action:@selector(backgroundClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:translucentBG];
    
    CGFloat shareBGGapX = 15;
    CGFloat shareBGWidth = WindowWidth - shareBGGapX *2;
    CGFloat shareBGGapY = WindowHeight / 3.5;
    UIView *shareBG = [[UIView alloc] initWithFrame:CGRectMake(shareBGGapX, shareBGGapY, shareBGWidth, ShareViewHeight)];
    shareBG.backgroundColor = [UIColor whiteColor];
    [self addSubview:shareBG];
    
    CGFloat titleLbWidth = 100;
    CGFloat titleLgGap = (shareBG.frame.size.width - titleLbWidth)/2;
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(titleLgGap, 10, titleLbWidth, 20)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor colorWithHex:0x444444 alpha:1];
    titleLb.text = @"分享至";
    titleLb.font = [UIFont systemFontOfSize:18];
    [shareBG addSubview:titleLb];
    
    CGFloat btnGapOriginX = 0;
    CGFloat btnWidth = 50;
    CGFloat btnGapX = btnGapOriginX = (shareBGWidth - btnWidth * shareCount)/(shareCount -1 + 2);
    CGFloat btnGapY = 9 + titleLb.frame.origin.y + titleLb.frame.size.height;
    for (int i = 0; i < shareCount; i ++) {
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.frame = CGRectMake(btnGapOriginX + (btnWidth + btnGapX)*i, btnGapY, btnWidth, btnWidth);
        shareBtn.tag = i;
        shareBtn.backgroundColor = [UIColor clearColor];
        [shareBtn addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareBG addSubview:shareBtn];
        
        switch (i) {
            case 0:
            {
                [shareBtn setBackgroundImage:[UIImage imageNamed:@"weixin.png"] forState:UIControlStateNormal];
            }
                break;
            case 1:
            {
                [shareBtn setBackgroundImage:[UIImage imageNamed:@"friends.png"] forState:UIControlStateNormal];
            }
                break;
            case 2:
            {
                [shareBtn setBackgroundImage:[UIImage imageNamed:@"weibo.png"] forState:UIControlStateNormal];
            }
                break;
            case 3:
            {
                [shareBtn setBackgroundImage:[UIImage imageNamed:@"Qzone.png"] forState:UIControlStateNormal];
            }
                break;
            case 4:
            {
                [shareBtn setBackgroundImage:[UIImage imageNamed:@"QQ.png"] forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
    }
    
    UIButton *cancle = [UIButton buttonWithType:UIButtonTypeCustom];
    cancle.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
    [cancle setTitle:@"取  消" forState:UIControlStateNormal];
    cancle.frame = CGRectMake(0, shareBG.frame.size.height - 40, shareBG.frame.size.width, 40);
    [cancle setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
    [shareBG addSubview:cancle];
}

- (void)shareButtonClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    NSInteger index = btn.tag;
    
    if ([self.delegate respondsToSelector:@selector(shareButtonDidClickWithType:)]) {
        [self.delegate shareButtonDidClickWithType:(ShareType)index];
    }
}

- (void)cancleClick {
    if ([self.delegate respondsToSelector:@selector(shareCancleButtonDidClick)]) {
        [self.delegate shareCancleButtonDidClick];
    }
}

- (void)backgroundClick {
    if ([self.delegate respondsToSelector:@selector(shareBackgroundDidClick)]) {
        [self.delegate shareBackgroundDidClick];
    }
}

- (void)resizeUI {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self initUI];
}

@end
