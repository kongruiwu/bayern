//
//  TeamRankModel.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/21.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BaseModel.h"

@interface TeamRankModel : BaseModel
@property (nonatomic, strong) NSString * team_group;
@property (nonatomic, strong) NSNumber * team_id;
@property (nonatomic, strong) NSString * name_zh;
@property (nonatomic, strong) NSString * known_name_zh;
@property (nonatomic, strong) NSNumber * played;
@property (nonatomic, strong) NSNumber * rank_index;
@property (nonatomic, strong) NSNumber * win;
@property (nonatomic, strong) NSNumber * draw;
@property (nonatomic, strong) NSNumber * lost;
@property (nonatomic, strong) NSNumber * hits;
@property (nonatomic, strong) NSNumber * miss;
@property (nonatomic, strong) NSNumber * difference;
@property (nonatomic, strong) NSNumber * score;
@property (nonatomic, strong) NSNumber * avg_goal_hit;
@property (nonatomic, strong) NSNumber * avg_goal_lost;
@property (nonatomic, strong) NSNumber * avg_goal_win;
@property (nonatomic, strong) NSNumber * avg_score;
@property (nonatomic, strong) NSNumber * promotion_id;
@property (nonatomic, strong) NSString * promotion_name;
@property (nonatomic, strong) NSString * team_logo;
@property (nonatomic, assign) BOOL isHomeTeam;


@property (nonatomic, strong) NSString * winString;
@property (nonatomic, strong) NSString * basllNumberStr;

@end
