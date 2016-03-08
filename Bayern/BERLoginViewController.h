//
//  BERLoginViewController.h
//  Bayern
//
//  Created by wurui on 15/10/25.
//  Copyright © 2015年 Wusicong. All rights reserved.
//

#import "BERRootViewController.h"
typedef NS_ENUM(NSInteger, BERLoginType) {
    BERLoginTypeLogin = 1,
    BERLoginTypeRegister
};

@interface BERLoginViewController : BERRootViewController
 
@property BERLoginType logInType;

@end
