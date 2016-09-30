//
//  VoteDetailModel.h
//  Bayern
//
//  Created by 吴孔锐 on 2016/9/29.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BaseModel.h"

@interface VoteDetailModel : BaseModel
@property (nonatomic, strong) NSString * choose_way;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * pic;
@property (nonatomic, strong) NSString * share_title;
@property (nonatomic, strong) NSString * share_pic;
@property (nonatomic, strong) NSString * share_link;
@end
