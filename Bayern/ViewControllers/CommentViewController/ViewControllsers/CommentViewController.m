//
//  CommentViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/14.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"
#import "CommentModel.h"
#import "CommentView.h"
#import "BERNavigationController.h"
#import "PrentLoginViewController.h"
#import "AFLoadingCell.h"
@interface CommentViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,CommentCellDelegate>
@property (nonatomic, strong)UITableView * tabview;
@property (nonatomic, strong) UIView * blackView;
@property (nonatomic, strong) UILabel * commentNumber;
@property (nonatomic, strong) CommentView * commentView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) BOOL commentSuccess;

@property (nonatomic, assign) BOOL needMoreData;

@end

@implementation CommentViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerNotification];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeNotification];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawTitle:@"全部评论"];
    [self drawBackButton];
    [self creatUI];
    [self creatCommentTextf];
    [self loadCommentList];
}
- (void)creatUI{
    self.dataArray = [[NSMutableArray alloc]init];;
    self.tabview = [Factory creatTabbleViewWithFrame:CGRectMake(0, 0, SCREENWIDTH,SCREENHEIGH - 64 - Anno750(80)) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    [self creatHeadView];
}
- (void)creatHeadView{
    UIView * headView = [Factory creatViewWithColor:[UIColor whiteColor]];
    headView.frame = CGRectMake(0, 0, SCREENWIDTH, Anno750(88));
    UILabel * label = [Factory creatLabelWithTitle:@"球迷互动" textColor:COLOR_MAIN_RED textFont:font750(30)
                                     textAlignment:NSTextAlignmentLeft];
    self.commentNumber = [Factory creatLabelWithTitle:@""
                                            textColor:COLOR_CONTENT_GRAY_9 textFont:font750(26)
                                        textAlignment:NSTextAlignmentRight];
    UIImageView * icon = [Factory creatImageViewWithImageName:@"statusbar_talk_gray"];
    UIView * line = [Factory creatViewWithColor:COLOR_MAIN_RED];
    [headView addSubview:label];
    [headView addSubview:self.commentNumber];
    [headView addSubview:icon];
    [headView addSubview:line];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(40)));
        make.bottom.equalTo(@(-Anno750(20)));
    }];
    [self.commentNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(40)));
        make.centerY.equalTo(label.mas_centerY);
    }];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.commentNumber.mas_left).offset(-Anno750(20));
        make.centerY.equalTo(label.mas_centerY);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(40)));
        make.right.equalTo(@(-Anno750(40)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@1);
    }];
    self.tabview.tableHeaderView = headView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.needMoreData) {
        return self.dataArray.count+1;
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataArray.count && self.needMoreData) {
        return 50;
    }
    CommentModel * model = self.dataArray[indexPath.row];
    CGSize size = [Factory getSize:model.content maxSize:CGSizeMake((SCREENWIDTH - Anno750(100)), 99999) font:[UIFont systemFontOfSize:font750(26)]];
    return Anno750(155) + size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataArray.count) {
        static NSString * loadCell = @"AFLoadingCell";
        AFLoadingCell * cell = [tableView dequeueReusableCellWithIdentifier:loadCell];
        if (cell == nil) {
            cell = [[AFLoadingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadCell];
        }
        [cell.spinner startAnimating];
        return cell;
    }
    static NSString * cellID = @"CommentTableViewCell";
    CommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    CommentModel * model = self.dataArray[indexPath.row];
    cell.delegate = self;
    [cell updateWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!self.needMoreData) {
        return;
    }
    if (scrollView == self.tabview) {
        if (scrollView.contentOffset.y + 50 >= scrollView.contentSize.height - scrollView.frame.size.height) {
            [self loadCommentList];
        }
    }
}

- (void)creatCommentTextf{
    UIView * footerView = [Factory creatViewWithColor:COLOR_BACKGROUND];
    footerView.frame = CGRectMake(0, SCREENHEIGH - Anno750(80) - 64, SCREENWIDTH, Anno750(80));
    [self.view addSubview:footerView];

    UIView * whiteView = [Factory creatViewWithColor:[UIColor whiteColor]];
    whiteView.layer.cornerRadius = Anno750(30);
    [footerView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.right.equalTo(@(-Anno750(30)));
        make.centerY.equalTo(@0);
        make.height.equalTo(@(Anno750(60)));
    }];
    UIImageView * icon = [Factory creatImageViewWithImageName:@"comment"];
    [whiteView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(20)));
        make.height.with.equalTo(@(Anno750(25)));
        make.centerY.equalTo(@0);
    }];
    UILabel * label = [Factory creatLabelWithTitle:@"评论"
                                         textColor:COLOR_CONTENT_GRAY_6 textFont:font750(28) textAlignment:NSTextAlignmentLeft];
    [footerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(Anno750(20));
        make.centerY.equalTo(@0);
    }];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(presentKeyBoard)];
    [footerView addGestureRecognizer:tap];

    
    self.commentView = [[CommentView alloc]init];
    self.commentView.frame = CGRectMake(0, SCREENHEIGH, SCREENWIDTH, Anno750(250));
    [self.commentView.commitButton addTarget:self action:@selector(commitComment) forControlEvents:UIControlEventTouchUpInside];
    self.commentView.textView.delegate = self;
    
   
    
}
- (void)creatBlackView{
    self.blackView = [Factory creatViewWithColor:COLOR_BACK_ALPHA_8];
    self.blackView.hidden = YES;
    [self.navigationController.view addSubview:self.blackView];
    [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.blackView addSubview:self.commentView];
}
- (void)presentKeyBoard{
    self.blackView.hidden = NO;
    self.commentView.textView.text = @"";
    [self.commentView.textView becomeFirstResponder];
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        [self.commentView.textView showAllUI:YES];
    }else{
        [self.commentView.textView showAllUI:NO];
    }
}
- (void)commenLikeButtonClick:(UIButton *)btn{
    
    if ([UserInfo defaultInfo].uid && [[UserInfo defaultInfo].uid intValue]>0) {
        UITableViewCell * cell = (UITableViewCell *)[btn superview];
        NSIndexPath * indexpath = [self.tabview indexPathForCell:cell];
        [self likeCommentRequestWithIndexPath:indexpath];
        
    }else{
        
        [self showLoginMessage];
    }
}

- (void)commitComment{
    if ([UserInfo defaultInfo].uid && [[UserInfo defaultInfo].uid intValue]>0) {
        [self.commentView startLoading:YES];
        [self addCommentRequest];
    }else{
        [self.commentView.textView resignFirstResponder];
        [self showLoginMessage];
    }
}
- (void)showLoginMessage{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"登陆提示" message:@"你好，请登陆后发表你的回复，我们期待你参与讨论！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * login = [UIAlertAction actionWithTitle:@"登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BERNavigationController * nav = [[BERNavigationController alloc]initWithRootViewController:[PrentLoginViewController new]];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }];
    UIAlertAction * cannce = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:login];
    [alert addAction:cannce];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}


- (void)registerNotification{
    [self creatBlackView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow1:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden1:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)removeNotification{
    [self.blackView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyBoardWillShow1:(NSNotification *)noti{
    NSDictionary *info = [noti userInfo];
    CGFloat time = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:time animations:^{
        self.commentView.frame = CGRectMake(0, SCREENHEIGH -Anno750(250)-kbSize.height, SCREENWIDTH, Anno750(250));
    }];
}
- (void)keyboardWillHidden1:(NSNotification *)noti {
    NSDictionary *info = [noti userInfo];
    CGFloat time = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:time animations:^{
        self.commentView.frame = CGRectMake(0, SCREENHEIGH, SCREENWIDTH, Anno750(250));
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.blackView.hidden = YES;
        if (self.commentSuccess) {
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"评论发表成功!"
                                 duration:1.0f completion:^{
                                     self.commentSuccess = NO;
            }];
        }
    });
}
- (void)addCommentRequest{
    [self.view showLoadWithAnimated:YES];
    
    NSString * userid = [NSString stringWithFormat:@"%@",[UserInfo defaultInfo].uid];
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSDictionary * params = @{
                              @"nid":self.newsID,
                              @"uid":userid,
                              @"callback_verify":token,
                              @"content":self.commentView.textView.text
                              };
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    __weak CommentViewController * weakSelf = self;
    [manager GET:[BERApiProxy urlWithAction:@"news"] parameters:[BERApiProxy paramsWithDataDic:params action:@"add_comment"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        [self.commentView startLoading:NO];
        if ([dic[@"code"] integerValue] == 0) {
            NSDictionary * dic1 = dic[@"data"];
            NSDictionary * commentDic = dic1[@"comment"];
            CommentModel * model = [[CommentModel alloc]initWithDictionary:commentDic];
            [self.dataArray insertObject:model atIndex:0];
            [self.tabview reloadData];
            self.commentSuccess = YES;
            [self.commentView.textView endEditing:YES];
        }
        [weakSelf.view hideLoadWithAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.view hideLoadWithAnimated:YES];
        [self.commentView startLoading:NO];
    }];
    
}
- (void)loadCommentList{
    [self.view showLoadWithAnimated:YES];
    NSString * idNum = @"";
    if (self.dataArray.count>0) {
        CommentModel * model = self.dataArray.lastObject;
        idNum = [NSString stringWithFormat:@"%@",model.id];
    }
    NSString * userID = @"";
    if ([UserInfo defaultInfo].uid && [[UserInfo defaultInfo].uid longLongValue]>0) {
        userID = [NSString stringWithFormat:@"%@",[UserInfo defaultInfo].uid];
    }
    NSDictionary * params = @{
                            @"nid":self.newsID,
                            @"last_id":idNum,
                            @"uid":userID
                              };
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    __weak CommentViewController * weakSelf = self;
    [manager GET:[BERApiProxy urlWithAction:@"news"] parameters:[BERApiProxy paramsWithDataDic:params action:@"comment_list"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] integerValue] == 0) {
            NSDictionary * comment = dic[@"info"];
            weakSelf.commentNumber.text = [NSString stringWithFormat:@"%@",comment[@"all_count"]];
            
            id list = dic[@"data"];
            if(list && ![list isKindOfClass:[NSNull class]]){
                NSArray * arr = (NSArray *)list;
                for (int i = 0; i < arr.count; i ++) {
                    NSDictionary * dic = arr[i];
                    CommentModel * model = [[CommentModel alloc]initWithDictionary:dic];
                    [weakSelf.dataArray addObject:model];
                }
                if (arr.count == 0 || arr.count<10) {
                    self.needMoreData = NO;
                }else{
                    self.needMoreData = YES;
                }
            }
        }
        [weakSelf.tabview reloadData];
        [weakSelf.view hideLoadWithAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.view hideLoadWithAnimated:YES];
    }];
}
- (void)likeCommentRequestWithIndexPath:(NSIndexPath *)indepath{
    CommentModel * model = self.dataArray[indepath.row];
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [self.view showLoadWithAnimated:YES];
    
    NSDictionary * params = @{
                              @"cid":[NSString stringWithFormat:@"%@",model.id],
                              @"uid":[NSString stringWithFormat:@"%@",[UserInfo defaultInfo].uid],
                              @"callback_verify":token
                              };
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    __weak CommentViewController * weakSelf = self;
    [manager GET:[BERApiProxy urlWithAction:@"news"] parameters:[BERApiProxy paramsWithDataDic:params action:@"comment_good"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] integerValue] == 0) {
            model.gooded = YES;
            model.good = @(model.good.longValue+1);
        }
        [weakSelf.tabview reloadData];
        [weakSelf.view hideLoadWithAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.view hideLoadWithAnimated:YES];
    }];
    
}


@end
