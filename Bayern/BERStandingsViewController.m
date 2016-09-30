//
//  BERStandingsViewController.m
//  Bayern
//
//  Created by wurui on 15/7/21.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERStandingsViewController.h"
#import "BERHeadFile.h"
#import "HMSegmentedControl.h"
#import "ScoreDeatilViewController.h"
@interface BERStandingsViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) HMSegmentedControl * segmentControl;
@property (nonatomic, strong) NSArray * titles;
@property (nonatomic, strong) UIScrollView * mainScroll;
@property (nonatomic, strong) NSMutableArray * viewControllers;
@end

@implementation BERStandingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self drawMainTabItem];
    [self drawTitle:@"积分"];
    [self creatUI];
}

- (void)creatUI{
    self.titles = @[@"德甲",@"欧冠"];
    self.segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:self.titles];
    self.segmentControl.frame = CGRectMake(0, 0, SCREENWIDTH, Anno750(80));
    //设置字体
    self.segmentControl.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:font750(30)],
                                                NSForegroundColorAttributeName : COLOR_CONTENT_GRAY_9};
    self.segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:font750(30)],
                                                        NSForegroundColorAttributeName : COLOR_MAIN_RED};
    
    //设置移动线条属性
    self.segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentControl.selectionIndicatorHeight = Anno750(6);
    self.segmentControl.selectionIndicatorColor = COLOR_MAIN_RED;
    self.segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    [self.view addSubview:self.segmentControl];
    
    UIView * lineView = [Factory creatViewWithColor:COLOR_LINECOLOR];
    [self.segmentControl addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,Anno750(80), SCREENWIDTH,  SCREENHEIGH - Anno750(80))];
    self.mainScroll.contentSize = CGSizeMake(self.titles.count * SCREENWIDTH, 0);
    [self.mainScroll autoresizingMask];
    self.mainScroll.pagingEnabled = YES;
    self.mainScroll.showsVerticalScrollIndicator = NO;
    self.mainScroll.showsHorizontalScrollIndicator = NO;
    self.mainScroll.backgroundColor = [UIColor whiteColor];
    self.mainScroll.delegate = self;
    [self.view addSubview:self.mainScroll];
    self.viewControllers = [NSMutableArray new];
    for (int i = 0 ; i<self.titles.count; i++) {
        if (i == 0) {
            ScoreDeatilViewController *vc = [ScoreDeatilViewController new];
            vc.view.frame = CGRectMake(SCREENWIDTH * i, 0, SCREENWIDTH , SCREENHEIGH - Anno750(80));
            [self.mainScroll addSubview:vc.view];
            [self addChildViewController:vc];
            [self.viewControllers addObject:vc];
        }else{
            [self.viewControllers addObject:@"OderStatusViewController"];
        }
        
    }
    
    //这里 是是用时进行创建 避免内存浪费
    __weak BERStandingsViewController * weakSelf = self;
    [self.segmentControl setIndexChangeBlock:^(NSInteger index) {
        if (![weakSelf.viewControllers[index] isKindOfClass:[UIViewController class]]) {
            ScoreDeatilViewController *vc = [ScoreDeatilViewController new];
            if (index == 1) {
                vc.isSecond = YES;
            }
            vc.view.frame = CGRectMake(SCREENWIDTH * index, 0, SCREENWIDTH , SCREENHEIGH - Anno750(80));
            [weakSelf.mainScroll addSubview:vc.view];
            [weakSelf addChildViewController:vc];
            [weakSelf.viewControllers replaceObjectAtIndex:index withObject:vc];
        }
        [UIView animateWithDuration:0.3f animations:^{
            weakSelf.mainScroll.contentOffset = CGPointMake(SCREENWIDTH * index, 0);
        }];
    }];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x / SCREENWIDTH;
    [self.segmentControl setSelectedSegmentIndex:index animated:YES];
    if (![self.viewControllers[index] isKindOfClass:[UIViewController class]]) {
        ScoreDeatilViewController *vc = [ScoreDeatilViewController new];
        if (index == 1) {
            vc.isSecond = YES;
        }
        vc.view.frame = CGRectMake(SCREENWIDTH * index, 0, SCREENWIDTH , SCREENHEIGH - Anno750(80));
        [self.mainScroll addSubview:vc.view];
        [self addChildViewController:vc];
        [self.viewControllers replaceObjectAtIndex:index withObject:vc];
    }
}

@end
