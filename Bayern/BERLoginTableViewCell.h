//
//  BERLoginTableViewCell.h
//  Bayern
//
//  Created by wurui on 15/10/25.
//  Copyright © 2015年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BERLoginDelegate<NSObject>

- (void)presentLoginViewController;

- (void)presentRegisterViewController;

@end
@interface BERLoginTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

@property (strong, nonatomic) IBOutlet UIButton *registerBtn;

@property (strong, nonatomic) IBOutlet UIImageView *userIcon;

@property (strong, nonatomic) IBOutlet UILabel *userName;

@property id<BERLoginDelegate> delegate;

- (IBAction)userLogin:(UIButton *)sender;

- (IBAction)userRegister:(UIButton *)sender;

- (void)configCell;
@end
