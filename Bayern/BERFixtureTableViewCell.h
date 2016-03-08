//
//  BERFixtureTableViewCell.h
//  Bayern
//
//  Created by 吴孔锐 on 15/7/23.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BERFixtureModel.h"
@protocol BERFixturetTableViewCell <NSObject>
-(void)BERFixtureBtnClickWith:(BERFixtureModel *)model;
-(void)BERFixturePicBtnClickWith:(BERFixtureModel *)model;
@end
@interface BERFixtureTableViewCell : UITableViewCell

{
    UILabel *titleLabel;
    UIImageView *homeImgView;
    UIImageView *awayImgView;
    UILabel *matchScoreLabel;
    UILabel *halfScoreLabel;
    UILabel *homeNameLabel;
    UILabel *awayNameLabel;
    UILabel *relay_infoLabel;
    UIButton *newsButton;
    UIButton *albumButton;
    UIView *lastLine;
}
@property (nonatomic,assign)id<BERFixturetTableViewCell>delegat;
@property (nonatomic,retain)UIButton *detailButton;
@property (nonatomic,retain)UIButton *pictureButton;
@property (nonatomic,retain)UIButton *onceButton;
@property (nonatomic,retain)UILabel  *relayLabel;
@property (nonatomic,retain)BERFixtureModel *model1;
-(void)configUIwithModel:(BERFixtureModel *)model;
@end
