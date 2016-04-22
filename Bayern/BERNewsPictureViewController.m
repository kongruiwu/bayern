//
//  NFLNewsPictureViewController.m
//  HupuNFL
//
//  Created by Wusicong on 15/1/14.
//  Copyright (c) 2015年 hupu.com. All rights reserved.
//

#import "BERNewsPictureViewController.h"
#import "Util_UI.h"
#import "BERNewsPicModel.h"
#import "BERHeadFile.h"

#define DetailView_H 250/2
#define LabelGap 10

#define titleFont 15
#define pagingFont 14

#define blackColor [UIColor colorWithHex:0x1b1b1b alpha:1]

@interface BERNewsPictureViewController () <UIScrollViewDelegate, UMSocialUIDelegate>
{
    NSInteger zoomIndex;
    UITapGestureRecognizer *tap;
}

@property (nonatomic, strong) UIScrollView *scrollViewBG;
@property (nonatomic, strong) NSMutableArray *imgArray;

@property (nonatomic, strong) NSMutableArray *newsDataArray;

@property (nonatomic, strong) UIView *detailBG;
@property (nonatomic, strong) UIView *detailAlphaBG;

@property (nonatomic, strong) UILabel *newsTitleLb;
@property (nonatomic, strong) UILabel *newsPagingLb;

@property NSInteger photoIndex; //横竖屏时记录当前photo的index
@property BOOL canRequestNext; //已经请求了下一个

@property BOOL isHide;

@property (nonatomic, strong) UMSocialIconActionSheet *umsocialActionSheet;

@end

@implementation BERNewsPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [BERMainCenter sharedInstance].shouldAppRotateForRootVC = YES;
    
    self.view.backgroundColor = blackColor;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_2.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [self drawTitle:@"图片"];
    [self drawBackButton];
    if ([BERShareModel sharedInstance].shareID.length > 0) {
        [self drawShareButton];
    }
    
    [self initModel];
    [self initDisplay];
    
    [self requestNews:NO];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    DLog(@"dealloc BERNewsPictureViewController");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


#pragma mark - Private Method

- (void)initModel {
    self.imgArray = [NSMutableArray array];
    self.newsDataArray = [NSMutableArray array];
    
    self.canRequestNext = YES; //默认开锁
    
    self.photoIndex = 0;
    zoomIndex=0;
    self.isHide = NO; //默认导航栏、detailBG显示
}

- (void)initDisplay {
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectZero];
    sv.backgroundColor = blackColor;
    sv.delegate = self;
    sv.showsHorizontalScrollIndicator = NO;
    sv.showsVerticalScrollIndicator = NO;

    sv.pagingEnabled = YES;
    self.scrollViewBG = sv;
    [self.view addSubview:sv];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doHide)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)redrawDetailViewWithDic:(NSArray *)dataArr {
    self.newsDataArray = [NSMutableArray arrayWithArray:dataArr];
    
    for (UIImageView *icon in self.imgArray) {
        [icon removeFromSuperview];
    }
    [self.imgArray removeAllObjects];
    
    self.photoIndex = 0;
    
    if (!self.detailBG) {
        
        UIView *viewBG = [[UIView alloc] init];
        viewBG.backgroundColor = [UIColor clearColor];
        self.detailBG = viewBG;
        [self.view addSubview:viewBG];
        
        UIView *viewBG_Alpha = [[UIView alloc] init];
        viewBG_Alpha.backgroundColor = [UIColor colorWithHex:0x1b1b1b alpha:1];
        viewBG_Alpha.alpha = 0.7;
        self.detailAlphaBG = viewBG_Alpha;
        [viewBG addSubview:viewBG_Alpha];
        
        UILabel *titleLb = [[UILabel alloc] init];
        self.newsTitleLb = titleLb;
        titleLb.font = [UIFont systemFontOfSize:titleFont];
        titleLb.numberOfLines = 0;
        
        titleLb.textColor = [UIColor whiteColor];
        [viewBG addSubview:titleLb];
        
        UILabel *pagLb = [[UILabel alloc] init];
        self.newsPagingLb = pagLb;
        pagLb.font = [UIFont systemFontOfSize:pagingFont];
        pagLb.textColor = [UIColor whiteColor];
        pagLb.textAlignment = NSTextAlignmentCenter;
        [viewBG addSubview:pagLb];
        
        
        
    }
    CGRect frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    for (int i = 0; i < [self.newsDataArray count]; i ++) {
        UIImageView *icon = [[UIImageView alloc] initWithFrame:frame];
        icon.backgroundColor = [UIColor clearColor];
        icon.contentMode = UIViewContentModeScaleToFill;
        icon.clipsToBounds = NO;
        icon.layer.borderColor = blackColor.CGColor;
        icon.layer.borderWidth = 2;
        UIScrollView *sc=[[UIScrollView alloc]initWithFrame:frame];
        sc.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        //sc.autoresizesSubviews=YES;
        sc.showsHorizontalScrollIndicator = NO;
        sc.showsVerticalScrollIndicator = NO;
        sc.maximumZoomScale=2.0f;
        sc.minimumZoomScale=1.0f;
        sc.zoomScale=1.0f;
        sc.delegate = self;
        sc.bounces = NO;
        sc.tag =800+i;
        UIView * imgBG=[[UIView alloc]initWithFrame:frame];
        imgBG.tag= 500+i;
        icon.tag = 600+i;
        [sc addSubview:imgBG];
        [self.scrollViewBG addSubview:sc];
        
        __block UIImageView *coverImg = icon;
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BER_IMAGE_HOST, [self.newsDataArray objectAtIndex:i][@"pic"]]];
        NSLog(@"url == %@",url);
        if ([BERNetworkManager isNetworkOkay]) {
            [icon showInfo:@"图片加载中，请稍后" activity:YES];
            [icon sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                coverImg.contentMode = UIViewContentModeScaleAspectFit;
                [coverImg hideLoadWithAnimated:YES];
                coverImg.image = image;
            }];
            [imgBG addSubview:icon];
            [self.imgArray addObject:sc];
        } else {
            icon.image = [UIImage imageNamed:@"photoLoading.png"];
            icon.contentMode = UIViewContentModeCenter;
        }
    }
    
    [self reframeUI];
    [self resetDetailData];
    
}

- (void)resetDetailData {
    self.photoIndex = [self getPhotoIndex];
    NSString * str2= [NSString stringWithFormat:@"%ld/%lu", (long)(self.photoIndex + 1),(unsigned long)[self.newsDataArray count]];
    NSString * str3= [[BERNewsPicModel sharedInstance] getCurrentNewsTitleWithNewsID:self.news_id];
    NSString * str =[self.newsDataArray[self.photoIndex] objectForKey:@"title"];
    if (str.length >1) {
        self.newsTitleLb.text = [NSString stringWithFormat:@"%@   %@",str2,str];
    }else{
        self.newsTitleLb.text = [NSString stringWithFormat:@"%@   %@",str2,str3];
    }
    
}

- (void)doBack {
    [BERMainCenter sharedInstance].shouldAppRotateForRootVC = NO;
    
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight)
    {
        //横屏状态直接返回竖屏
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }

    [super doBack];
}

- (NSInteger)getPhotoIndex {
    NSInteger index = self.scrollViewBG.contentOffset.x / WindowWidth;
    
    return index;
}

- (void)imageButtonDidClick {
    UIImageWriteToSavedPhotosAlbum([(UIImageView *)self.imgArray[self.photoIndex] image], self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [self.view showInfo:@"图片保存成功" autoHidden:YES];
    }
}


#pragma mark - 分享
- (void)doShare {
    
    [[AppDelegate sharedInstance].window addSubview:self.shareView];
}

#pragma mark - Tap Method

- (void)doHide {
    DLog(@"doHide");
    
    if (self.isHide) { //显示
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        self.detailBG.alpha = 1;
        
    } else { //隐藏
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        self.detailBG.alpha = 0;
    }
    
    self.isHide = !self.isHide;
    
    [self reframeUI];
}

#pragma mark - Request Method

- (void)requestNews:(BOOL)isNext {
    
    if (isNext) { //滑动触发下一图集，查看缓存中是否有下一图集可看
        NSString *nextNewsID = [[BERNewsPicModel sharedInstance] getNextNewdIDWithCurrentNewdID:self.news_id];
        if (nextNewsID.length == 0 || nextNewsID == nil) {
            return;
        } else {
            self.news_id = nextNewsID;
        }
    }
    
    if (![BERNetworkManager isNetworkOkay]) {
        [self.view showInfo:NetworkErrorTips autoHidden:YES];
        return;
    }
    
    self.canRequestNext = NO; //请求下一个新闻图集时需要先加锁
    
    [self.view showLoadingActivity:YES];
    
    NSDictionary *params = nil;
    params = @{
               @"id"    :   self.news_id
               };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BERApiProxy urlWithAction:@"album"] parameters:[BERApiProxy paramsWithDataDic:params action:@"get_detail"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        DLog(@"news detail photo response [%@]", responseObject);
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] integerValue] == 0) {
            
            [self redrawDetailViewWithDic:dic[@"data"]];
        }
        [self.view hideLoadWithAnimated:YES];
        self.canRequestNext = YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view hideLoadWithAnimated:YES];
        self.canRequestNext = YES;
        
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView==self.scrollViewBG) {
    if (scrollView.contentOffset.x + WindowWidth > scrollView.contentSize.width + 20) {
        if (self.canRequestNext) {
            DLog(@"触发下一图集请求");
            [self requestNews:YES]; //加载下一页数据
        } else {
            DLog(@"已触发下一图集请求，不再请求");
        }
        }
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    NSInteger x=self.scrollViewBG.contentOffset.x/WindowWidth;
    UIView *view=(UIView *)[self.scrollViewBG viewWithTag:500+x];
    zoomIndex=x;
    return view;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView==self.scrollViewBG) {
        [self resetDetailData];
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView==self.scrollViewBG) {
        if (!decelerate) {
            [self resetDetailData];
        }
        [self setZoomBack];
    }
    
}
-(void)setZoomBack
{
    UIScrollView * sc=(UIScrollView *)[self.scrollViewBG viewWithTag:800+zoomIndex];
    [sc setZoomScale:1.0];
}
#pragma mark - Orientation Method

- (void)orientationDidChange:(NSNotification *)notification {
    [self reframeUI];
}

- (void)reframeUI {
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown)
    {
        return;
    }
    
    DLog(@"photo player orientation [%ld]", [[UIDevice currentDevice] orientation]);
    DLog(@"nav frame height [%f]", self.navigationController.navigationBar.frame.size.height);
    
    NSInteger winHeight = self.view.frame.size.height;
    NSInteger winWidth = self.view.frame.size.width;
    
    DLog(@"winW[%ld] winH[%ld]", (long)winWidth, (long)winHeight);
    
    //reset subviews
    self.scrollViewBG.frame = CGRectMake(0 , 0, winWidth, winHeight);
    
    self.scrollViewBG.contentSize = CGSizeMake(winWidth * [self.newsDataArray count], winHeight);
    self.scrollViewBG.contentOffset = CGPointMake(0 + winWidth * self.photoIndex, 0);
    
    //横竖屏时，先以上一次横竖屏时photo的index为准位移scrollView
    CGFloat contentLbW = winWidth - LabelGap *2;
    NSString *contentString = [[BERNewsPicModel sharedInstance] getCurrentNewsTitleWithNewsID:self.news_id];
    CGSize contentLbSize;
    contentLbSize = [Util_UI sizeOfString:contentString maxWidth:contentLbW withFontSize:15];
    
    if (contentString.length == 0) {
        contentLbSize = CGSizeMake(0, 0);
    }
    
    CGFloat titleLb_H = 20;
    CGFloat detailBG_Height = contentLbSize.height + LabelGap * 3 + titleLb_H;
    
    
    self.detailBG.frame = CGRectMake(0, winHeight - detailBG_Height, winWidth, detailBG_Height);
    
    CGFloat pageLbW = 0;
    CGFloat titleLbw = winWidth - LabelGap * 3 - pageLbW;
    
    self.detailAlphaBG.frame = CGRectMake(0, 0, winWidth, detailBG_Height);
    self.newsPagingLb.frame = CGRectMake(0, 0, 0, 0);
    
    self.newsTitleLb.frame = CGRectMake(self.newsPagingLb.frame.origin.x + self.newsPagingLb.frame.size.width + LabelGap, LabelGap, titleLbw, contentLbSize.height+20);
    

    for (int i = 0; i < [self.newsDataArray count]; i ++) {
        UIScrollView *icon = self.imgArray[i];
        
        icon.contentMode = UIViewContentModeScaleToFill;
        icon.frame = CGRectMake(0 + winWidth * i, 0, winWidth, self.scrollViewBG.frame.size.height);
        UIView * view = (UIView *)[self.view viewWithTag:(icon.tag - 800 + 500)];
        view.frame = CGRectMake(0, 0, winWidth, self.scrollViewBG.frame.size.height);
        UIImageView * imgView = (UIImageView *)[self.view viewWithTag:(icon.tag - 800 + 600)];
        imgView.frame = CGRectMake(0, 0, winWidth, self.scrollViewBG.frame.size.height);
        
    }
    
    if (self.umsocialActionSheet) {
        [self.umsocialActionSheet dismiss];
    }
    
    self.shareView.frame = CGRectMake(0, 0, WindowWidth, WindowHeight);
    [self.shareView resizeUI];
}

#pragma mark - UMSocialDelegate

- (void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData {
    NSString *gameUrl = [[BERShareModel sharedInstance] getShareURL:NO];
    socialData.urlResource.url = gameUrl;
    
    NSString *title = [BERShareModel sharedInstance].shareTitle;
    
    if (platformName == UMShareToSina) {
        
        socialData.extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@ %@",title,gameUrl];
        socialData.extConfig.sinaData.shareImage = [BERShareModel sharedInstance].shareImg;
        
    } else if (platformName == UMShareToWechatSession) {
        
        socialData.extConfig.wechatSessionData.url = gameUrl;
        socialData.extConfig.wechatSessionData.title = title;
        socialData.extConfig.wechatSessionData.shareImage = [BERShareModel sharedInstance].getWechatShareIcon;
        
    } else if (platformName == UMShareToWechatTimeline) {
        socialData.extConfig.wechatTimelineData.url = gameUrl;
        socialData.extConfig.wechatTimelineData.title = title;
        socialData.extConfig.wechatTimelineData.shareImage = [BERShareModel sharedInstance].getWechatShareIcon;
        
    } else if (platformName == UMShareToQQ) {
        
        socialData.extConfig.qqData.url = gameUrl;
        socialData.extConfig.qqData.title = title;
        socialData.extConfig.qqData.shareImage = [BERShareModel sharedInstance].getWechatShareIcon;
        
    } else if (platformName == UMShareToQzone) {
        socialData.extConfig.qzoneData.url = gameUrl;
        socialData.extConfig.qzoneData.title = title;
        socialData.extConfig.qzoneData.shareImage = [[BERShareModel sharedInstance] shareImg];
    }
}

- (void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType {
    if (fromViewControllerType == UMSViewControllerActionSheet) {
        DLog(@"share action sheet dismiss");
    }
}

- (BOOL)isDirectShareInIconActionSheet {
    return NO;
}

#pragma mark - NFLShareDelegate

- (void)shareButtonDidClickWithType:(ShareType)ShareType {
    
    NSArray *shareArr = nil;
    
    //设置分享内容
    UIImage *shareImage = [BERShareModel sharedInstance].shareImg;
    
    NSString *gameUrl = [[BERShareModel sharedInstance] getShareURL:NO];
    NSString *title = [BERShareModel sharedInstance].shareTitle;
    
    if (ShareType == ShareTypeWeibo) {
        
        shareArr = @[UMShareToSina];
        title = [NSString stringWithFormat:@"%@ %@",[BERShareModel sharedInstance].shareTitle,gameUrl];
        
    } else if (ShareType == ShareTypeWeixin) {
        
        shareArr = @[UMShareToWechatSession];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = gameUrl;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
        shareImage = [UIImage imageNamed:@"weixin_icon.png"];
        
    } else if (ShareType == ShareTypeWeixinFriend) {
        
        shareArr = @[UMShareToWechatTimeline];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = gameUrl;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
        shareImage = [UIImage imageNamed:@"weixin_icon.png"];
        
    } else if (ShareType == ShareTypeQzone) {
        
        shareArr = @[UMShareToQzone];
        [UMSocialData defaultData].extConfig.qzoneData.url = gameUrl;
        [UMSocialData defaultData].extConfig.qzoneData.title = title;
        [UMSocialData defaultData].extConfig.qzoneData.shareImage = shareImage;
        
    } else if (ShareType == ShareTypeQQ) {
        shareArr = @[UMShareToQQ];
        shareImage = [UIImage imageNamed:@"weixin_icon.png"];
        
        [UMSocialData defaultData].extConfig.qqData.url = gameUrl;
        [UMSocialData defaultData].extConfig.qqData.title = title;
        [UMSocialData defaultData].extConfig.qqData.shareImage = shareImage;
    }
    
    //截取比赛信息图
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:shareArr content:title image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            [self.view showInfo:@"分享成功" autoHidden:YES];
        }
    }];
    
    [self.shareView removeFromSuperview];
    self.shareView = nil;
}

@end
