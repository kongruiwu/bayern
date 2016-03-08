//
//  NFLNewsViewController.m
//  HupuNFL
//
//  Created by Wusicong on 15/1/14.
//  Copyright (c) 2015年 hupu.com. All rights reserved.
//

#import "BERNewsDetailViewController.h"
#import "Util_UI.h"

@interface BERNewsDetailViewController () <UIWebViewDelegate, UMSocialUIDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation BERNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *title = @"新闻";
    if (self.isPictureType) {
        title = @"图片";
    }
    [self drawTitle:title];
    
    
    if ([BERShareModel sharedInstance].shareID.length > 0) {
        [self drawShareButton];
    }
    
    [self initModel];
    [self initDisplay];
    
    //拼接news web view url
    NSURL *url = nil;
    if (self.news_url.length > 0) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.news_url]];
    } else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/news/%@?app=1",BER_WEBSITE,self.news_id]];
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    if (self.needFetchNewsData) {
        [self getNews];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    DLog(@"dealloc BERNewsDetailViewController");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private Method

- (void)initModel {
    
}

- (void)initDisplay {
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scalesPageToFit = YES;
    self.webView.contentMode = UIViewContentModeRedraw;
    self.webView.opaque = YES;
    [self.view addSubview:self.webView];
}

- (void)doShare {
//    //设置分享内容
//    UIImage *shareImage = [BERShareModel sharedInstance].shareImg;
//    NSString *title = [BERShareModel sharedInstance].shareTitle;
//    
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:UmengAppKey
//                                      shareText:title
//                                     shareImage:shareImage
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQQ,UMShareToQzone,nil]
//                                       delegate:self];
    
    [[AppDelegate sharedInstance].window addSubview:self.shareView];
}

#pragma mark - Request 

- (void)getNews {
    NSDictionary *params = @{
                            @"id"  :   self.news_id
                            };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BERApiProxy urlWithAction:@"news"] parameters:[BERApiProxy paramsWithDataDic:params action:@"get_detail"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        DLog(@"~~~~~news response [%@]", responseObject);
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] integerValue] == 0) {
            
            NSDictionary *dataDic = dic[@"data"];
            
            if (dataDic.count > 0) {
                [self setShareData:dataDic];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)setShareData:(NSDictionary *)dataDic {
    //set share data
    [BERShareModel sharedInstance].shareTitle = dataDic[@"title"];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    __block UIImageView *coverImg = imgView;
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BER_IMAGE_HOST, dataDic[@"pic"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        coverImg.image = image;
        [BERShareModel sharedInstance].shareImg = coverImg.image;
        
        [self drawShareButton];
    }];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.view showLoadingActivity:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.view hideLoadWithAnimated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.view hideLoadWithAnimated:YES];
}

#pragma mark - UMSocialDelegate

- (void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData {
    NSString *gameUrl = [[BERShareModel sharedInstance] getShareURL:YES];
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

- (BOOL)isDirectShareInIconActionSheet {
    return NO;
}

#pragma mark - NFLShareDelegate

- (void)shareButtonDidClickWithType:(ShareType)ShareType {
    
    NSArray *shareArr = nil;
    
    //设置分享内容
    UIImage *shareImage = [BERShareModel sharedInstance].shareImg;
    NSString *gameUrl = [[BERShareModel sharedInstance] getShareURL:YES];
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
