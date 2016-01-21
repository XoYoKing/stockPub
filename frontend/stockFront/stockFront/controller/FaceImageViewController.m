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
#import "NetworkAPI.h"
#import "ConfigAccess.h"
#import "returnCode.h"
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



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)aImage editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
    imageView.image = aImage;
    
    NSDictionary* images = [[NSDictionary alloc] initWithObjects:@[aImage] forKeys:@[@"user_image"]];
    NSDictionary* param = [[NSDictionary alloc] initWithObjects:@[usrInfo.user_id] forKeys:@[@"user_id"]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [NetworkAPI callApiWithParamForImage:param imageDatas:images childpath:@"/user/changeFace" successed:^(NSDictionary *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        if(code == SUCCESS){
            
            NSDictionary* data = [response objectForKey:@"data"];
            NSString* fileName = [data objectForKey:@"fileName"];
            [self dismissViewControllerAnimated:YES completion:nil];            
        }
        
        if(code == ERROR){
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"上传失败";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
        }
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"网络问题";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];

    }];
    
//    //update image
//    //addImageView.image = aImage;
//    
//    NetWork* netWork = [[NetWork alloc] init];
//    
//    
//    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    
//    NSDictionary* message = [[NSDictionary alloc] initWithObjects:@[app.myInfo.userID, @"/changeFace"] forKeys:@[@"user_id", @"childpath"]];
//    
//    NSDictionary* images = [[NSDictionary alloc] initWithObjects:@[aImage] forKeys:@[@"user_image"]];
//    
//    
//    NSDictionary* feedbackcall = [[NSDictionary alloc] initWithObjects:@[[NSValue valueWithBytes:&@selector(changeUserFaceSuccess:) objCType:@encode(SEL)], [NSValue valueWithBytes:&@selector(changeUserFaceError:) objCType:@encode(SEL)], [NSValue valueWithBytes:&@selector(changeUserFaceException:) objCType:@encode(SEL)]] forKeys:@[[[NSNumber alloc] initWithInt:SUCCESS], [[NSNumber alloc] initWithInt:ERROR], [[NSNumber alloc] initWithInt:EXCEPTION]]];
//    
//    [netWork message:message images:images feedbackcall:feedbackcall complete:^{
//        [loadingView hide:YES];
//        loadingView = nil;
//    } callObject:self];
//    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//状态栏白色
    
    
}


- (void)changeButton:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
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
