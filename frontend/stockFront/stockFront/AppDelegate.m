//
//  AppDelegate.m
//  stockFront
//
//  Created by wang jam on 1/3/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "AppDelegate.h"
#import "startViewCtrl.h"
#import "loginViewCtrl.h"
#import "NetworkAPI.h"
#import "macro.h"
#import "returnCode.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)startView
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    UINavigationController* rootNav = [[UINavigationController alloc] initWithRootViewController:[[startViewCtrl alloc] init]];
    
    //rootNav.navigationBar.translucent = NO;
    rootNav.navigationBar.barTintColor = [UIColor whiteColor];
    rootNav.navigationBar.tintColor = [UIColor blackColor];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//状态栏白色
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    //去掉nav返回字
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
//                                                         forBarMetrics:UIBarMetricsDefault];
    
    self.window.rootViewController = rootNav;
    
    [self.window makeKeyAndVisible];
}


- (void)backToStartView
{
    [(UINavigationController*)self.window.rootViewController popToRootViewControllerAnimated:YES];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _isLogin = false;
    _myInfo = [[UserInfoModel alloc] init];
    
    _myInfo.user_phone = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    _myInfo.user_password = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if (_myInfo.user_phone == nil||_myInfo.user_password == nil
        ||_myInfo.user_phone.length == 0||_myInfo.user_password.length == 0) {
        [self startView];
    }else{
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        
        startViewCtrl* startView = [[startViewCtrl alloc] init];
        loginViewCtrl* signInView = [[loginViewCtrl alloc] init];
        UINavigationController* rootNav = [[UINavigationController alloc] initWithRootViewController:startView];
        [rootNav pushViewController:signInView animated:NO];
        
        rootNav.navigationBar.barTintColor = [UIColor whiteColor];
        rootNav.navigationBar.tintColor = [UIColor blackColor];
        
        self.window.rootViewController = rootNav;
        
        signInView.view.hidden = YES;
        //rootNav.navigationController.view.backgroundColor = [UIColor whiteColor];
        [signInView sendLoginMessage:_myInfo];
        [self.window makeKeyAndVisible];

    }
    
    
    //通知系统应用接收推送
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    
    return YES;
}

+ (LocDatabase*)getLocDatabase
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return app.locDatabase;
}

+ (UserInfoModel*)getMyUserInfo
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return app.myInfo;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"regisger success:%@",deviceToken);
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    
    _myInfo.device_token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    //注册成功，将deviceToken保存到应用服务器数据库中
    if (_myInfo.user_id!=nil) {
        
        
        
        NSDictionary* message = [[NSDictionary alloc]initWithObjects:@[_myInfo.user_id, _myInfo.device_token]forKeys:@[@"user_id", @"device_token"]];
        
        [NetworkAPI callApiWithParam:message childpath:@"/user/updateDeviceToken" successed:^(NSDictionary *response) {
            NSInteger code = [[response objectForKey:@"code"] integerValue];
            if (code == SUCCESS) {
                
            }else{
                
                [Tools AlertBigMsg:@"token更新失败"];
            }
            
        } failed:^(NSError *error) {
            [Tools AlertBigMsg:@"token更新失败"];
        }];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // 处理推送消息
    NSLog(@"userinfo:%@",userInfo);
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Registfail%@",error);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.jam.stockFront" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"stockFront" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"stockFront.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
