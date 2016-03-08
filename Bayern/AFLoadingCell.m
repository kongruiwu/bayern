//
//  LoadingCell.m
//  Anjuke
//
//  Created by omiyang on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AFLoadingCell.h"


@implementation AFLoadingCell
@synthesize message = _message;
@synthesize spinner = _spinner;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithHex:0xffffff alpha:1]];
        
        CGFloat viewWidth = 150;
        UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake((WindowWidth - viewWidth)/2, (LOADING_CELL_HEIGHT - 20)/2, viewWidth, 20)];
        viewBG.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:viewBG];
        
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _spinner.frame = CGRectMake(0, 0, 20, 20);
        _spinner.backgroundColor = [UIColor clearColor];
        [_spinner startAnimating];
        [viewBG addSubview:self.spinner];
        
        self.message = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, viewWidth - 20, 20)];
        _message.text = @"正在加载...";
        _message.backgroundColor = [UIColor clearColor];
        _message.textAlignment = NSTextAlignmentCenter;
        [_message setFont:[UIFont systemFontOfSize:16]];
        [_message setTextColor:[UIColor colorWithHex:0x4e6689 alpha:1]];
        [viewBG addSubview:_message];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

@end
