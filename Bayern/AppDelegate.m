//
//  AppDelegate.m
//  Bayern
//
//  Created by wusicong on 15/6/1.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "AppDelegate.h"
#import "APService.h"
#import "BERNewsDetailViewController.h"
#import "BERNavigationController.h"
#import "BERNewsPictureViewController.h"
#import "BERVideoPlayerViewController.h"
#import "BERHeadFile.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
//如果 App 状态为未运行，此函数将被调用，如果launchOptions包含UIApplicationLaunchOptionsLocalNotificationKey表示用户点击apn 通知导致app被启动运行；如果不含有对应键值则表示 App 不是因点击apn而被启动，可能为直接点击icon被启动或其他。
+ (AppDelegate *)sharedInstance {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.mainViewController = [[BERMainViewController alloc] init];
    self.window.rootViewController = self.mainViewController;

    
    [self getConfigInfo];//获取配置信息
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#else
         //categories nil
         categories:nil];
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#endif
         // Required
         categories:nil];
    }
    //初始化APNS
    [APService setupWithOption:launchOptions];
    
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor blackColor];

    [self doSet];
    
    // apn 内容获取：
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    self.reseverInfo=[NSDictionary dictionaryWithDictionary:remoteNotification];
    
    [self getUserInfo];//获取用户信息
    return YES;
}
- (void)getUserInfo{
    
    [[BERUserManger shareMangerUserInfo] getInfo];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //极光推送添加
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    self.model=[[pushModel alloc]init];
    [self.model setValuesForKeysWithDictionary:self.reseverInfo];
    UIViewController *controller = self.mainViewController.centerPanel;
    if ([self.model.type intValue]==1||[self.model.type isEqualToString:@"video"]) {
        if (self.model.url.length>0) {
            BERVideoPlayerViewController *vc=[[BERVideoPlayerViewController alloc]init];
            vc.url=[NSURL URLWithString:self.model.url];
            [NFLAppLogManager sendLogWithEventID:EventID_Videos withKeyName:KN_VideosList andValueName:@"Videos"];
            [(BERNavigationController *)controller pushViewController:vc animated:NO];
            [self.mainViewController showCenterPanelAnimated:YES];
        }else
        {
            
        }
    }else if ([self.model.type intValue]==2||[self.model.type isEqualToString:@"news"])
    {
        BERNewsDetailViewController *vc=[[BERNewsDetailViewController alloc]init];
        vc.news_id=self.model.id;
        [NFLAppLogManager sendLogWithEventID:EventID_News withKeyName:KN_NewsList andValueName:@"News"];
        [(BERNavigationController *)controller pushViewController:vc animated:NO];
        [self.mainViewController showCenterPanelAnimated:YES];
    }else if([self.model.type intValue]==3||[self.model.type isEqualToString:@"photos"])
    {
        BERNewsPictureViewController *vc=[[BERNewsPictureViewController alloc]init];
        vc.news_id=self.model.id;
        [NFLAppLogManager sendLogWithEventID:EventID_Photos withKeyName:KN_PhotosList andValueName:@"Photos"];
        [(BERNavigationController *)controller pushViewController:vc animated:NO];
        [self.mainViewController showCenterPanelAnimated:YES];
    }else
    {
    //防错
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Private

- (void)doSet {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        //数据统计设置
        [MobClick startWithAppkey:UmengAppKey reportPolicy:BATCH   channelId:@"App Store"];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [MobClick setAppVersion:version];
        
        //第三方分享设置
        [UMSocialData setAppKey:UmengAppKey];
        
        //由于苹果审核政策需求，建议大家对未安装客户端平台进行隐藏，在设置QQ、微信AppID之前调用下面的方法
        [UMSocialConfig hiddenNotInstallPlatforms:nil];
        [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];
        
        //设置微信AppId、appSecret，分享url
        [UMSocialWechatHandler setWXAppId:WXAppId appSecret:WXAppSecret url:WXShareUrl];
        
        //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil

        [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaAppId secret:SinaAppSecret RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
        [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
        
        //设置分享到QQ/Qzone的应用Id，和分享url 链接
        [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQAppSecret url:WXShareUrl];
        
        
    });
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Demo.Bayern" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Bayern" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Bayern.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Global Access Helper

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated {
    [NFLAppLogManager sendLogWithEventID:EventID_Topbar withKeyName:KN_MainNav andValueName:@"Nav"];
    
    [self.mainViewController showLeftPanelAnimated:animated];
}

- (void)toggleRightDrawer:(id)sender animated:(BOOL)animated {
    [NFLAppLogManager sendLogWithEventID:EventID_Topbar withKeyName:KN_GameCenter andValueName:@"TabGameCenter"];
    
    [self.mainViewController showRightPanelAnimated:animated];
}

- (void)pushNewsWithNewsLink:(NSString *)newsLink {
    UIViewController *controller = self.mainViewController.centerPanel;
    
    if ([controller isKindOfClass:[BERNavigationController class]]) {
        BERNewsDetailViewController *nv = [[BERNewsDetailViewController alloc] init];
        nv.news_id = newsLink;
        nv.needFetchNewsData = YES;
        [(BERNavigationController *)controller pushViewController:nv animated:NO];
        
        [self.mainViewController showCenterPanelAnimated:YES];
    }
}
-(void)pushPicWithPicLink:(NSString *)picLik
{
     UIViewController *controller = self.mainViewController.centerPanel;
    if ([controller isKindOfClass:[BERNavigationController class]])
    {
        BERNewsPictureViewController *pv=[[BERNewsPictureViewController alloc]init];
        pv.news_id=picLik;
        [(BERNavigationController *)controller pushViewController:pv animated:NO];
        
        [self.mainViewController showCenterPanelAnimated:YES];
    }
}
#pragma mark - 极光推送

//deviceToken 需要用来去苹果的推送服务器进行注册，作为手机设备的唯一标示
//deviceToken 来源：苹果服务器的返回
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [APService registerDeviceToken:deviceToken];
    //向服务器上报deviceToken
}

//注册失败反馈
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"推送注册失败：%@",error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings
{
    
}
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler
{
    
}
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler
{
    
}
#endif
//如果 App状态为正在前台或者后台运行，那么此函数将被调用，并且可通过AppDelegate的applicationState是否为UIApplicationStateActive判断程序是否在前台运行。此种情况在此函数中处理：
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [APService handleRemoteNotification:userInfo];
}
//如果是使用 iOS 7 的 Remote Notification 特性那么处理函数需要使用
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [APService handleRemoteNotification:userInfo];
    
    //处理收到的APNS消息，向服务器上报收到的APNS消息
    // 应用正处理前台状态下，不会收到推送消息，因此在此处需要额外处理一下
    if (application.applicationState == UIApplicationStateActive)
    {
        self.model=[[pushModel alloc]init];
        [self.model setValuesForKeysWithDictionary:userInfo];
        /*type      1 : videos          视频
                    2 : news            新闻
                    3 : photos          图集
         */
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"最新战况"
                                                        message:userInfo[@"aps"][@"alert"]
                                                       delegate:self
                                              cancelButtonTitle:@"没兴趣"
                                              otherButtonTitles:@"去看看", nil];
            [alert show];
        completionHandler(UIBackgroundFetchResultNewData);
    }
}
//APP 前端运行时 点击按钮事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIViewController *controller = self.mainViewController.centerPanel;
    if (buttonIndex==1) {
        if ([self.model.type intValue]==1||[self.model.type isEqualToString:@"video"]) {
            if (self.model.url.length>0) {
                BERVideoPlayerViewController *vc=[[BERVideoPlayerViewController alloc]init];
                vc.url=[NSURL URLWithString:self.model.url];
                [NFLAppLogManager sendLogWithEventID:EventID_Videos withKeyName:KN_VideosList andValueName:@"Videos"];
                [(BERNavigationController *)controller pushViewController:vc animated:NO];
                [self.mainViewController showCenterPanelAnimated:YES];
            }else
            {
            
            }
        }else if ([self.model.type intValue]==2||[self.model.type isEqualToString:@"news"])
        {
            BERNewsDetailViewController *vc=[[BERNewsDetailViewController alloc]init];
            vc.news_id=self.model.id;
            [NFLAppLogManager sendLogWithEventID:EventID_News withKeyName:KN_NewsList andValueName:@"News"];
            [(BERNavigationController *)controller pushViewController:vc animated:NO];
            [self.mainViewController showCenterPanelAnimated:YES];
        }else if([self.model.type intValue]==3||[self.model.type isEqualToString:@"photos"])
        {
            BERNewsPictureViewController *vc=[[BERNewsPictureViewController alloc]init];
            vc.news_id=self.model.id;
            [NFLAppLogManager sendLogWithEventID:EventID_Photos withKeyName:KN_PhotosList andValueName:@"Photos"];
            [(BERNavigationController *)controller pushViewController:vc animated:NO];
            [self.mainViewController showCenterPanelAnimated:YES];
        }
//        else if([self.model.type intValue]==4)
//        {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.url]];
//        }
        else
        {
            
        }
    }
}
- (void)getConfigInfo{

        NSDictionary *parame=@{

                               };
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        
        [manager GET:[BERApiProxy urlWithAction:[self getMainActionName]] parameters:[BERApiProxy paramsWithDataDic:parame action:[self getActionName]] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * dataDic=[responseObject objectForKey:@"data"];
            id url1 = dataDic[@"club"];
            if (url1 != nil) {
                NSString * barUrlStr = dataDic[@"club"];
                [[NSUserDefaults standardUserDefaults] setObject:barUrlStr forKey:@"CLUB"];
            }
            id url2 = dataDic[@"shop"];
            if (url2 != nil) {
                NSString * shopUrlStr = dataDic[@"shop"];
                [[NSUserDefaults standardUserDefaults] setObject:shopUrlStr forKey:@"SHOP"];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            

        }];

}
-(NSString *)getActionName
{
    return @"menu";
}
-(NSString *)getMainActionName
{
    return @"page";
}

@end
