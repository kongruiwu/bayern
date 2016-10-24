//
//  HomePicModel.h
//  Bayern
//
//  Created by 吴孔锐 on 2016/10/18.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BaseModel.h"

@interface HomePicModel : BaseModel

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * pic;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSNumber * orderby;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSNumber * show_type;
@property (nonatomic, strong) NSNumber * show_id;

@end
