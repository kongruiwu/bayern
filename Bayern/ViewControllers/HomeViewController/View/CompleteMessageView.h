//
//  CompleteMessageView.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/25.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
@interface CompleteMessageView : UIView
@property (nonatomic, strong) UIImageView * icon;
@property (nonatomic, strong) UILabel * firstLabel;
@property (nonatomic, strong) UILabel * secondLabel;
@property (nonatomic, strong) UIButton * completeButton;
@property (nonatomic, strong) UIButton * cannceButton;
@end
