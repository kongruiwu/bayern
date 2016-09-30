//
//  AutoScrollView.m
//  XYL_iOS
//
//  Created by wurui on 16/6/17.
//  Copyright © 2016年 wurui. All rights reserved.
//


#import "AutoScrollView.h"
#import "UIImageView+WebCache.h"
#define WINDOW_WIDTH [UIScreen mainScreen].bounds.size.width
#define WINDOW_HIGHT [UIScreen mainScreen].bounds.size.height

@interface AutoScrollView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView    *scrollView;
//@property (nonatomic, strong) UIPageControl   *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel * descLabel;

@end

@implementation AutoScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageViews = [NSMutableArray new];

        
        _scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.showsHorizontalScrollIndicator = NO;        // 取消水平滚动条
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;// 设置代理
        _scrollView.bounces = NO;
        _pageControl = [[UIPageControl alloc] init];     //创建一个页面控制器;
        _pageControl.currentPageIndicatorTintColor = COLOR_MAIN_RED;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:_scrollView];  //滚动视图添加到view1中
        UIView * blackView = [Factory creatViewWithColor:COLOR_BACK_ALPHA_3];
        [self addSubview:blackView];
        [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.equalTo(@0);
            make.height.equalTo(@(Anno750(60)));
        }];
        [blackView addSubview:_pageControl];
        
        _scrollView.pagingEnabled = YES;
        _pageControl.currentPage = 0;// 分页初始页数为0
        _scrollView.contentOffset = CGPointMake(WINDOW_WIDTH, 0);
        
        self.descLabel = [Factory creatLabelWithTitle:@"我是描述文字"
                                            textColor:[UIColor whiteColor] textFont:font750(26) textAlignment:NSTextAlignmentLeft];
        [blackView addSubview:self.descLabel];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-Anno750(20)));
            make.centerY.equalTo(@0);
        }];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(Anno750(20)));
            make.centerY.equalTo(@0);
        }];
        
    }
    return self;
}


-(UIButton *)countButton{
    if (_countButton == nil) {
        CGFloat buttonW = 120*WINDOW_WIDTH/720;
        CGFloat buttonH = 50*WINDOW_HIGHT/1280;
        
        UIButton *countButton  =[[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width - buttonW, self.bounds.size.height - buttonH - 5, buttonW, buttonH)];
        [countButton setBackgroundImage:[UIImage imageNamed:@"bg_8zhang.png"] forState:UIControlStateNormal];
        countButton.titleLabel.font=[UIFont systemFontOfSize:13.0f];
        [countButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:countButton];
        //        [countButton setTitle:[NSString stringWithFormat:@"%ld 张",self.buttonImageArr.count] forState:UIControlStateNormal];
        [countButton addTarget:self action:@selector(countButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _countButton = countButton;
    }
    return _countButton;
}

-(void)setImages:(NSArray *)images{
    if (self.imageViews&&self.imageViews.count>0) {
        for (int i =0 ; i<self.imageViews.count; i++) {
            UIImageView * imageView = self.imageViews[i];
            [imageView removeFromSuperview];
        }
        [self.imageViews removeAllObjects];
    }
    
    _images = images;
    
    // 设置图片
    NSMutableArray *imagesM = [NSMutableArray arrayWithArray:images];
    [imagesM insertObject:[images lastObject] atIndex:0];
    [imagesM addObject:[images firstObject]];
    
    for (int i = 0; i < imagesM.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
//        imageView.image = imagesM[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imagesM[i]] placeholderImage:[UIImage imageNamed:@"icon_mine_ground"]];
        [_scrollView addSubview:imageView];
        [self.imageViews addObject:imageView];
    }
    self.descLabel.text = self.descs[0];
    _pageControl.numberOfPages = images.count;        // 总页数
    _scrollView.contentSize = CGSizeMake(imagesM.count * _scrollView.bounds.size.width, 0);
    
    [self setNeedsLayout];
    [self startTimer];
}


-(void)setIsShowButton:(BOOL)isShowButton{
    _isShowButton = isShowButton;
    
    if (isShowButton == YES) {
        self.countButton.hidden = NO;
    }else{
        self.countButton.hidden = YES;
    }
}


- (void)countButtonClick:(UIButton *)button{
    
    
    //    if (_countButtonImageClickBlock) {
    //        _countButtonImageClickBlock();
    //    }
    
    //     [self.countButton setTitle:[NSString stringWithFormat:@"%ld 张",self.buttonImageArr.count] forState:UIControlStateNormal];
}


-(void)setButtonImageArr:(NSArray *)buttonImageArr{
    _buttonImageArr = buttonImageArr;
    
    NSMutableArray *images = [NSMutableArray array];
    if (buttonImageArr.count <= 3) {
        [images addObjectsFromArray:buttonImageArr];
    }else if (buttonImageArr.count > 3){
        for (int i = 0; i < buttonImageArr.count; i ++) {
            if (i < 3) {
                [images addObject:buttonImageArr[i]];
            }
        }
    }
    
    _images = images;
    
    // 设置图片
    NSMutableArray *imagesM = [NSMutableArray arrayWithArray:images];
    [imagesM insertObject:[images lastObject] atIndex:0];
    [imagesM addObject:[images firstObject]];
    
    for (int i = 0; i < imagesM.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
        //NSString *requestURL = [NSString stringWithFormat:@"%@%@", BER_IMAGE_HOST, dic[@"pic"]];
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BER_IMAGE_HOST,imagesM[i]];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_mine_ground"]];
        [_scrollView addSubview:imageView];
        
    }
    
    _pageControl.numberOfPages = images.count;        // 总页数
    CGSize size = [_pageControl sizeForNumberOfPages:images.count]; // 控件尺寸
    _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    _scrollView.contentSize = CGSizeMake(imagesM.count * _scrollView.bounds.size.width, 0);
    
    [self setNeedsLayout];
    [self startTimer];
    
    
    if (self.isShowButton == YES) {
        [self.countButton setTitle:[NSString stringWithFormat:@"%ld 张",buttonImageArr.count] forState:UIControlStateNormal];
    }
}

-(void)layoutSubviews{
    
    // 计算imageView的位置
    [_scrollView.subviews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        CGRect frame = imageView.frame;// 调整x => origin => frame
        frame.origin.x = idx * frame.size.width;
        imageView.frame = frame;
    }];
//    _pageControl.center = CGPointMake(self.frame.size.width * 0.8, self.frame.size.height * 0.9);
    
}

- (void)startTimer{
    if (self.timer == nil) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
}

- (void)invalidateTimer{
    [self.timer invalidate];
    self.timer = nil;
}


- (void)updateTimer
{
    [UIView animateWithDuration:1.5 animations:^{
        _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x + WINDOW_WIDTH, 0);
    }];
    
    [self scrollViewDidEndDecelerating:_scrollView];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        CGFloat offsetX = scrollView.contentOffset.x;
        if (offsetX == 0) {
            scrollView.contentOffset = CGPointMake(WINDOW_WIDTH * self.images.count, 0);
        }
        else if(offsetX == WINDOW_WIDTH *(self.images.count +1)){
            scrollView.contentOffset = CGPointMake(WINDOW_WIDTH, 0);
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    _pageControl.currentPage =(offsetX /WINDOW_WIDTH) - 1;
    int index = (int)self.pageControl.currentPage;
    self.descLabel.text = self.descs[index];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        [self invalidateTimer];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self.scrollView) {
        [self startTimer];
    }
}

@end
