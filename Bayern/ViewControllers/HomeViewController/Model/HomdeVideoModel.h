//
//  HomdeVideoModel.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/19.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BaseModel.h"

@interface HomdeVideoModel : BaseModel
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * pic;
@property (nonatomic, strong) NSNumber * show_id;
@property (nonatomic, strong) NSNumber * show_type;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * url;
@end
