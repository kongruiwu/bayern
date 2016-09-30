//
//  UserInfo.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/22.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"
@interface UserInfo : NSObject

+ (instancetype)defaultInfo;

@property (nonatomic, strong) NSNumber * uid;//用户id
@property (nonatomic, strong) NSString * username;//用户姓名
@property (nonatomic, strong) NSString * avatar;//头像
@property (nonatomic, strong) NSString * callback_verify;//接口用户回调验证码
@property (nonatomic, strong) NSString * reg_date;//注册时间
@property (nonatomic, strong) NSString * gender; //性别
@property (nonatomic, strong) NSString * birth;//生日
@property (nonatomic, strong) NSString * area;//所在地
@property (nonatomic, strong) NSString * email;//邮箱
@property (nonatomic, assign) BOOL isCompeletInfo;//是否完善信息
@property (nonatomic, assign) BOOL isTimeOver;//时间限制

- (void)setKeyValueForKeyWithDictionary:(NSDictionary *)dic;
- (void)updateShowMessageStatus;
@end
