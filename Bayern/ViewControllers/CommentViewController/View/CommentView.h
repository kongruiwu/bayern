//
//  CommentView.h
//  Bayern
//
//  Created by 吴孔锐 on 2016/9/28.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentTextView.h"
@interface CommentView : UIView
@property (nonatomic, strong) UIButton * commitButton;
@property (nonatomic, strong) CommentTextView * textView;
@property (nonatomic, strong) UILabel * loadingLabel;
@property (nonatomic, strong) UIActivityIndicatorView * spinner;
- (void)startLoading:(BOOL)rec;
@end
