//
//  BERFixtureListView.h
//  Bayern
//
//  Created by 吴孔锐 on 15/7/23.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BERHeadFile.h"
#import "BERFixtureModel.h"
#import "BERFixtureTableViewCell.h"
@protocol BERFixturetListDelegate<NSObject>
-(void)pushToImgViewController:(BERFixtureModel *)model;
-(void)showLoadView;
-(void)hideLoadView;
@end
@interface BERFixtureListView : UIView<UITableViewDataSource,UITableViewDelegate,BERFixturetTableViewCell>
@property (nonatomic,retain) UITableView *fixtureTabView;
@property(nonatomic,retain)NSMutableArray *dataArray;
@property(nonatomic,assign) id<BERFixturetListDelegate>delegate;
@property(nonatomic,copy) NSString *leadID;
@property(nonatomic,retain) NSMutableArray *data1Array;//欧冠数据

-(void)creatTabViewWtihLeadgueID:(NSString *)leadgue_id;
-(void)reloadData;
@end
