//
//  HomeVideoFootView.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/21.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "HomeVideoFootView.h"

@implementation HomeVideoFootView

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
    self.leftButton = [Factory creatButtonWithNormalImage:@"homeleft" selectImage:@"homeleftSelect"];
    self.rightButton = [Factory creatButtonWithNormalImage:@"homeRight" selectImage:@"homeRightSelect"];
    
    [self.leftButton addTarget:self action:@selector(colllcetViewMoveLeft:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(colllcetViewMoveRight:) forControlEvents:UIControlEventTouchUpInside];
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delaysContentTouches = YES;
    self.scrollView.canCancelContentTouches = NO;
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
        make.top.bottom.equalTo(@(Anno750(20)));
        make.right.equalTo(@(-Anno750(30)));
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
        make.left.equalTo(self.leftButton.mas_right).offset(Anno750(10));
        make.right.equalTo(self.rightButton.mas_left).offset(-Anno750(10));
        make.centerY.equalTo(@(-Anno750(10)));
        make.height.equalTo(@(Anno750(350)));
    }];
}
- (void)colllcetViewMoveLeft:(UIButton *)btn{
    btn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.enabled = YES;
    });
    CGPoint point = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y);
    if (point.x / Anno750(570) >0) {
        [self.scrollView setContentOffset:CGPointMake(point.x - Anno750(570), 0) animated:YES];
    }
}
- (void)colllcetViewMoveRight:(UIButton *)btn{
    btn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.enabled = YES;
    });
    if (self.scrollView.contentOffset.x < (self.videos.count - 1) * Anno750(570)) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + Anno750(570), 0) animated:YES];
    }
    
}
- (void)updateScrollViewWithVideoArray:(NSArray *)arr{
    self.videos = arr;
    self.scrollView.contentSize = CGSizeMake(Anno750(570) * arr.count, Anno750(350));
    for (int i = 0; i<arr.count; i++) {
        HomeVideoView * videoView = [[HomeVideoView alloc]initWithFrame:CGRectMake(Anno750(570) * i, 0, Anno750(570), Anno750(350))];
        videoView.tag = 100+i;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(videoViewClick:)];
        [videoView addGestureRecognizer:tap];
        HomePicModel * model = arr[i];
        [videoView updateImageViewWithModel:model];
        [self.scrollView addSubview:videoView];
    }
}
- (void)videoViewClick:(UITapGestureRecognizer *)sender{
    int tag = (int)sender.view.tag - 100;
    HomePicModel * model = self.videos[tag];
    if ([self.delegate respondsToSelector:@selector(HomeVideoSelctWithModel:)]) {
        [self.delegate HomeVideoSelctWithModel:model];
    }
}
@end
