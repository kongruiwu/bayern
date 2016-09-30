//
//  CommentModel.h
//  Bayern
//
//  Created by 吴孔锐 on 2016/9/27.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BaseModel.h"

@interface CommentModel : BaseModel
@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSNumber * cont_id;
@property (nonatomic, strong) NSNumber * uid;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSNumber * time;
@property (nonatomic, strong) NSNumber * good;
@property (nonatomic, assign) BOOL gooded;
@end
