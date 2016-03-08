//
//  AppDelegate.h
//  Bayern
//
//  Created by wusicong on 15/6/1.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BERMainViewController.h"
#import "pushModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) BERMainViewController *mainViewController;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) pushModel *model;
@property (nonatomic, strong) NSDictionary *reseverInfo;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (AppDelegate *)sharedInstance;

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated;
- (void)toggleRightDrawer:(id)sender animated:(BOOL)animated;

- (void)pushNewsWithNewsLink:(NSString *)newsLink;
- (void)pushPicWithPicLink:(NSString *)picLik;
@end

