//
//  HomeScroeHeadView.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/21.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "HomeScroeHeadView.h"

@implementation HomeScroeHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)creatUI{
    self.groundView = [Factory creatViewWithColor:COLOR_BACK_ALPHA_5];
    self.leftButton = [Factory creatButtonWithNormalImage:@"homeleft" selectImage:nil];
    self.rightButton = [Factory creatButtonWithNormalImage:@"homeRight" selectImage:nil];
    
    [self.leftButton addTarget:self action:@selector(colllcetViewMoveLeft:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(colllcetViewMoveRight:) forControlEvents:UIControlEventTouchUpInside];
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;

    [self addSubview:self.groundView];
    [self.groundView addSubview:self.leftButton];
    [self.groundView addSubview:self.rightButton];
    [self.groundView addSubview:self.scrollView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.groundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.top.bottom.equalTo(@(Anno750(40)));
        make.right.equalTo(@(-Anno750(30)));
        make.bottom.equalTo(@(-Anno750(20)));
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(20)));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(30)));
        make.height.equalTo(@(Anno750(55)));
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(20)));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(30)));
        make.height.equalTo(@(Anno750(55)));
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftButton.mas_right);
        make.right.equalTo(self.rightButton.mas_left);
        make.centerY.equalTo(@(-Anno750(10)));
        make.height.equalTo(@(Anno750(310)));
    }];
}
- (void)updateScrollViewWithArray:(NSArray *)arr{
    self.models = arr;
    self.scrollView.contentSize = CGSizeMake(Anno750(590) * arr.count, Anno750(310));
    for (int i = 0; i<arr.count; i++) {
        HomeScoreView * scoreView = [[HomeScoreView alloc]initWithFrame:CGRectMake(Anno750(590) * i, 0, Anno750(590), Anno750(310))];
        HomeGameModel * model = arr[i];
        scoreView.tag = 1000+i;
        [scoreView updateWithHomeGameModel:model];
        [scoreView.detailButton addTarget:self action:@selector(newsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [scoreView.newsButton addTarget:self action:@selector(newsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [scoreView.picButton addTarget:self action:@selector(picButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        scoreView.bottomLine.hidden = YES;
        [self.scrollView addSubview:scoreView];
    }
}
- (void)newsButtonClick:(UIButton *)btn{
    UIView * superView = [btn superview];
    int index = (int)superView.tag - 1000;
    HomeGameModel * model = self.models[index];
    if([self.delegate respondsToSelector:@selector(homeGameViewNewsButtonClickWithModel:)]){
        [self.delegate homeGameViewNewsButtonClickWithModel:model];
    }
}
- (void)picButtonClick:(UIButton *)btn{
    UIView * superView = [btn superview];
    int index = (int)superView.tag - 1000;
    HomeGameModel * model = self.models[index];
    if([self.delegate respondsToSelector:@selector(homeGameViewPicButtonClickWithModel:)]){
        [self.delegate homeGameViewPicButtonClickWithModel:model];
    }
}
- (void)colllcetViewMoveLeft:(UIButton *)btn{
    btn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.enabled = YES;
    });
    CGPoint point = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y);
    if (point.x / Anno750(590) >0) {
        [self.scrollView setContentOffset:CGPointMake(point.x - Anno750(590), 0) animated:YES];
    }
}
- (void)colllcetViewMoveRight:(UIButton *)btn{
    btn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.enabled = YES;
    });
    if (self.scrollView.contentOffset.x < 3 * Anno750(590)) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + Anno750(590), 0) animated:YES];
    }
}
@end
