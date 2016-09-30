//
//  ScoreTableViewCell.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/17.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "ScoreTableViewCell.h"
#import "HomeScoreView.h"


@interface ScoreTableViewCell()<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray * image;
@end
@implementation ScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewClick)];
    [self.scrollView addGestureRecognizer:tap];
    [self.contentView addSubview:self.groundView];
    [self.groundView addSubview:self.leftButton];
    [self.groundView addSubview:self.rightButton];
    [self.groundView addSubview:self.scrollView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.groundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.top.bottom.equalTo(@0);
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
        make.left.equalTo(self.leftButton.mas_right);
        make.right.equalTo(self.rightButton.mas_left);
        make.centerY.equalTo(@0);
        make.height.equalTo(@(Anno750(200)));
    }];
}

- (void)updateScrollViewWithArray:(NSArray *)arr{
    self.scrollView.contentSize = CGSizeMake(Anno750(590) * arr.count, Anno750(200));
    for (int i = 0; i<arr.count; i++) {
        HomeScoreView * scoreView = [[HomeScoreView alloc]initWithFrame:CGRectMake(Anno750(590) * i, 0, Anno750(590), Anno750(200))];
        HomeGameModel * model = arr[i];
        [scoreView updateWithHomeGameModel:model];
        scoreView.userInteractionEnabled = YES;
        [self.scrollView addSubview:scoreView];
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
- (void)scrollViewClick{
    int index = self.scrollView.contentOffset.x / Anno750(590);
    if([self.delegate respondsToSelector:@selector(homeGameClickAtIndex:)]){
//        [self.delegate homeGameClickAtIndex:index];
    }
}
@end
