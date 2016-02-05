//
//  AppDelegate.h
//  stockFront
//
//  Created by wang jam on 1/3/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "UserInfoModel.h"
#import "LocDatabase.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property UserInfoModel* myInfo;
@property LocDatabase* locDatabase;
@property UITabBarController* tabBarViewController;

- (void)backToStartView;
+ (UserInfoModel*)getMyUserInfo;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (LocDatabase*) getLocDatabase;


@end

