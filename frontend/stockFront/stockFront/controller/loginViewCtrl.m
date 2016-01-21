//
//  loginViewCtrl.m
//  stockFront
//
//  Created by wang jam on 1/3/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "loginViewCtrl.h"
#import <Masonry.h>
#import "macro.h"
#import "RegisterCellViewTableViewCell.h"
#import "NetworkAPI.h"
#import <MBProgressHUD.h>
#import "AppDelegate.h"
#import "Tools.h"
#import "returnCode.h"
#import <YYModel.h>
#import "TabBarViewController.h"


@interface loginViewCtrl ()
{
    UIButton* loginButton;
    UITableView* tableview;
    UITextField* phoneNumTextField;
    UITextField* passwordTextField;
}
@end

@implementation loginViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    tableview = [[UITableView alloc] init];
    
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    tableview.scrollEnabled = NO;
    [self.view addSubview: tableview];
    
    
    loginButton = [[UIButton alloc] init];
    [loginButton setTitle:[[NSString alloc] initWithFormat:@"登录"] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:fontName size:bigFont];
    
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [loginButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top).offset(4*minSpace);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 4*[RegisterCellViewTableViewCell cellHeight]));
    }];
    
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tableview.mas_bottom).offset(minSpace);
        make.centerX.mas_equalTo(tableview.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(8*minSpace, 6*minSpace));
    }];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [phoneNumTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [phoneNumTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}


- (void)sendLoginMessage:(UserInfoModel*)userInfo
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //发送登录消息
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[userInfo.user_phone,
                                               userInfo.user_password]
                             forKeys:@[@"user_phone", @"user_password"]];
    
    [NetworkAPI callApiWithParam:message childpath:@"/user/login" successed:^(NSDictionary *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == LOGIN_SUCCESS){
            
            AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            app.myInfo = [UserInfoModel yy_modelWithDictionary:[response objectForKey:@"data"]];
            //用户登录信息持久化
            NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
            [mySettingData setObject:app.myInfo.user_phone forKey:@"phone"];
            [mySettingData setObject:app.myInfo.user_password forKey:@"password"];
            [mySettingData synchronize];
            
            //本地库连接
            NSLog(@"%@", app.myInfo.user_id);
            app.locDatabase = [[LocDatabase alloc] init];
            if(![app.locDatabase connectToDatabase:app.myInfo.user_id]){
                alertMsg(@"本地数据库问题");
                return;
            }
            
            TabBarViewController* tabbarView = [[TabBarViewController alloc] init];
            [self presentViewController:tabbarView animated:YES completion:nil];
            
        }else if(code == LOGIN_FAIL){
            alertMsg(@"用户或密码错误");
        }else{
            alertMsg(@"未知错误");
        }
        
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        alertMsg(@"网络问题");
    }];

}

- (void)nextStep:(id)sender
{
    [phoneNumTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    if ([phoneNumTextField.text isEqualToString:@""]||[passwordTextField.text  isEqualToString:@""]) {
        alertMsg(@"用户名或密码不能为空");
        return;
    }
    
    
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    app.myInfo.user_phone = phoneNumTextField.text;
    
    app.myInfo.user_password = [Tools encodePassword:passwordTextField.text];
    
    [self sendLoginMessage:app.myInfo];
    
    
    NSLog(@"loginButtonAction");

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RegisterCellViewTableViewCell cellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RegisterCellViewTableViewCell* cell = [[RegisterCellViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RegisterCellViewTableViewCell"];
    
    
    if(indexPath.section == 0){
        
        UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 230, 6*minSpace)];
        textField.textAlignment = NSTextAlignmentLeft;
        textField.font = [UIFont fontWithName:fontName size:minFont];
        cell.accessoryView = textField;
        
        if (indexPath.row==0) {
            textField.placeholder = @"请输入手机号码";
            textField.keyboardType = UIKeyboardTypeNumberPad;
            phoneNumTextField = textField;
            cell.imageView.image = [UIImage imageNamed:@"cellphone64px.png"];
        }
        if (indexPath.row == 1) {
            textField.placeholder = @"请输入密码";
            textField.secureTextEntry = YES;
            passwordTextField = textField;
            cell.imageView.image = [UIImage imageNamed:@"password64px.png"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
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
