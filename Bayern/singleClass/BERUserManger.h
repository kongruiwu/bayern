//
//  BERUserManger.h
//  Bayern
//
//  Created by wurui on 15/10/25.
//  Copyright © 2015年 Wusicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BERUserManger : NSObject

@property (nonatomic,strong)NSString * userName;
@property (nonatomic,strong)NSString * userID;
@property (nonatomic,strong)NSString * avatar;
@property BOOL isLogin;

+ (BERUserManger *)shareMangerUserInfo;

- (void)userLogOut;

- (void)configModelValueWithDic:(NSDictionary *)dic;

- (void)getInfo;
@end
