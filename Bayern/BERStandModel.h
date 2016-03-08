//
//  BERStandModel.h
//  Bayern
//
//  Created by 吴孔锐 on 15/7/22.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BERStandModel : NSObject
@property(nonatomic,retain)NSNumber *avg_goal_hit;
@property(nonatomic,retain)NSNumber *avg_goal_lost;
@property(nonatomic,retain)NSNumber *avg_goal_win;
@property(nonatomic,retain)NSNumber *avg_score;
@property(nonatomic,retain)NSNumber *difference;
@property(nonatomic,retain)NSNumber *draw;
@property(nonatomic,retain)NSNumber *hits;
@property(nonatomic,copy)NSString *known_name_zh;
@property(nonatomic,retain)NSNumber *lost;
@property(nonatomic,retain)NSNumber *miss;
@property(nonatomic,copy)NSString *name_zh;
@property(nonatomic,retain)NSNumber *played;
@property(nonatomic,retain)NSNumber *promotion_id;
@property(nonatomic,copy)NSString *promotion_name;
@property(nonatomic,retain)NSNumber *rank_index;
@property(nonatomic,retain)NSNumber *score;
@property(nonatomic,retain)NSNumber *team_id;
@property(nonatomic,copy)NSString *team_logo;
@property(nonatomic,retain)NSNumber *win;
@property(nonatomic) BOOL isBer;
@end
