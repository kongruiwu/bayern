//
//  NewsDetailModel.h
//  Bayern
//
//  Created by 吴孔锐 on 2016/9/29.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BaseModel.h"

@interface NewsDetailModel : BaseModel
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * detail_content;
@property (nonatomic, strong) NSString * pic;
@property (nonatomic, strong) NSString * publish_date;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * sub_title;
@property (nonatomic, strong) NSString * visit_count;
//评论数
@property (nonatomic, strong) NSNumber * comment_count;
@property (nonatomic, assign) BOOL is_hot;
//分享数据
@property (nonatomic, strong) NSString * share_title;
@property (nonatomic, strong) NSString * share_pic;
@property (nonatomic, strong) NSString * share_link;
@end
