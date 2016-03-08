//
//  BERVideoPlayerViewController.h
//  Bayern
//
//  Created by 吴孔锐 on 15/7/29.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "TOWebViewController.h"
#import "BERVideosModel.h"

@interface BERVideoPlayerViewController : TOWebViewController

@property (nonatomic, retain)BERVideosModel *model;
@property (nonatomic, copy)NSString *videotitle;
@property (nonatomic, copy)NSString *videoUrl;
@property (nonatomic, copy)NSString *videoiconUrl;
@end
