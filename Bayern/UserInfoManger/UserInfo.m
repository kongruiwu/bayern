//
//  UserInfo.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/22.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

static UserInfo * info = nil;
+ (instancetype)defaultInfo{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        info = [[self alloc] init];
    });
    return info;
}
- (void)setKeyValueForKeyWithDictionary:(NSDictionary *)dic{
    [self setValuesForKeysWithDictionary:dic];
    BOOL rec = YES;
    NSArray * arr = @[self.area,self.birth,self.gender];
    for (int i = 0; i<arr.count; i++) {
        NSString * str = arr[i];
        if ([str isEqualToString:@"未设置"]) {
            rec = NO;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.uid forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.callback_verify && ![self.callback_verify isKindOfClass:[NSNull class]] && self.callback_verify.length>0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.callback_verify forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    self.isCompeletInfo = rec;
    NSNumber * lastTime = [[NSUserDefaults standardUserDefaults] objectForKey:ShowComplete];
    self.isTimeOver = NO;
    if (lastTime && ![lastTime isKindOfClass:[NSNull class]]) {
        NSNumber * currentTime = [NSNumber numberWithLong:time(NULL)];
        //时间大于 1周
        if ([currentTime longValue] - [currentTime longValue] >= 7 * 24 * 60 * 60) {
            self.isTimeOver = YES;
        }
    }else{
        self.isTimeOver =YES;
    }
    if ([AppDelegate sharedInstance].mainViewController.leftVC) {
        
        [[AppDelegate sharedInstance].mainViewController.leftVC updateHeadCell];
    }
}
- (void)updateShowMessageStatus{
    NSNumber * lastTime = [[NSUserDefaults standardUserDefaults] objectForKey:ShowComplete];
    self.isTimeOver = NO;
    if (lastTime && ![lastTime isKindOfClass:[NSNull class]]) {
        NSNumber * currentTime = [NSNumber numberWithLong:time(NULL)];
        //时间大于 1周
        if ([currentTime longValue] - [currentTime longValue] >= 7 * 24 * 60 * 60) {
            self.isTimeOver = YES;
        }
    }else{
        self.isTimeOver =YES;
    }
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}




@end
