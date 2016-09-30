//
//  SearchNewsModel.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/26.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BaseModel.h"

@interface SearchResultModel : BaseModel
//公用
@property (nonatomic, strong) NSNumber * cont_type;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSString * pic;
@property (nonatomic, strong) NSString * title;

//图片
@property (nonatomic, strong) NSArray * thmub;

//video
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSString * src;
@property (nonatomic, strong) NSString * link;


@end
