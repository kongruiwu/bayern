//
//  TeamRankModel.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/21.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "TeamRankModel.h"

@implementation TeamRankModel
- (instancetype)initWithDictionary:(NSDictionary *)Dictionary{
    self = [super initWithDictionary:Dictionary];
    if (self) {
        self.winString = [NSString stringWithFormat:@"%@/%@/%@",self.win,self.draw,self.lost];
        self.basllNumberStr = [NSString stringWithFormat:@"%@/%@",self.hits,self.miss];
    }
    return self;
}
@end
