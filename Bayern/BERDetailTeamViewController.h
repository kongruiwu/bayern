//
//  BERDetailTeamViewController.h
//  Bayern
//
//  Created by 吴孔锐 on 15/7/28.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERRootViewController.h"

@interface BERDetailTeamViewController : BERRootViewController
@property(nonatomic,strong) UILabel *numLabel;//队员编号
@property(nonatomic,strong) UILabel *cateLabel;//队员类型
@property(nonatomic,strong) UILabel *chinaName;//队员中文名
@property(nonatomic,strong) UILabel *englishName;//队员英文名
@property(nonatomic,strong) UIImageView * teamerImgView;//队员头像

@property(nonatomic,retain) NSArray *teamerinfoArray;//球员个人信息
@property(nonatomic,retain) NSArray *barArray;//前俱乐部
@property(nonatomic,retain) NSArray *teamerHonourArray;//球员荣誉
@property(nonatomic,retain) NSArray *descArray;//执教生涯
@property(nonatomic,retain) NSArray *coaHonourArray;//执教荣誉
@property(nonatomic,retain) NSArray *teamerLifeArray;//球员生涯

@property(nonatomic,retain) NSArray *timeArray;
@property(nonatomic) BOOL isTeamer;
@property(nonatomic,copy) NSString *teamerID;
@end
