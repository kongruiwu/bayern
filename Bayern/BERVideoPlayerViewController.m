//
//  BERVideoPlayerViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 15/7/29.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERVideoPlayerViewController.h"

@interface BERVideoPlayerViewController ()

@end

@implementation BERVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBackButton];
    [self drawTitle:@"视频"];
    [self setShareData];
}
-(void)doShare
{
    [[AppDelegate sharedInstance].window addSubview:self.shareView];
}
- (void)setShareData
{
    //set share data
    [BERShareModel sharedInstance].shareTitle =self.videotitle;
    [BERShareModel sharedInstance].shareUrl=self.videoUrl;
    UIImageView *imgView = [[UIImageView alloc] init];
    __block UIImageView *coverImg = imgView;
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BER_IMAGE_HOST,self.videoiconUrl]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        coverImg.image = image;
        [BERShareModel sharedInstance].shareImg = coverImg.image;
        
        [self drawShareButton];
       
    }];
}
#pragma mark - UMSocialDelegate/U盟分享代理

- (void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData {
    NSString *videoUrl =[BERShareModel sharedInstance].shareUrl;
    socialData.urlResource.url = videoUrl;
    
    NSString *title = [BERShareModel sharedInstance].shareTitle;
    
    if (platformName == UMShareToSina) {
        
        socialData.extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@ %@",title,videoUrl];
        socialData.extConfig.sinaData.shareImage = [BERShareModel sharedInstance].shareImg;
         //NSLog(@"%@",[BERShareModel sharedInstance].shareUrl);
    } else if (platformName == UMShareToWechatSession) {
        
        socialData.extConfig.wechatSessionData.url = videoUrl;
        socialData.extConfig.wechatSessionData.title = title;
        socialData.extConfig.wechatSessionData.shareImage = [BERShareModel sharedInstance].getWechatShareIcon;
        
    } else if (platformName == UMShareToWechatTimeline) {
        socialData.extConfig.wechatTimelineData.url = videoUrl;
        socialData.extConfig.wechatTimelineData.title = title;
        socialData.extConfig.wechatTimelineData.shareImage = [BERShareModel sharedInstance].getWechatShareIcon;
        
    } else if (platformName == UMShareToQQ) {
        
        socialData.extConfig.qqData.url = videoUrl;
        socialData.extConfig.qqData.title = title;
        socialData.extConfig.qqData.shareImage = [BERShareModel sharedInstance].getWechatShareIcon;
        
    } else if (platformName == UMShareToQzone) {
        socialData.extConfig.qzoneData.url = videoUrl;
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
    NSString *videoUrl = [BERShareModel sharedInstance].shareUrl;
    NSString *title = [BERShareModel sharedInstance].shareTitle;
    
    if (ShareType == ShareTypeWeibo) {
        
        shareArr = @[UMShareToSina];
        title = [NSString stringWithFormat:@"%@ %@",[BERShareModel sharedInstance].shareTitle,videoUrl];
        
    } else if (ShareType == ShareTypeWeixin) {
        
        shareArr = @[UMShareToWechatSession];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = videoUrl;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
        shareImage = [UIImage imageNamed:@"weixin_icon.png"];
        
    } else if (ShareType == ShareTypeWeixinFriend) {
        
        shareArr = @[UMShareToWechatTimeline];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = videoUrl;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
        shareImage = [UIImage imageNamed:@"weixin_icon.png"];
        
    } else if (ShareType == ShareTypeQzone) {
        
        shareArr = @[UMShareToQzone];
        [UMSocialData defaultData].extConfig.qzoneData.url = videoUrl;
        [UMSocialData defaultData].extConfig.qzoneData.title = title;
        [UMSocialData defaultData].extConfig.qzoneData.shareImage = shareImage;
        
    } else if (ShareType == ShareTypeQQ) {
        shareArr = @[UMShareToQQ];
        shareImage = [UIImage imageNamed:@"weixin_icon.png"];
        
        [UMSocialData defaultData].extConfig.qqData.url = videoUrl;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
