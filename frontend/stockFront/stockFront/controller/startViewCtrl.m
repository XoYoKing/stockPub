//
//  startViewCtrl.m
//  stockFront
//
//  Created by wang jam on 1/3/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "startViewCtrl.h"
#import <Masonry.h>
#import "macro.h"
#import "RegisterNickNameViewController.h"
#import "loginViewCtrl.h"

@implementation startViewCtrl
{
    UILabel* detailLabel;
    UILabel* versionLabel;
    UILabel* appNamelabel;
    UIButton* loginButton;
    UIButton* registerButton;
    UIImageView* startIcon;
}

- (void)viewDidLoad
{
    appNamelabel = [[UILabel alloc] init];
    appNamelabel.font = [UIFont fontWithName:fontName size:bigFont];
    appNamelabel.textColor = [UIColor blackColor];
    appNamelabel.textAlignment = NSTextAlignmentCenter;
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    // app名称
//    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    appNamelabel.text = @"懒人股票";
    [self.view addSubview:appNamelabel];
    
    detailLabel = [[UILabel alloc] init];
    detailLabel.font = [UIFont fontWithName:fontName size:minFont];
    detailLabel.textColor = [UIColor grayColor];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.text = @"不用思考的投资";
    [self.view addSubview:detailLabel];
    
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    versionLabel = [[UILabel alloc] init];
    versionLabel.font = [UIFont fontWithName:fontName size:minFont];
    versionLabel.textColor = [UIColor grayColor];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.text = [[NSString alloc] initWithFormat:@"%@%@", @"v", app_Version];
    [self.view addSubview:versionLabel];
    
    
    registerButton = [[UIButton alloc] init];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont fontWithName:fontName size:middleFont];
    [registerButton addTarget:self action:@selector(registerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    
    loginButton = [[UIButton alloc] init];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:fontName size:middleFont];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    startIcon = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - ScreenWidth/2)/2, 7*minSpace, ScreenWidth/2, ScreenWidth/2)];
    startIcon.clipsToBounds = YES;
    startIcon.contentMode = UIViewContentModeScaleAspectFit;
    startIcon.image = [UIImage imageNamed:@"startView.png"];
    
    [self.view addSubview:loginButton];
    [self.view addSubview:startIcon];
    
}


- (void)loginButtonAction:(id)sender
{
    NSLog(@"enter registerButtonAction");
    loginViewCtrl* signinView = [[loginViewCtrl alloc] init];
    [self.navigationController pushViewController:signinView animated:YES];
}

- (void)registerButtonAction:(id)sender
{
    NSLog(@"enter registerButtonAction");
    
    RegisterNickNameViewController* firstRegister = [[RegisterNickNameViewController alloc] init];
    
    [self.navigationController pushViewController:firstRegister animated:YES];
}


- (void)viewDidDisappear:(BOOL)animated
{
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;

    
//    [startIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.view.mas_centerX);
//        make.top.mas_equalTo(self.view.mas_top).offset(ScreenHeight/4);
//    }];
    
    //layout views
    [appNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(4*minSpace);
        make.right.mas_equalTo(self.view.mas_right).offset(-4*minSpace);
        make.top.mas_equalTo(startIcon.mas_bottom).offset(minSpace);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 8*minSpace, 7*minSpace));
    }];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(4*minSpace);
        make.right.mas_equalTo(self.view.mas_right).offset(-4*minSpace);
        make.top.mas_equalTo(appNamelabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 8*minSpace, 2*minSpace));
    }];
    
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(4*minSpace);
        make.right.mas_equalTo(self.view.mas_right).offset(-4*minSpace);
        make.top.mas_equalTo(detailLabel.mas_bottom).offset(minSpace);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 8*minSpace, 2*minSpace));

    }];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(5*minSpace);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-2*minSpace);
        make.size.mas_equalTo(CGSizeMake(6*minSpace, 6*minSpace));
    }];
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-5*minSpace);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-2*minSpace);
        make.size.mas_equalTo(CGSizeMake(6*minSpace, 6*minSpace));
    }];
    
    
}

@end
