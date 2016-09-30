//
//  BERMainViewController.h
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "JASidePanelController.h"
#import "BERLeftViewController.h"
@interface BERMainViewController : JASidePanelController
@property (nonatomic, strong) BERLeftViewController *leftVC;
- (void)setCenterVCWithIndex:(NSInteger)index;

@end
