//
//  BERTeamerModel.m
//  Bayern
//
//  Created by 吴孔锐 on 15/7/29.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERTeamerModel.h"

@implementation BERTeamerModel
- (instancetype)initWithDictionary:(NSDictionary *)Dictionary{
    self = [super initWithDictionary:Dictionary];
    if(self){
        self.teamerTitles = @[@"出生日期",@"出生地点",@"星座",@"身高/体重/鞋码",@"婚姻状况",@"学历"];
        NSString * info = [NSString stringWithFormat:@"%@/%@/%@",self.height,self.weight,self.shoesize];
        self.teamerDescs = @[self.birthday,self.birthplace,self.zodiac,info,self.family,self.edu];
    }
    return self;
}
@end
