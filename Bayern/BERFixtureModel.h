//
//  BERFixtureModel.h
//  Bayern
//
//  Created by 吴孔锐 on 15/7/23.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BERFixtureModel : NSObject
@property(nonatomic,retain)NSNumber *album_link;
@property(nonatomic,retain)NSNumber *away_id;
@property(nonatomic,copy)NSString *away_logo;
@property(nonatomic,copy)NSString *away_name;
@property(nonatomic,copy)NSString *away_score;
@property(nonatomic,retain)NSNumber *game_id;
@property(nonatomic,retain)NSNumber *game_status;
@property(nonatomic,copy)NSString *half_score;
@property(nonatomic,retain)NSNumber *home_id;
@property(nonatomic,copy)NSString *home_logo;
@property(nonatomic,copy)NSString *home_name;
@property(nonatomic,copy)NSString *home_score;
@property(nonatomic,retain)NSNumber *league_id;
@property(nonatomic,copy)NSString *league_title;
@property(nonatomic,copy)NSString *match_date_cn;
@property(nonatomic,retain)NSNumber *match_day;
@property(nonatomic,retain)NSNumber *news_link;
@property(nonatomic,copy)NSString *relay_info;
@end
