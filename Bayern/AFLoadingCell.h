//
//  LoadingCell.h
//  Anjuke
//
//  Created by omiyang on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LOADING_CELL_HEIGHT 50

@interface AFLoadingCell : UITableViewCell {
}

@property (nonatomic, strong) UILabel *message;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end
