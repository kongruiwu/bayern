//
//  BaseModel.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/19.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}
- (instancetype)initWithDictionary:(NSDictionary *)Dictionary{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:Dictionary];
    }
    return self;
}
@end
