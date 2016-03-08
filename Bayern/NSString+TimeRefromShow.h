//
//  NSString+TimeRefromShow.h
//  HupuNFL
//
//  Created by Wusicong on 14/11/30.
//  Copyright (c) 2014年 hupu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimeRefromShow)

+ (NSString *)reformForTimeShowWithTimeStamp:(NSString *)timeStamp;

+ (NSString *)reformForListTimeShowWithTimeStamp:(NSString *)timeStamp;

+ (NSString *)reformForListTimeShowWithDate:(NSString *)date;

@end
