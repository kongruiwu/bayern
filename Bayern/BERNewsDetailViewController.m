//
//  NFLNewsViewController.m
//  HupuNFL
//
//  Created by Wusicong on 15/1/14.
//  Copyright (c) 2015年 hupu.com. All rights reserved.
//

#import "BERNewsDetailViewController.h"
#import "Util_UI.h"
#import "CommentTextView.h"
#import "CommentViewController.h"
#import "PrentLoginViewController.h"
#import "BERNavigationController.h"
#import "CommentView.h"
#import "NewsDetailModel.h"
#import "VoteDetailModel.h"
#import "TagNewsListViewController.h"
@interface BERNewsDetailViewController () <UIWebViewDelegate, UMSocialUIDelegate,UITextViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIView * blackView;
@property (nonatomic, strong) UIButton * commentCount;
@property (nonatomic, strong) CommentView * commentView;
@property (nonatomic, assign) BOOL commentSuccess;
@property (nonatomic, strong) NewsDetailModel * model;
@property (nonatomic, strong) VoteDetailModel * vote;
@property (nonatomic, strong) UIImage * shareImage;
@property (nonatomic, strong) UIImage * shareIamge2;
@property (nonatomic, assign) int comentNumber;
@end

@implementation BERNewsDetailViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerNotification];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeNotification];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *title = @"新闻";
    if (self.isPictureType) {
        title = @"图片";
    }
    [self drawShareButton];
    [self drawBackButton];
    [self drawTitle:title];
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
    [self creatCommentTextf];
    [self getNewsDetail];
    
    
}
- (void)drawShareButton{
    UIView * leftView = [Factory creatViewWithColor:[UIColor clearColor]];
    leftView.frame = CGRectMake(0, 0, Anno750(250), 44);
    UIButton * shareButton = [Factory creatButtonWithNormalImage:@"share" selectImage:nil];
    [shareButton addTarget:self action:@selector(doShare) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(Anno750(40)));
        make.width.equalTo(@(Anno750(35)));
        make.right.equalTo(@0);
        make.centerY.equalTo(@0);
    }];
    self.commentCount = [Factory creatButtonWithTitle:@"" textFont:font750(24) titleColor:[UIColor whiteColor]
                                      backGroundColor:[UIColor clearColor]];
    [self.commentCount setImage:[UIImage imageNamed:@"statusbar_talk"] forState:UIControlStateNormal];
    [self.commentCount addTarget:self action:@selector(pushTocommentViewController) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:self.commentCount];
    [self.commentCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(shareButton.mas_left).offset(-Anno750(20));
        make.centerY.equalTo(@0);
    }];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    self.navigationItem.rightBarButtonItem = leftItem;
}
- (void)pushTocommentViewController
{
    CommentViewController * vc = [[CommentViewController alloc]init];
    vc.newsID = self.news_id;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    DLog(@"dealloc BERNewsDetailViewController");
}



#pragma mark - Private Method

- (void)initModel {
    
}

- (void)initDisplay {
    CGRect frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH - Anno750(80));
    self.webView = [[UIWebView alloc] initWithFrame:frame];
    self.webView.delegate = self;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scalesPageToFit = YES;
    self.webView.contentMode = UIViewContentModeRedraw;
    self.webView.opaque = YES;
    [self.view addSubview:self.webView];
}

- (void)doShare {
    [self setShareDataWithNews:YES];
    [[AppDelegate sharedInstance].window addSubview:self.shareView];
}
- (void)htmlShare{
    [self setShareDataWithNews:NO];
    [[AppDelegate sharedInstance].window addSubview:self.shareView];
}
#pragma mark - Request

- (void)setShareDataWithNews:(BOOL)rec{
    if (rec) {
        [BERShareModel sharedInstance].shareTitle = self.model.title;
        [BERShareModel sharedInstance].shareID = [NSString stringWithFormat:@"%@",self.model.id];
        [BERShareModel sharedInstance].shareImg = self.shareImage;
        [BERShareModel sharedInstance].shareUrl = [[BERShareModel sharedInstance] getShareURL:YES];
    }else{
        [BERShareModel sharedInstance].shareTitle = self.vote.share_title;
        [BERShareModel sharedInstance].shareUrl = self.vote.share_link;
        [BERShareModel sharedInstance].shareImg = self.shareIamge2;
    }
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
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString * requestString = [NSString stringWithFormat:@"%@",request];
    if ([requestString containsString:@"fcbayern:"]) {
        if ([requestString containsString:@"vote_share"]) {
            NSArray * arr = [requestString componentsSeparatedByString:@"&"];
            for (NSString * str in arr) {
                if ([str containsString:@"vid"]) {
                    NSArray * params = [str componentsSeparatedByString:@"="];
                    [self.view showLoadWithAnimated:YES];
                    [self getVoteDeatilWithvoteid:params.lastObject];
                }
            }
        }else if([requestString containsString:@"login"]){
            BERNavigationController * nvc = [[BERNavigationController alloc]initWithRootViewController:[PrentLoginViewController new]];
            [self presentViewController:nvc animated:YES completion:nil];
        }else if([requestString containsString:@"news_more_commnet"]){
            [self pushTocommentViewController];
        }else if([requestString containsString:@"tag_news_list"]){
            NSString * string = [requestString stringByReplacingOccurrencesOfString:@"}" withString:@""];
            NSString * string1 = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray * arr = [string1 componentsSeparatedByString:@"&"];
            for (NSString * str in arr) {
                if ([str containsString:@"tag_id"]) {
                    NSArray * params = [str componentsSeparatedByString:@"="];
                    TagNewsListViewController * vc = [[TagNewsListViewController alloc]init];
                    NSString * tagStr = params.lastObject;
                    vc.tag_id = tagStr;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
        return NO;
    }
    return YES;
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
    NSString *gameUrl = [BERShareModel sharedInstance].shareUrl;
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
- (void)creatCommentTextf{
    UIView * footerView = [Factory creatViewWithColor:COLOR_BACKGROUND];
    footerView.frame = CGRectMake(0, SCREENHEIGH - Anno750(80) - 64, SCREENWIDTH, Anno750(80));
    [self.view addSubview:footerView];
    
    UIView * whiteView = [Factory creatViewWithColor:[UIColor whiteColor]];
    whiteView.layer.cornerRadius = Anno750(30);
    [footerView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.right.equalTo(@(-Anno750(30)));
        make.centerY.equalTo(@0);
        make.height.equalTo(@(Anno750(60)));
    }];
    UIImageView * icon = [Factory creatImageViewWithImageName:@"comment"];
    [whiteView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(20)));
        make.height.with.equalTo(@(Anno750(25)));
        make.centerY.equalTo(@0);
    }];
    UILabel * label = [Factory creatLabelWithTitle:@"评论"
                                         textColor:COLOR_CONTENT_GRAY_6 textFont:font750(28) textAlignment:NSTextAlignmentLeft];
    [footerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(Anno750(20));
        make.centerY.equalTo(@0);
    }];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(presentKeyBoard)];
    [footerView addGestureRecognizer:tap];

    self.commentView = [[CommentView alloc]init];
    self.commentView.frame = CGRectMake(0, SCREENHEIGH, SCREENWIDTH, Anno750(250));
    [self.commentView.commitButton addTarget:self action:@selector(commitComment) forControlEvents:UIControlEventTouchUpInside];
    self.commentView.textView.delegate = self;
}

- (void)commitComment{
    
    if ([UserInfo defaultInfo].uid && [[UserInfo defaultInfo].uid intValue]>0) {
        [self.commentView startLoading:YES];
        [self addCommentRequest];
        
    }else{
        [self.commentView.textView resignFirstResponder];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"登陆提示" message:@"你好，请登陆后发表你的回复，我们期待你参与讨论！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * login = [UIAlertAction actionWithTitle:@"登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            BERNavigationController * nav = [[BERNavigationController alloc]initWithRootViewController:[PrentLoginViewController new]];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }];
        UIAlertAction * cannce = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:login];
        [alert addAction:cannce];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
}
- (void)addCommentRequest{
    [self.view showLoadWithAnimated:YES];
    
    NSString * userid = [NSString stringWithFormat:@"%@",[UserInfo defaultInfo].uid];
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSDictionary * params = @{
                              @"nid":self.news_id,
                              @"uid":userid,
                              @"callback_verify":token,
                              @"content":self.commentView.textView.text
                              };
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    __weak BERNewsDetailViewController * weakSelf = self;
    [manager GET:[BERApiProxy urlWithAction:@"news"] parameters:[BERApiProxy paramsWithDataDic:params action:@"add_comment"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        [self.commentView startLoading:NO];
        if ([dic[@"code"] integerValue] == 0) {
            self.commentSuccess = YES;
            [self.commentView.textView endEditing:YES];
        }
        weakSelf.comentNumber  += 1;
        [weakSelf.commentCount setTitle:[NSString stringWithFormat:@"%d",weakSelf.comentNumber] forState:UIControlStateNormal];
        [weakSelf.view hideLoadWithAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.view hideLoadWithAnimated:YES];
        [self.commentView startLoading:NO];
    }];
    
}
- (void)getVoteDeatilWithvoteid:(NSString *)voteid{
    NSString * userid;
    if ([UserInfo defaultInfo].uid){
        userid = [NSString stringWithFormat:@"%@",[UserInfo defaultInfo].uid];
    }else{
        userid = @"0";
    }
    NSDictionary * params = @{
                              @"id":voteid,
                              @"uid":userid
                              };
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    __weak BERNewsDetailViewController * weakSelf = self;
    [manager GET:[BERApiProxy urlWithAction:@"other"] parameters:[BERApiProxy paramsWithDataDic:params action:@"get_vote"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] integerValue] == 0) {
            weakSelf.vote = [[VoteDetailModel alloc]initWithDictionary:dic[@"data"]];
            weakSelf.shareIamge2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:weakSelf.vote.share_pic]]];
            [weakSelf.view hideLoadWithAnimated:YES];
            [weakSelf htmlShare];
        }else{
            [weakSelf.view hideLoadWithAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.view hideLoadWithAnimated:YES];
    }];
}

- (void)getNewsDetail{
    NSDictionary * params = @{
                              @"id":self.news_id,
                              };
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    __weak BERNewsDetailViewController * weakSelf = self;
    [manager GET:[BERApiProxy urlWithAction:@"news"] parameters:[BERApiProxy paramsWithDataDic:params action:@"get_detail"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        if ([dic[@"code"] integerValue] == 0) {
            NSDictionary * data = dic[@"data"];
            NewsDetailModel * model = [[NewsDetailModel alloc]initWithDictionary:data];
            self.comentNumber = [model.comment_count intValue];
            [weakSelf.commentCount setTitle:[NSString stringWithFormat:@"%d",self.comentNumber] forState:UIControlStateNormal];
            self.model = model;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                self.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.pic]]];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
- (void)creatBlackView{
    self.blackView = [Factory creatViewWithColor:COLOR_BACK_ALPHA_8];
    self.blackView.hidden = YES;
    [self.navigationController.view addSubview:self.blackView];
    [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.blackView addSubview:self.commentView];
}
- (void)presentKeyBoard{
    self.blackView.hidden = NO;
    self.commentView.textView.text = @"";
    [self.commentView.textView becomeFirstResponder];
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        [self.commentView.textView showAllUI:YES];
    }else{
        [self.commentView.textView showAllUI:NO];
    }
}
- (void)registerNotification{
    [self creatBlackView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];

}
- (void)removeNotification{
    [self.blackView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyBoardWillShow:(NSNotification *)noti{
    NSDictionary *info = [noti userInfo];
    CGFloat time = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:time animations:^{
        self.commentView.frame = CGRectMake(0, SCREENHEIGH -Anno750(250)-kbSize.height, SCREENWIDTH, Anno750(250));
    }];
}
- (void)keyboardWillHidden:(NSNotification *)noti{
    NSDictionary *info = [noti userInfo];
    CGFloat time = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:time animations:^{
        self.commentView.frame = CGRectMake(0, SCREENHEIGH, SCREENWIDTH, Anno750(250));
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.blackView.hidden = YES;
        if (self.commentSuccess) {
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"评论发表成功!"
                                 duration:1.0f completion:^{
                                     self.commentSuccess = NO;
        }];
        }
    });
}


@end
