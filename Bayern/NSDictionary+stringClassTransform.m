//
//  NSDictionary+stringClassTransform.m
//  Bayern
//
//  Created by wusicong on 15/6/23.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "NSDictionary+stringClassTransform.h"

@implementation NSDictionary (stringClassTransform)

- (NSString *)stringValueForKey:(NSString *)key {
    return [self[key] isKindOfClass:[NSNumber class]] ? [self[key] stringValue] : self[key];
}

@end
