//
//  NSString+TimeRefromShow.m
//  HupuNFL
//
//  Created by Wusicong on 14/11/30.
//  Copyright (c) 2014年 hupu.com. All rights reserved.
//

#import "NSString+TimeRefromShow.h"

@implementation NSString (TimeRefromShow)

//将时间戳转化为字符显示
+ (NSString *)reformForTimeShowWithTimeStamp:(NSString *)timeStamp {
    NSString *timeTitle = [NSString string];
    
    NSDate *datenow = [NSDate date];
    NSString *nowTimeStamp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    DLog(@"now timeStamp [%@]", nowTimeStamp);
    
    NSInteger timeGap = [nowTimeStamp integerValue] - [timeStamp integerValue];
    
    DLog(@"time Gap [%ld]", (long)timeGap);
    
    if (timeGap == 0) {
        timeTitle = @"刚刚";
        
    } else if (timeGap > 0 && timeGap < 60) { //1分钟内
        timeTitle = [NSString stringWithFormat:@"%ld秒前", (long)timeGap];
        
    } else if (timeGap >= 60 && timeGap < 60* 60) { //1小时内
        timeTitle = [NSString stringWithFormat:@"%ld分钟前", (long)timeGap/60];
        
    } else if (timeGap >= 60*60 && timeGap < 60*60*24) { //同一天内
        timeTitle = [NSString stringWithFormat:@"%ld小时内", (long)timeGap/60/60];
        
    } else if (timeGap >= 60*60*24 && timeGap < 60*60*24*2) { //昨天
        timeTitle = [NSString stringWithFormat:@"昨天"];
        
    } else if (timeGap >= 60*60*24*2 && timeGap < 60*60*24*3) { //前天
        timeTitle = [NSString stringWithFormat:@"前天"];
        
    } else { //仅仅判断是否在同一年
        
        NSDate *postDate = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSDateComponents *nowComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
        NSDateComponents *postComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:postDate];

        if (nowComponents.year == postComponents.year) { //同一年，月日
            [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
        } else {
            [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
        }
        
        timeTitle = [dateFormatter stringFromDate:postDate];
    }
    
    return timeTitle;
}

//将时间戳转化为字符显示，简化版
+ (NSString *)reformForListTimeShowWithTimeStamp:(NSString *)timeStamp {
    NSString *timeTitle = [NSString string];
    
    NSDate *datenow = [NSDate date];
    NSString *nowTimeStamp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
//    DLog(@"now timeStamp [%@]", nowTimeStamp);
    
    NSInteger timeGap = [nowTimeStamp integerValue] - [timeStamp integerValue];
    
//    DLog(@"time Gap [%ld]", (long)timeGap);
    
    if (timeGap == 0) {
        timeTitle = @"刚刚";
        
    } else if (timeGap > 0 && timeGap < 60) { //1分钟内
        timeTitle = [NSString stringWithFormat:@"%ld秒前", (long)timeGap];
        
    } else if (timeGap >= 60 && timeGap < 60* 60) { //1小时内
        timeTitle = [NSString stringWithFormat:@"%ld分钟前", (long)timeGap/60];
        
    } else if (timeGap >= 60*60 && timeGap < 60*60*24) { //同一天内
        timeTitle = [NSString stringWithFormat:@"%ld小时内", (long)timeGap/60/60];
        
    } else { //仅仅判断是否在同一年
        
        NSDate *postDate = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSDateComponents *nowComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
        NSDateComponents *postComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:postDate];
        
        if (nowComponents.year == postComponents.year) { //同一年，月日
            [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
        } else {
            [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
        }
        
        timeTitle = [dateFormatter stringFromDate:postDate];
    }
    
    return timeTitle;
}

+ (NSString *)reformForListTimeShowWithDate:(NSString *)date {
    NSString *timeTitle = [NSString string];
    
    BOOL isSameDay = NO;
    
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //做切割比较
    NSString *timeNow = [NSString stringWithString:[dateFormatter stringFromDate:nowDate]];
    NSMutableString *timePost = [NSMutableString stringWithString:date];
    if (timePost.length > 11) {
        NSString *timePostTemp = [timePost substringToIndex:10];
        
        if ([timeNow isEqualToString:timePostTemp]) {
            isSameDay = YES;
        }
    }
    
    
    //都date切割
    
    NSMutableString *dateString = [NSMutableString stringWithString:date];
    if (dateString.length != 19) {
        return @"";
    }
    
    if (isSameDay) {
        timeTitle = [dateString substringWithRange:NSMakeRange(10, 6)];
    } else {
        timeTitle = [dateString substringWithRange:NSMakeRange(5, 5)];
    }
    
    return timeTitle;
}

@end
