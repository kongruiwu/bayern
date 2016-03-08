//
//  NFLVideoFocusView.m
//  HupuNFL
//
//  Created by Wusicong on 14/11/26.
//  Copyright (c) 2014年 hupu.com. All rights reserved.
//

#import "BERListFocusView.h"

@implementation BERListFocusView 

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [self.timer invalidate];
}

- (void)creatDisplay {
    self.buttonArray = [NSMutableArray array];
    self.imageArray = [NSMutableArray array];
    
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    sv.backgroundColor = [UIColor clearColor];
    sv.pagingEnabled = YES;
    sv.delegate = self;
    self.focusScrollView = sv;
    [self addSubview:sv];
    
    CGFloat pgWidth = 75;
    
    UIView *titleBG = [[UIView alloc] initWithFrame:CGRectMake(0, FocusViewHeight - 30, sv.frame.size.width, 30)];
    titleBG.backgroundColor = [UIColor colorWithHex:0xffffff alpha:0.9];
    [self addSubview:titleBG];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, titleBG.frame.origin.y, titleBG.frame.size.width - pgWidth-15, titleBG.frame.size.height)];
    self.titleLabel = titleLb;
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textColor = [UIColor colorWithHex:0x444444 alpha:1];
    titleLb.font = [UIFont systemFontOfSize:12];
    [self addSubview:titleLb];
    
    UIPageControl *pg = [[UIPageControl alloc] initWithFrame:CGRectMake(sv.frame.size.width - pgWidth-30, 0, pgWidth, titleLb.frame.size.height)];
    pg.backgroundColor = [UIColor clearColor];
    pg.pageIndicatorTintColor = [UIColor lightGrayColor];
    pg.currentPageIndicatorTintColor = [UIColor redColor];
    pg.numberOfPages = 0;
    self.pageControl = pg;
    [titleLb addSubview:pg];
}

- (void)redrawWithData:(NSArray *)dataArr {
    self.focusScrollView.contentSize = CGSizeMake(self.frame.size.width * dataArr.count, self.frame.size.height);
    
    CGFloat imgW = self.frame.size.width;
    if (dataArr.count > 0) {
        [self cleanImageData];
        self.dataArray = [NSArray arrayWithArray:dataArr];
        
        //set img and title
        for (int i = 0; i < dataArr.count; i ++) {
            NSDictionary *dic = dataArr[i];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0 + imgW * i, 0, imgW, FocusViewHeight);
            button.tag = i;
            button.backgroundColor = [UIColor lightGrayColor];
            [button addTarget:self action:@selector(doClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.focusScrollView addSubview:button];
            [self.buttonArray addObject:button];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:button.bounds];
            img.backgroundColor = [UIColor bayernImgDefaultColor];
            img.contentMode = UIViewContentModeScaleToFill;
            img.clipsToBounds = YES;
            [button addSubview:img];
            [self.imageArray addObject:img];
            
            CGFloat playImgW = 88/2;
            UIImageView *playImg = [[UIImageView alloc] initWithFrame:CGRectMake((img.frame.size.width - playImgW)/2, (img.frame.size.height - playImgW)/2, playImgW, playImgW)];
            [img addSubview:playImg];
            NSString *requestURL = [NSString stringWithFormat:@"%@%@", BER_IMAGE_HOST, dic[@"pic"]];
            [img sd_setImageWithURL:[NSURL URLWithString:requestURL] placeholderImage:[UIImage imageNamed:@"banner_defult.png"]];
        }
    }
    
    self.titleLabel.text = dataArr[0][@"title"]; //默认显示第一个title
    self.pageControl.numberOfPages = self.dataArray.count;
    self.pageControl.currentPage = 0;
    
    [self startAnimation];
}

- (void)cleanImageData {
    for (int i = 0; i < self.buttonArray.count; i ++) {
        UIButton *imgView = self.buttonArray[i];
        [imgView removeFromSuperview];
    }
    [self.buttonArray removeAllObjects];
    [self.imageArray removeAllObjects];
}

- (void)redrawTitleShowWithIndex:(NSInteger)index {
    self.titleLabel.text = self.dataArray[index][@"title"];
    self.pageControl.currentPage = index;
}

- (void)doClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag;
    
    if ([self.delegate respondsToSelector:@selector(focusViewDidClickWithIndex:)]) {
        [self.delegate focusViewDidClickWithIndex:index];
    }
}

#pragma mark - Animation Method

//轮播动画
- (void)startAnimation {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(doAnimation) userInfo:nil repeats:YES];
}

- (void)doAnimation {
    NSInteger index = self.focusScrollView.contentOffset.x / self.focusScrollView.frame.size.width;

    index ++;
    
    if (index >= self.dataArray.count) {
        index = 0;
    }
    
    [self.focusScrollView setContentOffset:CGPointMake(self.frame.size.width * index, 0) animated:YES];
    [self redrawTitleShowWithIndex:index];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    [self redrawTitleShowWithIndex:index];
}

@end
