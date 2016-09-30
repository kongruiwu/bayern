//
//  BERDetailTeamViewController.h
//  Bayern
//
//  Created by 吴孔锐 on 15/7/28.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERRootViewController.h"

@interface BERDetailTeamViewController : BERRootViewController
@property (nonatomic, strong) UITableView * tabview;

@property(nonatomic,retain) NSArray *timeArray;
@property(nonatomic) BOOL isTeamer;
@property(nonatomic,copy) NSString *teamerID;
@end
