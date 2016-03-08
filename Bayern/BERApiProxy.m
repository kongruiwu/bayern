//
//  BERApiProxy.m
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERApiProxy.h"

@implementation BERApiProxy

#pragma mark - Public Method

//拼接url对外接口，传递action name参数
+ (NSString *)urlWithAction:(NSString *)action {
    NSString *url = [self getUrlWithMethodName:action];
    
    return url;
}

//后部参数对外接口，包括app公用参数和api自由参数
+ (NSDictionary *)commonParasWithAction:(NSString *)action dataDic:(NSDictionary *)dataDic {
    NSDictionary *signDic = @{
                              @"action"     :action,
                              @"sign"       :[self getSignStrWithAction:action dataDic:dataDic],
                              @"deviceId"   :[UIDevice currentDevice].uniqueDeviceIdentifier,
                              @"platform"   :BER_PLATEFORM,
                              @"version"    :[self appVersion]
                              };
    return signDic;
}

+ (NSDictionary *)paramsWithDataDic:(NSDictionary *)dataDic action:(NSString *)action {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self commonParasWithAction:action dataDic:dataDic]];
    
    //合并底层参数与用户参数
    if (dataDic.count > 0) {
        NSArray *keyArr = [dataDic allKeys];
        NSArray *valueArr = [dataDic allValues];
        for (int i = 0; i < keyArr.count; i ++) {
            
            NSString *key = keyArr[i];
            NSString *value = valueArr[i];
            if (value.length > 0) { //注：传入的空参数需要在封装url时丢弃
                [dic setValue:dataDic[key] forKey:key];
            }
        }
    }
    
    DLog(@"request params [%@]", dic);
    return dic;
}

#pragma mark - Private Method

//内部拼接url头
+ (NSString *)getUrlWithMethodName:(NSString *)method {
    NSString *url = [NSString stringWithFormat:@"%@/%@", BER_API_HOST, method];
    
    return url;
}

//得到签名string
+ (NSString *)getSignStrWithAction:(NSString *)action dataDic:(NSDictionary *)dataDic {
    /**
     请求参数组成键值对数组(不包括sign)，经过ksort排序后，重新处理形成字符串，然后与密钥appkey一起组成新的字符串被md5加密 形成的字符串作为参数sign的值，用来与服务端校验。
     action=postDetail
     platform=ios
     deviceId=xxx
     version=1.0.1
     
     id=123
     
     以上参数组成数组array,进行排序ksort(array)
     拆分成字符串 str = actionpostDetaildeviceIdxxxid123platformiosversion1.0.1
     sign = md5(str与appkey拼接)
     **/
    NSDictionary *commnSignDic = @{
                                   @"action"    : action,
                                   @"platform"  : BER_PLATEFORM,//@"ios",
                                   @"deviceId"  : [UIDevice currentDevice].uniqueDeviceIdentifier,
                                   @"version"   : [self appVersion]
                                   };
    NSMutableDictionary *signDic = [NSMutableDictionary dictionaryWithDictionary:commnSignDic];
    //合并底层参数与用户参数
    if (dataDic.count > 0) {
        NSArray *keyArr = [dataDic allKeys];
        NSArray *valueArr = [dataDic allValues];
        for (int i = 0; i < keyArr.count; i ++) {
            
            NSString *key = keyArr[i];
            NSString *value = valueArr[i];
            if (value.length > 0) { //注：传入的空参数需要在签名时丢弃
                [signDic setValue:dataDic[key] forKey:key];
            }
        }
    }
    
    NSMutableString *sign = [NSMutableString stringWithString:[signDic AIF_urlParamsStringSignature:YES]];
    [sign appendString:BER_APP_KEY];
    DLog(@"_API_SIGN [%@]", sign);
    
    [sign stringFromMD5];
    DLog(@"_API_SIGN_MD5 [%@]", [sign stringFromMD5]);
    
    return [sign stringFromMD5];
}

//得到app版本号
+ (NSString *)appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

@end
