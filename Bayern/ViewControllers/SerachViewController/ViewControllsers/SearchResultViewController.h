//
//  SearchResultViewController.h
//  Bayern
//
//  Created by 吴孔锐 on 16/9/26.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BERRootViewController.h"
#import "SearchCateTableViewCell.h"
@interface SearchResultViewController : BERRootViewController
@property (nonatomic, strong) SearchCateModel * searchTypeModel;
@property (nonatomic, strong) NSString * searchWord;
@property (nonatomic, strong) NSMutableArray * hisArray;
@end
