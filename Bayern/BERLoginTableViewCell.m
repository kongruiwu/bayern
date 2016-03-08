//
//  BERLoginTableViewCell.m
//  Bayern
//
//  Created by wurui on 15/10/25.
//  Copyright © 2015年 Wusicong. All rights reserved.
//

#import "BERLoginTableViewCell.h"
#import "BERHeadFile.h"

@implementation BERLoginTableViewCell

- (void)awakeFromNib {
   
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 20.0f;
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.backgroundColor = [UIColor colorWithHexString:BERColor];
    self.loginBtn.layer.borderColor = [[UIColor colorWithHexString:BERColor]CGColor];
    self.loginBtn.layer.borderWidth = 1.0f;
    
    self.registerBtn.layer.masksToBounds = YES;
    self.registerBtn.layer.cornerRadius = 20.0f;
    [self.registerBtn setTitleColor:[UIColor colorWithHexString:BERColor] forState:UIControlStateNormal];
    self.registerBtn.backgroundColor = [UIColor whiteColor];
    self.registerBtn.layer.borderColor = [[UIColor colorWithHexString:BERColor]CGColor];
    self.registerBtn.layer.borderWidth = 1.0f;
    
}

- (void)configCell{
    if ([BERUserManger shareMangerUserInfo].isLogin) {
        self.loginBtn.hidden = YES;
        self.registerBtn.hidden = YES;
        self.userName.text = [BERUserManger shareMangerUserInfo].userName;
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:[BERUserManger shareMangerUserInfo].avatar] placeholderImage:nil];
    }else{
        self.userName.hidden = YES;
        self.userIcon.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

- (IBAction)userLogin:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(presentLoginViewController)]) {
        [self.delegate presentLoginViewController];
    }
}

- (IBAction)userRegister:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(presentRegisterViewController)]) {
        [self.delegate presentRegisterViewController];
    }
}

@end
