//
//  BERUserManger.m
//  Bayern
//
//  Created by wurui on 15/10/25.
//  Copyright © 2015年 Wusicong. All rights reserved.
//

#import "BERUserManger.h"

@implementation BERUserManger

+ (BERUserManger *)shareMangerUserInfo{
    static BERUserManger * shareMangerUserInfo = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shareMangerUserInfo = [[BERUserManger alloc] init];
    });
    return shareMangerUserInfo;
}

- (void)configModelValueWithDic:(NSDictionary *)dic{
    self.userName = [dic objectForKey:@"username"];
    self.userID   = [dic objectForKey:@"uid"];
    self.avatar   = [dic objectForKey:@"avatar"];
    self.isLogin  = YES;
    
    [[NSUserDefaults standardUserDefaults] setValue:self.userName forKey:@"customName"];
    [[NSUserDefaults standardUserDefaults] setValue:self.userID forKey:@"customID"];
    [[NSUserDefaults standardUserDefaults] setValue:self.avatar forKey:@"customIcon"];
    [[NSUserDefaults standardUserDefaults] setValue:@1 forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)userLogOut{
    self.userName = @"";
    self.userID   = @"";
    self.avatar   = @"";
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"customName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"customID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"customIcon"];
    [[NSUserDefaults standardUserDefaults] setValue:@0 forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.isLogin = NO;
}
- (void)getInfo{
    self.userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"customName"];
    self.userID   = [[NSUserDefaults standardUserDefaults] objectForKey:@"customID"];
    self.avatar   = [[NSUserDefaults standardUserDefaults] objectForKey:@"customIcon"];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] intValue] == 1) {
        self.isLogin = YES;
    }else{
        self.isLogin = NO;
    }
}
@end
