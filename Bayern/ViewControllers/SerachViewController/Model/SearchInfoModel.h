//
//  SearchInfoModel.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/26.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BaseModel.h"

@interface SearchInfoModel : BaseModel
@property (nonatomic, strong) NSNumber * search_count;
@property (nonatomic, strong) NSString * search_type;
@property (nonatomic, strong) NSString * search_word;
@end
