//
//  HomeBannerModel.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/19.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BaseModel.h"

@interface HomeBannerModel : BaseModel
/**内容*/
@property (nonatomic, strong) NSString * content;
/**创建时间*/
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSNumber * id;

@property (nonatomic, strong) NSNumber * orderby;
/**图片地址*/
@property (nonatomic, strong) NSString * pic;
/**展示id*/
@property (nonatomic, strong) NSNumber * show_id;
/**展示方式 1：新闻，2：图集，3：视频，0：其他*/
@property (nonatomic, strong) NSNumber * show_type;
/**描述文字*/
@property (nonatomic, strong) NSString * title;
/***/
@property (nonatomic, strong) NSNumber * type;
/**打开的web url*/
@property (nonatomic, strong) NSString * url;
@end
