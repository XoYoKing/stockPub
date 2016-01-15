//
//  TabBarViewController.m
//  CarSocial
//
//  Created by wang jam on 8/19/14.
//  Copyright (c) 2014 jam wang. All rights reserved.
//

#import "TabBarViewController.h"
#import "AppDelegate.h"
#import "NetworkAPI.h"
#import "Tools.h"
#import "ComTableViewCtrl.h"
#import "FollowAction.h"
#import "RankAction.h"
#import "stockAction.h"
#import "SettingCtrl.h"


@interface TabBarViewController ()
{
    NSMutableArray *controllers;
}
@end

@implementation TabBarViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)initChildView:(NSMutableArray*)navcontrollers viewController:(UIViewController*) viewController title:(NSString*)title
{
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    nav.navigationBar.barTintColor = [UIColor whiteColor];
    nav.navigationBar.tintColor = [UIColor blackColor];
    nav.navigationController.navigationBar.translucent = NO;
    
//    UIView *bgView = [[UIView alloc] initWithFrame:nav.navigationBar.bounds];
//    bgView.backgroundColor = [UIColor whiteColor];
//    [nav.navigationBar insertSubview:bgView atIndex:0];
//    nav.navigationBar.opaque = YES;
    
    
    
    //self.tabBar.barTintColor = subjectColor;
    nav.title = title;
    [navcontrollers addObject:nav];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:bgView atIndex:0];
    self.tabBar.opaque = YES;
    
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.tintColor = [UIColor blackColor];
    //self.view.backgroundColor = [UIColor clearColor];
    
    [self initControllerViews];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{

    //double click to refresh
    
    if(self.selectedIndex == 2&&item.tag == 2){
        NSLog(@"%ld", item.tag);
        UINavigationController* nav = [self.viewControllers objectAtIndex:self.selectedIndex];
        
        if([nav.topViewController isKindOfClass:[ComTableViewCtrl class]]){
            ComTableViewCtrl* comTable = (ComTableViewCtrl*)nav.topViewController;
            
            
            //[comTable pullDown];
            [comTable refreshNew];
        }

    }
}

- (void)initControllerViews
{
    if(controllers != nil){
        return;
    }
    
    
    controllers = [NSMutableArray array];
    
    
    ComTableViewCtrl* followContentTableCtrl = [[ComTableViewCtrl alloc] init:YES allowPullUp:YES initLoading:YES comDelegate:[[FollowAction alloc] init]];
    
    ComTableViewCtrl* rankTableCtrl = [[ComTableViewCtrl alloc] init:YES allowPullUp:YES initLoading:YES comDelegate:[[RankAction alloc] init]];

    
    ComTableViewCtrl* stockTableCtrl = [[ComTableViewCtrl alloc] init:YES allowPullUp:NO initLoading:YES comDelegate:[[stockAction alloc] init]];

    
    
    
    SettingCtrl* setting = [[SettingCtrl alloc] init:[AppDelegate getMyUserInfo]];
    
    [self initChildView:controllers viewController:followContentTableCtrl title:@"关注"];
    [self initChildView:controllers viewController:rankTableCtrl title:@"排行"];
    [self initChildView:controllers viewController:stockTableCtrl title:@"自选"];
    [self initChildView:controllers viewController:setting title:@"我"];
    
    
    self.viewControllers = controllers;
    
    UITabBarItem *tabItem = [[self.tabBar items] objectAtIndex:0];
    //UIImage* image = [UIImage imageNamed:@"nearbylocation.png"];
    //[tabItem setImage:image];
    tabItem.tag = 0;
    
    
    //[tabItem setTitle:@"活动"]
    
    tabItem = [[self.tabBar items] objectAtIndex:1];
    //image = [UIImage imageNamed:@"hot.png"];
    //[tabItem setImage:image];
    tabItem.tag = 1;
    
    //tabItem
    //[tabItem setTitle:@"附近"]
    
    tabItem = [[self.tabBar items] objectAtIndex:2];
    //image = [UIImage imageNamed:@"message.png"];
    
    //[tabItem setImage:image];
    tabItem.tag = 2;
    //[tabItem setTitle:@"消息"]
    
    tabItem = [[self.tabBar items] objectAtIndex:3];
    //image = [UIImage imageNamed:@"setting.png"];
    //[tabItem setImage:image];
    tabItem.tag = 3;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && [self.view window] == nil) {
        NSLog(@"tabbarview delloc");
        self.view = nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end