//
//  HomeTeamerModel.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/20.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BaseModel.h"

@interface HomeTeamerModel : BaseModel
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * number;
@property (nonatomic, strong) NSString * pic;
@property (nonatomic, strong) NSNumber * player_id;
@property (nonatomic, assign) BOOL is_coach;
@end
