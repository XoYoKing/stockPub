//
//  FaceImageViewController.m
//  stockFront
//
//  Created by wang jam on 1/21/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "FaceImageViewController.h"
#import "macro.h"
#import "AppDelegate.h"
#import "UserInfoModel.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface FaceImageViewController ()
{
    UserInfoModel* usrInfo;
    UIImageView* imageView;
}
@end

@implementation FaceImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 8*minSpace)];
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(navigationBackButton:)];
    
    
    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@""];
    
    navigationBarTitle.leftBarButtonItem = leftitem;
    
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if ([usrInfo.user_id isEqualToString:app.myInfo.user_id]) {
        UIBarButtonItem* rightitem = [[UIBarButtonItem alloc] initWithTitle:@"替换" style:UIBarButtonItemStylePlain target:self action:@selector(changeButton:)];
        navigationBarTitle.rightBarButtonItem = rightitem;
    }
    
    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
    navigationBar.backgroundColor = [UIColor whiteColor];
    navigationBar.barTintColor = [UIColor whiteColor];
    navigationBar.tintColor = [UIColor blackColor];
    
    [self.view addSubview: navigationBar];
    
    imageView = [[UIImageView alloc] init];
    imageView.frame = self.view.frame;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    
    if(usrInfo.user_facethumbnail == nil){
        imageView.image = [UIImage imageNamed:@"man-noname.png"];
    }else{
        [imageView sd_setImageWithURL:[[NSURL alloc] initWithString:usrInfo.user_facethumbnail]];
    }
    [self.view addSubview:imageView];
}


- (void)changeButton:(id)sender
{
    
}

- (id)init:(UserInfoModel*)userinfo
{
    if(self = [super init]){
        usrInfo = userinfo;
    }
    return self;
}

- (void)navigationBackButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
