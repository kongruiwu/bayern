//
//  CommentTextView.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/16.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
@interface CommentTextView : UITextView
@property (nonatomic, strong) UIImageView * icon;
@property (nonatomic, strong) UILabel * commentLabel;
- (void)showAllUI:(BOOL)rec;
@end
