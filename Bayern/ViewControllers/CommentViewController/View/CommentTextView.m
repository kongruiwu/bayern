//
//  CommentTextView.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/16.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "CommentTextView.h"
//@interface CommentTextView()<UITextViewDelegate>
//
//@end


@implementation CommentTextView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    self.icon = [Factory creatImageViewWithImageName:@"comment"];
    self.commentLabel = [Factory creatLabelWithTitle:@"回复" textColor:COLOR_CONTENT_GRAY_9 textFont:font750(26)
                                       textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.icon];
    [self addSubview:self.commentLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(20)));
        make.top.equalTo(@(Anno750(15)));
        make.height.with.equalTo(@(Anno750(30)));
    }];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(Anno750(15));
        make.centerY.equalTo(self.icon.mas_centerY);
    }];
}
- (void)showAllUI:(BOOL)rec{
    self.icon.hidden = rec;
    self.commentLabel.hidden = rec;
}

@end
