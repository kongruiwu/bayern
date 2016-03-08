//
//  BERFixturesViewController.h
//  Bayern
//
//  Created by wurui on 15/7/21.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERRootViewController.h"
#import "BERFixtureListView.h"

@interface BERFixturesViewController : BERRootViewController<UIScrollViewDelegate,BERFixturetListDelegate>
@property (nonatomic,retain)NSArray *titleArr;
@end
