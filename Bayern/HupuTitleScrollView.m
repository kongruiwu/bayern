//
//  HupuTitleScrollView.m
//  games
//
//  Created by wusicong on 15/5/8.
//
//

#import "HupuTitleScrollView.h"

#define btnGap 0
#define title_Font 15
#define title_Font_Select 15+1

@implementation HupuTitleScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createWithTitleArr:(NSArray *)titleArr {
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat wholeWidth = WindowWidth;
    CGFloat setupBtnW = tScrollHeight;
    CGFloat setupBtnH = tScrollHeight;
    
    CGFloat setupBtnOriginX = setupBtnW + 2;
    
    if (self.hideRightButton) {
        setupBtnOriginX = 0;
    }
    CGFloat scrollW = wholeWidth - setupBtnOriginX;
    
    if (!self.titleButtonArray) {
        self.titleButtonArray = [NSMutableArray array];
    }
    if (!self.titleLabelArray) {
        self.titleLabelArray = [NSMutableArray array];
    }
    
    if (!self.titleScrollView) {
        UIScrollView *titleScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0 ,0, scrollW, tScrollHeight)];
        self.titleScrollView = titleScroll;
        titleScroll.backgroundColor = [UIColor whiteColor];
        titleScroll.showsHorizontalScrollIndicator = NO;
        titleScroll.showsVerticalScrollIndicator = NO;
        titleScroll.pagingEnabled = NO;
        titleScroll.delegate = self;
        titleScroll.clipsToBounds = YES;
        [self addSubview:titleScroll];
    }
    
    if (!self.rightBtn && !self.hideRightButton) {
        UIButton *setupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        setupBtn.frame = CGRectMake(wholeWidth - setupBtnOriginX, (tScrollHeight - setupBtnH)/2, setupBtnW, setupBtnH);
        setupBtn.backgroundColor = [UIColor whiteColor];
        [setupBtn setBackgroundImage:[UIImage imageNamed:@"arrange_btn"] forState:UIControlStateNormal];
        [setupBtn setBackgroundImage:[UIImage imageNamed:@"arrange_btn_1"] forState:UIControlStateSelected];
        [setupBtn setBackgroundImage:[UIImage imageNamed:@"arrange_btn_1"] forState:UIControlStateHighlighted];
        setupBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.rightBtn = setupBtn;
        [setupBtn addTarget:self action:@selector(setupDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:setupBtn];
    }
    
    //创建标题栏数（暂时不可滑动）
    CGFloat btnH = tScrollHeight;
    CGFloat btnW ;
    CGFloat scrollContentWidth = 0; //累计计算标题栏总长
    
    for (UIButton *btn in self.titleButtonArray) {
        [btn removeFromSuperview];
    }
    [self.titleButtonArray removeAllObjects];
    [self.titleLabelArray removeAllObjects];
    
    NSInteger titleFont = title_Font;
    
    for (int i = 0; i < titleArr.count; i ++) {
        CGSize titleStrSize = [self sizeOfString:titleArr[i] maxWidth:100 withFontSize:titleFont];
        btnW = titleStrSize.width + btnGap;
        
        if (self.splitTitlePart) {
            btnW = self.frame.size.width / titleArr.count;
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0 + scrollContentWidth, (tScrollHeight - btnH)/2, btnW, btnH);
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        btn.clipsToBounds = NO;
        [btn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleScrollView addSubview:btn];
        
        UILabel *titleLb = [[UILabel alloc] initWithFrame:btn.bounds];
        titleLb.text = titleArr[i];
        titleLb.backgroundColor = [UIColor clearColor];
        titleLb.font = [UIFont systemFontOfSize:title_Font];
        titleLb.textColor = [UIColor whiteColor];
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.text = titleArr[i];
        [btn addSubview:titleLb];
        
        scrollContentWidth += btnW;
        
        [self.titleButtonArray addObject:btn];
        [self.titleLabelArray addObject:titleLb];
    }
    
    self.titleScrollView.contentSize = CGSizeMake(scrollContentWidth, - tScrollHeight);
    
    if (!self.lineView) {
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectZero];
        self.lineView = lineV;
        lineV.backgroundColor = [UIColor bayernRedColor];
        [self addSubview:self.lineView];
    }
    
    [self setTitleButtonColorWithSelectIndex:0];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, tScrollHeight - 0.5, WindowWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xeeeeee alpha:1];
    [self addSubview:line];
}

- (void)setTitleButtonColorWithSelectIndex:(NSInteger)index {
    if (self.titleButtonArray.count == 0) {
        return;
    }
    
    [self.lineView removeFromSuperview];
    
    for (int i = 0; i < self.titleButtonArray.count ; i ++) {
        UIButton *btn = self.titleButtonArray[i];
        UILabel *titleLb = self.titleLabelArray[i];
        
        if (btn.tag == index) {
            titleLb.textColor = [UIColor bayernRedColor];
            titleLb.font = [UIFont systemFontOfSize:title_Font_Select];
            
            self.lineView.frame = CGRectMake(btnGap/2, btn.frame.size.height - 2, btn.frame.size.width, 2);
            [btn addSubview:self.lineView];
        } else {
            titleLb.textColor = [UIColor colorWithHex:0x999999 alpha:1];
            titleLb.font = [UIFont systemFontOfSize:title_Font];
        }
    }
    
    //需要滑动才触发标题栏目位移计算
    if (self.titleScrollView.contentSize.width - self.titleScrollView.frame.size.width <= 0) {
        return;
    }
    
    //设置标题栏滑动
    CGFloat offsetX = 0;
    
    for (int i = 0; i < index +1; i ++) {
        UIButton *btn = self.titleButtonArray[i];
        
        offsetX += btn.frame.size.width;
        
    }
    
    if (offsetX > self.titleScrollView.frame.size.width/2) {
        offsetX += (self.titleScrollView.frame.size.width/4);
    }
    
    offsetX -= self.titleScrollView.frame.size.width;
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    if (offsetX > self.titleScrollView.contentSize.width - self.titleScrollView.frame.size.width) {
        offsetX = self.titleScrollView.contentSize.width - self.titleScrollView.frame.size.width;
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations: ^{
                         [self.titleScrollView setContentOffset:CGPointMake(offsetX, self.titleScrollView.contentOffset.y)];
                     }
                     completion: ^(BOOL finished) {
                     }];
}

// 获取指定最大宽度和字体大小的string的size
- (CGSize)sizeOfString:(NSString *)string maxWidth:(float)width withFontSize:(NSInteger)fontSize {
    
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:fontSize] };
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return size;
}

#pragma mark - Delegate Send

- (void)titleButtonClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    if ([self.delegate respondsToSelector:@selector(titleScrollViewIndexDidClickWithIndex:)]) {
        [self.delegate titleScrollViewIndexDidClickWithIndex:btn.tag];
    }
    
    [self setTitleButtonColorWithSelectIndex:btn.tag];
}

- (void)setupDidClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(titleScrollViewSetupButtonDidClick)]) {
        [self.delegate titleScrollViewSetupButtonDidClick];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

@end
