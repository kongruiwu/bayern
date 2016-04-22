//
//  YTImageBrowerController.m
//  YTImageBrowser
//
//  Created by TI on 15/8/24.
//  Copyright (c) 2015年 YccTime. All rights reserved.
//

#import "YTImageBrowerController.h"
#import "YTImageScroll.h"
#import "BERShowTextView.h"
#import "BERFactory.h"
#define Page_Lab_H  14.0f
#define Page_Scale  (4.9f/5.0f)
@interface YTImageBrowerController ()<UIScrollViewDelegate,UMSocialUIDelegate>
{
    NSInteger currentPageNumber,currentIndex;
    CGFloat priopPointX; // scrollView 划过的前一个点x坐标
    YTImageScroll * currentScroll;
    CGFloat angle;
    NSMutableArray * dataArray;
}

@property (nonatomic, assign) id<YTImageBrowerControllerDelegate> delegate;
@property (nonatomic, strong) NSArray * imgModels;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UILabel * pageLabel;
@property (nonatomic, strong) BERShowTextView * descView;
@property (nonatomic, strong) NSMutableArray * imgScrolls;

@end

@implementation YTImageBrowerController

#pragma mark - INIT (一切都是为了初始化)
- (NSMutableArray *)imgScrolls{
    if (!_imgScrolls) {
        _imgScrolls = [NSMutableArray arrayWithCapacity:2];
    }
    return _imgScrolls;
}

- (void)didReceiveMemoryWarning {
    [[NSURLCache sharedURLCache]removeAllCachedResponses];
    [super didReceiveMemoryWarning];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
- (instancetype)initWithDelegate:(id<YTImageBrowerControllerDelegate>)delegate Imgs:(NSArray *)imgs Urls:(NSArray *)urls PageIndex:(NSInteger)index{
    
    NSArray * imgMsgs = [YTImageModel IMGMessagesWithImgs:imgs Urls:urls];
    return [self initWithDelegate:delegate ImgModels:imgMsgs PageIndex:index];
}

- (instancetype)initWithDelegate:(id<YTImageBrowerControllerDelegate>)delegate ImgModels:(NSArray *)imgModels PageIndex:(NSInteger)index{
    if (self = [super init]) {
        self.delegate = delegate;
        self.imgModels = [imgModels copy];
        currentPageNumber = index;
        currentIndex = -1;
        [self initEnd];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [BERMainCenter sharedInstance].shouldAppRotateForRootVC = YES;
    [self setBeginValue];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceAngle) name:UIDeviceOrientationDidChangeNotification object:nil];

    [self getData];
    
}

//图片翻转
- (void)deviceAngle{
    UIDeviceOrientation  dev = [[UIDevice currentDevice] orientation];
    switch (dev) {
        case 3:
            angle = M_PI_2;
            break;
        case 4:
            angle = -M_PI_2;
            break;
        case 5:
        case 6:
        case 0:
            break;
        default:
            angle = 0.0f;
            break;
    }
}
- (void)initUI{
    [self addScrollView];
    [self addPageLabel];
    [self addGesture];
}
- (void)getData{
    if (![BERNetworkManager isNetworkOkay]) {
        [self.view showInfo:NetworkErrorTips autoHidden:YES];
        return;
    }
    [self.view showLoadingActivity:YES];
    NSDictionary *params = nil;
    params = @{
               @"id"    :   self.news_id
               };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BERApiProxy urlWithAction:@"album"] parameters:[BERApiProxy paramsWithDataDic:params action:@"get_detail"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] integerValue] == 0) {
            NSArray * dataArr = dic[@"data"];
            NSMutableArray * urls = [[NSMutableArray alloc]init];
            for (int i = 0; i<dataArr.count; i++) {
                NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BER_IMAGE_HOST, dataArr[i][@"pic"]]];
                [urls addObject:url];
                NSDictionary * dic = dataArr[i];
                [dataArray addObject:dic];
            }
            self.imgModels = [YTImageModel IMGMessagesWithImgs:nil Urls:urls];
            currentPageNumber = 0;
            currentIndex = -1;
            [self initUI];
        }
        [self.view hideLoadWithAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view hideLoadWithAnimated:YES];
    }];

}
- (void)setBeginValue{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_2.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self drawTitle:@"图片"];
    [self drawBackButton];
    if ([BERShareModel sharedInstance].shareID.length > 0) {
        [self drawShareButton];
    }
    dataArray = [[NSMutableArray alloc]init];
}
- (void)doBack{
    
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight)
    {
        //横屏状态直接返回竖屏
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }
    [BERMainCenter sharedInstance].shouldAppRotateForRootVC = NO;

    [super doBack];
}
#pragma mark - 分享
- (void)doShare {
    [[AppDelegate sharedInstance].window addSubview:self.shareView];
}
- (void)addScrollView{//添加scrollView
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.9];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
    [self scrollViewAddSubView];
    [self.view addSubview:self.scrollView];
}

- (void)addPageLabel{//添加 显示当前页码和总的页码UI
//    self.pageLabel = [[UILabel alloc]init];
//    self.pageLabel.textAlignment = NSTextAlignmentCenter;
//    self.pageLabel.font = [UIFont systemFontOfSize:12.0f];
//    self.pageLabel.textColor = [UIColor whiteColor];
//    self.pageLabel.text = [self pageText];
    self.descView = [[BERShowTextView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT* 2/3, SCREENWIDTH, SCREENHEIGHT/3)];
    self.descView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
    self.descView.pageLable.text = [self pageText];
    self.descView.titleLabel.text = self.titleName;
    self.descView.descLabel.text = dataArray[currentPageNumber][@"title"];
    [self.view addSubview:self.descView];
}

- (void)addGesture{//添加单击返回,双击缩放手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTap];
    
    [tap requireGestureRecognizerToFail:doubleTap];//单击优先级滞后于双击
    
}

- (void)scrollViewAddSubView{//scrollView添加内置IMGSeeScroll视图
    
    /* 提示：当图片数大于等于2张时，目前设计为2个IMGSeeScroll进行重用，修改需谨慎 */
    for (int i = 0; i < MIN(2, self.imgModels.count); i++) {
        YTImageScroll * imageScroll = [[YTImageScroll alloc]initWithFrame:self.scrollView.bounds];
        [self.scrollView addSubview:imageScroll];
        [self.imgScrolls addObject:imageScroll];
    }
    
    [self scrollviewIndex:currentPageNumber];
}

#pragma mark - layout Sub Views (横竖屏切换重新布局)
- (void)scrollViewLayoutSubViews{//重新布局scrollView内部的控件
    for (YTImageScroll * imageScroll in self.imgScrolls) {
        if (![imageScroll isKindOfClass:[YTImageScroll class]]) return;
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = (imageScroll.imgM.index) * (frame.size.width);
        imageScroll.frame = frame;
        [imageScroll layoutSubview];
    }
    
    [currentScroll replyStatuseAnimated:YES];
    [self.scrollView setContentOffset:currentScroll.frame.origin];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.scrollView.frame = self.view.bounds;
    
    CGSize size = self.scrollView.bounds.size;
    size.width *= self.imgModels.count;
    self.scrollView.contentSize = size;
    
//    CGRect frame = self.view.bounds;
//    frame.origin.y = (frame.size.height * Page_Scale) - Page_Lab_H;
//    frame.size.height = Page_Lab_H;
    CGFloat y =SCREENHEIGHT*2/3;
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
        y = SCREENHEIGHT*7/10;
    }
    CGRect frame = CGRectMake(0, y, SCREENWIDTH, SCREENHEIGHT - y);
    self.descView.frame = frame;
    
    [self scrollViewLayoutSubViews];
}

#pragma mark - Tap Gesture Recognizer action (手势)
- (void)tapAction:(UITapGestureRecognizer*)tap{
    [self delegateWillDismiss];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)doubleTapAction:(UITapGestureRecognizer*)doubleTap{
    [currentScroll doubleTapAction];
}

#pragma mark - Scroll View Deledate (scroll 代理)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!scrollView.isDragging) return;
    [self scrollViewDragging:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDragging:scrollView];
    
    for (YTImageScroll * sc in self.imgScrolls) {
        if (sc != currentScroll) {
            [sc replyStatuseAnimated:NO];
        }
    }
    [self pageHiden];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self pageShow];
}

#pragma mark - Image Scroll Reuse (imageScroll复用)
- (void)scrollViewDragging:(UIScrollView*)scrollView{
    CGFloat pointx = (scrollView.contentOffset.x)/(scrollView.bounds.size.width);
    
    if (scrollView.contentOffset.x > priopPointX) {
        [self scrollviewIndex:ceilf(pointx)];//取上整
    }else{
        [self scrollviewIndex:floorf(pointx)];//取下整
    }
    
    NSInteger integer = pointx+0.5;
    if (integer != currentPageNumber) {
        currentPageNumber = integer;
        self.descView.pageLable.text = [self pageText];
        self.descView.titleLabel.text = self.titleName;
        self.descView.descLabel.text = dataArray[currentPageNumber][@"title"];
//        self.pageLabel.text = [self pageText];
    }
    priopPointX = scrollView.contentOffset.x;
}
- (NSString*)pageText{
    return [NSString stringWithFormat:@"%d/%d",(int)(currentPageNumber+1),(int)(self.imgModels.count)];
}
- (void)scrollviewIndex:(NSInteger)index{
    if ((currentIndex == index)||(index >= self.imgModels.count)){
        return;
    }
    currentIndex = index;
    YTImageScroll * imageScroll = [self dequeueReusableScrollView];
    currentScroll = imageScroll;
    if (imageScroll.tag == index) return;
    
    [currentScroll replyStatuseAnimated:NO];
    CGRect frame = self.scrollView.bounds;
    frame.origin.x = index * (frame.size.width);
    imageScroll.frame = frame;
    imageScroll.tag = index;
    imageScroll.imgM = self.imgModels[index];
}

- (YTImageScroll*)dequeueReusableScrollView{
    YTImageScroll * imageScroll = self.imgScrolls.lastObject;
    [self.imgScrolls removeLastObject];
    [self.imgScrolls insertObject:imageScroll atIndex:0];
    return imageScroll;
}

#pragma mark - Page & Delegate Action (嗯哼...)
- (void)pageHiden{
    
}

- (void)pageShow{
    
}



- (void)initEnd{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ACDSeeControllerInitEnd:)]) {
        YTImageModel * imageModel = self.imgModels[currentPageNumber];
        [self.delegate ACDSeeControllerInitEnd:imageModel.size];
    }
}

- (void)delegateWillDismiss{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ACDSeeControllerWillDismiss:Img:Index:)]) {
        [self.delegate ACDSeeControllerWillDismiss:currentScroll.imgM.size Img:currentScroll.imgM.image Index:currentPageNumber];
    }
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
