//
//  SearchCateModel.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/19.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BaseModel.h"

@interface SearchCateModel : BaseModel
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * imageName;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) NSString * type;
@end
