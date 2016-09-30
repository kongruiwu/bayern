//
//  HomeVideoView.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/19.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "HomeVideoView.h"

@implementation HomeVideoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)creatUI{
    self.imageView = [Factory creatImageViewWithImageName:@"photos_defult"];
    self.videoIcon = [Factory creatImageViewWithImageName:@"videosPlay"];
    self.descLabel = [Factory creatLabelWithTitle:@"描述文字"
                                        textColor:[UIColor whiteColor] textFont:font750(26)
                                    textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.imageView];
    [self addSubview:self.videoIcon];
    [self addSubview:self.descLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@(Anno750(50)));
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(self.descLabel.mas_bottom);
    }];
    [self.videoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@(Anno750(25)));
    }];
    
}
- (void)updateImageViewWithModel:(HomdeVideoModel *)model{
    NSURL * URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BER_IMAGE_HOST,model.pic]];
    [self.imageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"photos_defult"]];
    self.model = model;
    self.descLabel.text = model.title;
}
@end
