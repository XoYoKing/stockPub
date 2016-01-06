//
//  RegisterPhoneNumViewController.m
//  CarSocial
//
//  Created by wang jam on 8/30/14.
//  Copyright (c) 2014 jam wang. All rights reserved.
//

#import "RegisterPhoneNumViewController.h"
#import "RegisterConfirmViewController.h"
#import "RegisterCellViewTableViewCell.h"
#import <MBProgressHUD.h>
#import "NetworkAPI.h"
#import "macro.h"
#import <Masonry.h>
#import "AppDelegate.h"
#import "returnCode.h"

@interface RegisterPhoneNumViewController ()
{
    UITableView* tableview;
    UITextField* phoneNumTextField;
    UITextField* passwordTextField;
    UILabel* noticeLabel;
}
@end

@implementation RegisterPhoneNumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top).offset(4*minSpace);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 4*[RegisterCellViewTableViewCell cellHeight]));
    }];
    
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tableview.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left).offset(2*minSpace);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 4*minSpace, 6*minSpace));
    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setTextColor:[UIColor blackColor]];
    [navTitle setText:@"登录信息"];
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.font = [UIFont fontWithName:fontName size:middleFont];
    self.navigationItem.titleView = navTitle;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep:)];
    
    
    tableview = [[UITableView alloc] init];
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    tableview.scrollEnabled = NO;
    [self.view addSubview: tableview];
    
    
    noticeLabel = [[UILabel alloc] init];
    noticeLabel.textColor = [UIColor grayColor];
    noticeLabel.text = @"为了保护你的账号安全，请勿设置过于简单的密码 我们不会在任何地方泄露你的手机号码";
    noticeLabel.font = [UIFont fontWithName:fontName size:microFont];
    noticeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    noticeLabel.numberOfLines = 0;
    [self.view addSubview:noticeLabel];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RegisterCellViewTableViewCell cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RegisterCellViewTableViewCell* cell = [[RegisterCellViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RegisterCellViewTableViewCell"];
    
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 230, 6*minSpace)];
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
        passwordTextField = textField;
        cell.imageView.image = [UIImage imageNamed:@"password64px"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)nextStep:(id)sender
{
    if (phoneNumTextField == nil||phoneNumTextField.text.length!=11) {
        alertMsg(@"电话号码格式不对");
        return;
    }
    
    if (passwordTextField == nil||passwordTextField.text.length<6) {
        alertMsg(@"密码不能小于6位");
        return;
    }
    
    [phoneNumTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"确认手机号码" message:phoneNumTextField.text delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert setTag:101];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 101) {
        if (buttonIndex == 0) {
            NSLog(@"%ld", (long)buttonIndex);
        }
        if (buttonIndex == 1) {
            NSLog(@"%ld", (long)buttonIndex);
            
            
            UserInfoModel* userInfo = [AppDelegate getMyUserInfo];
            userInfo.user_password = passwordTextField.text;
            userInfo.user_phone = phoneNumTextField.text;
            
            
            NSDictionary* message = [[NSDictionary alloc] initWithObjects:@[userInfo.user_phone] forKeys:@[@"user_phone"]];
            
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];

            
            [NetworkAPI callApiWithParam:message childpath:@"/user/confirmPhone" successed:^(NSDictionary *response) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSInteger code = [[response objectForKey:@"code"] integerValue];
                if(code == CERTIFICATE_CODE_SEND||code == CERTIFICATE_CODE_SENDED){
                        [self.navigationController pushViewController:[[RegisterConfirmViewController alloc] init] animated:YES];
                }else if(code == PHONE_EXIST){
                    alertMsg(@"电话号码已被注册");
                }else{
                    alertMsg(@"未知问题");
                }

            } failed:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                alertMsg(@"网络问题");
            }];
        }
    }
}



- (void)certificateCodeSend:(id)sender
{
//    RegisterConfirmViewController* confirmView = [[RegisterConfirmViewController alloc] init];
//    confirmView.userInfo = _userInfo;
//    
//    [self.navigationController pushViewController:confirmView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && [self.view window] == nil) {
        NSLog(@"registerphone delloc");
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
