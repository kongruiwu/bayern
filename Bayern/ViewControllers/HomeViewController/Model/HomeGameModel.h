//
//  HomeGameModel.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/20.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BaseModel.h"

@interface HomeGameModel : BaseModel
@property (nonatomic, strong) NSString * game_id;
@property (nonatomic, strong) NSString * league_id;
@property (nonatomic, strong) NSString * match_day;
@property (nonatomic, strong) NSString * match_date_cn;
@property (nonatomic, strong) NSString * home_id;
@property (nonatomic, strong) NSString * home_name;
@property (nonatomic, strong) NSString * home_score;
@property (nonatomic, strong) NSString * away_id;
@property (nonatomic, strong) NSString * away_name;
@property (nonatomic, strong) NSString * away_score;
@property (nonatomic, strong) NSString * half_score;
@property (nonatomic, strong) NSString * game_status;
@property (nonatomic, strong) NSNumber * news_link;
@property (nonatomic, strong) NSNumber * album_link;
@property (nonatomic, strong) NSString * relay_info;
@property (nonatomic, strong) NSString * home_logo;
@property (nonatomic, strong) NSString * away_logo;
@property (nonatomic, strong) NSString * league_title;
@property (nonatomic, assign) BOOL  show_default;
@end
