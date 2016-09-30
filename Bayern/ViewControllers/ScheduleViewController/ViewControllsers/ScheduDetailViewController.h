//
//  ScheduDetailViewController.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/22.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BERRootViewController.h"
typedef NS_ENUM(NSInteger, ScheduType){
    ScheduTypeBundesliga = 0,//德甲
    ScheduTypeChampions,//欧冠
    ScheduTypeGermany,//德国杯
    ScheduTypeEles//其他
};
@interface ScheduDetailViewController : BERRootViewController
@property (nonatomic, assign) ScheduType scheduType;
@end
