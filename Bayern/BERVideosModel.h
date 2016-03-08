//
//  BERVideosModel.h
//  Bayern
//
//  Created by 吴孔锐 on 15/7/22.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BERVideosModel : NSObject
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *link;
@property(nonatomic,copy)NSString *pic;
@property(nonatomic,copy)NSString *src;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,retain)NSNumber *id;
@property(nonatomic,retain)NSArray *tags;

@end
