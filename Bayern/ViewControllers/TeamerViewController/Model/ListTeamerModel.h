//
//  ListTeamerModel.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/26.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BaseModel.h"

@interface ListTeamerModel : BaseModel
@property (nonatomic, strong) NSNumber * No;//队号
@property (nonatomic, strong) NSString * birthday;//生日
@property (nonatomic, strong) NSNumber * gdcpid;
@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * name_en;
@property (nonatomic, strong) NSString * pic;
@property (nonatomic, strong) NSNumber * pic_height;
@property (nonatomic, strong) NSNumber * pic_width;
@property (nonatomic, strong) NSString * cate;
@end
