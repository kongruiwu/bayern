//
//  BERDownLoadView.h
//  Bayern
//
//  Created by wurui on 16/4/25.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BERDownLoadViewDelegate <NSObject>

-(BOOL)downLoadImage;

@end

@interface BERDownLoadView : UIView
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UILabel * pageLable;
@property (nonatomic, strong) UIButton * downButton;
@property (nonatomic, assign) id<BERDownLoadViewDelegate>delegate;
@property (nonatomic, assign) void(^downloadImg)(UIImage *img);
@end
