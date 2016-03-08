//
//  HupuCustomScrollViewController.m
//  games
//
//  Created by wusicong on 15/5/14.
//
//

#import "HupuCustomScrollViewController.h"

@interface HupuCustomScrollViewController ()
{

}
@end

@implementation HupuCustomScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private

- (void)initDisplay {
    //draw title scrollview
    [self.view addSubview:self.titleScrollView];
    
    //draw content scrollview
    [self.view addSubview:self.mainScrollView];

    [self setNavigationBar];
    [self addContentControllers];
    
}

- (void)setNavigationBar { //重绘导航和数据列表
    if (self.navScrollTitleArray.count == 0) {
        return;
    }
    [self.titleScrollView createWithTitleArr:self.navScrollTitleArray];
    [self.mainScrollView setContentSize:CGSizeMake(WindowWidth * self.navScrollTitleArray.count, self.mainScrollView.frame.size.height)];
}

- (void)addContentControllers {
    if (self.contentControllerArray.count == 0) {
        return;
    }
    
    for (int i = 0; i < self.contentControllerArray.count; i ++) {
        id object = self.contentControllerArray[i];
        if ([object isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = object;
            vc.view.frame = CGRectMake(0 + self.mainScrollView.frame.size.width * i, 0, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height);
            [self.mainScrollView addSubview:vc.view];
        } else {
            continue;
        }
    }
}

- (NSInteger)getCurrentIndex {
    return self.mainScrollView.contentOffset.x / WindowWidth;
}

//设置当前导航数据
- (void)setTitleAndMainScrollWithIndex:(NSInteger)selectedIndex {
    [self.titleScrollView setTitleButtonColorWithSelectIndex:selectedIndex];
    [self.mainScrollView setContentOffset:CGPointMake(WindowWidth * selectedIndex, 0) animated:YES];
    if ([self.delegate respondsToSelector:@selector(titleHupuCustomScrollViewDidClickWithIndex:)]) {
        [self.delegate titleHupuCustomScrollViewDidClickWithIndex:selectedIndex];
    }
}

#pragma mark - HupuTitleScrollViewDelegate

- (void)titleScrollViewIndexDidClickWithIndex:(NSInteger)index {
    DLog(@"nav title index -- [%ld]", (long)index);
    
    [self setTitleAndMainScrollWithIndex:index];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = scrollView.contentOffset.x / WindowWidth;
    [self setTitleAndMainScrollWithIndex:index];

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSInteger index = scrollView.contentOffset.x / WindowWidth;
    
    if (!decelerate) {
        
        [self setTitleAndMainScrollWithIndex:index];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark - getter

- (NSMutableArray *)contentControllerArray {
    if (_contentControllerArray != nil) {
        return _contentControllerArray;
    }
    _contentControllerArray = [[NSMutableArray alloc] init];
    return _contentControllerArray;
}

- (HupuTitleScrollView *)titleScrollView {
    if (!_titleScrollView) {
        _titleScrollView = [[HupuTitleScrollView alloc] initWithFrame:CGRectMake(0, 0, WindowWidth, tScrollHeight)];
        _titleScrollView.delegate = self;
        _titleScrollView.hideRightButton = YES;
        _titleScrollView.splitTitlePart = YES;
    }
    return _titleScrollView;
}

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, tScrollHeight, WindowWidth, WindowHeight - STATUS_BAR_H - NAV_BAR_H - tScrollHeight)];
        _mainScrollView.delegate = self;
        _mainScrollView.backgroundColor = [UIColor whiteColor];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
    }
    
    return _mainScrollView;
}

@end
