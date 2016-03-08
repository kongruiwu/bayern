//
//  BERTeamListViewController.h
//  Bayern
//
//  Created by wusicong on 15/6/19.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERRootViewController.h"
@protocol  BERTeamListDelegate<NSObject>
-(void)pushtoTeamerViewWithID:(NSString *)teamerid andIsTeamer:(BOOL)rec;
@end
@interface BERTeamListViewController : BERRootViewController

@property (nonatomic, strong) NSMutableArray *listArr;

@property (nonatomic, copy) NSString *teamPosition;

@property (nonatomic, assign)id<BERTeamListDelegate>delegate;
@end
