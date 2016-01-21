//
//  RegisterConfirmViewController.m
//  CarSocial
//
//  Created by wang jam on 8/30/14.
//  Copyright (c) 2014 jam wang. All rights reserved.
//

#import "RegisterConfirmViewController.h"
#import <MBProgressHUD.h>
#import "NetworkAPI.h"
#import "macro.h"
//#import "TabBarViewController.h"
#import "AppDelegate.h"
#import <CocoaSecurity.h>
#import "Tools.h"
#import "UserInfoModel.h"
#import <Masonry.h>
#import "RegisterCellViewTableViewCell.h"
#import "returnCode.h"
#import "TabBarViewController.h"
#import <YYModel.h>


@interface RegisterConfirmViewController ()
{
    int sec;
    UIButton* resendButton;
    NSTimer* timer;
    UITableView* tableview;
    UILabel* noticeLabel;
    UITextField* confirmTextField;
}
@end

@implementation RegisterConfirmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sec = 60;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setTextColor:[UIColor blackColor]];
    [navTitle setText:@"验证手机"];
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.font = [UIFont fontWithName:fontName size:middleFont];
    self.navigationItem.titleView = navTitle;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep:)];
    
    noticeLabel = [[UILabel alloc] init];
    noticeLabel.textColor = [UIColor lightGrayColor];
    UserInfoModel* userInfo = [AppDelegate getMyUserInfo];
    noticeLabel.text = [[NSString alloc] initWithFormat:@"%@%@", @"验证码短信已发送到: +86 ", userInfo.user_phone];
    noticeLabel.font = [UIFont fontWithName:fontName size:microFont];
    [self.view addSubview:noticeLabel];
    
    
    
    tableview = [[UITableView alloc] init];
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    tableview.scrollEnabled = NO;
    
    [self.view addSubview: tableview];
    
    
    
    //重发验证码
    resendButton = [[UIButton alloc] init];
    [resendButton setEnabled:NO];
    resendButton.titleLabel.font = [UIFont fontWithName:fontName size:middleFont];
    [resendButton setTitle:[[NSString alloc] initWithFormat:@"重发验证码(%d)", sec] forState:UIControlStateDisabled];
    [resendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [resendButton addTarget:self action:@selector(resendConfirmNum:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resendButton];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeInvoke:) userInfo:nil repeats:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [confirmTextField resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [confirmTextField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(10*minSpace);
        make.left.mas_equalTo(self.view.mas_left).offset(2*minSpace);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 4*minSpace, 3*minSpace));
    }];
    
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(noticeLabel.mas_bottom).offset(minSpace);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1*[RegisterCellViewTableViewCell cellHeight]));
    }];
//
    [resendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(2*minSpace);
        make.right.mas_equalTo(self.view.mas_right).offset(-2*minSpace);
        make.top.mas_equalTo(tableview.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 4*minSpace, 6*minSpace));
    }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RegisterCellViewTableViewCell cellHeight];
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
            textField.placeholder = @"请输入验证码";
            textField.keyboardType = UIKeyboardTypeNumberPad;
            confirmTextField = textField;
            cell.imageView.image = [UIImage imageNamed:@"earth64px.png"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)timeInvoke:(id)sender
{
    if (sec>0) {
        sec = sec-1;
        
        resendButton.titleLabel.text = [[NSString alloc] initWithFormat:@"重发验证码(%d)", sec];
    }else{
        [resendButton setEnabled:YES];
        [resendButton setTitle:[[NSString alloc] initWithFormat:@"重发验证码"] forState:UIControlStateNormal];
        [resendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [timer invalidate];
    }
    NSLog(@"timeInvoke");
}



- (void)resendConfirmNum:(id)sender
{
    sec = 60;
    [resendButton setTitle:[[NSString alloc] initWithFormat:@"重发验证码(%d)", sec] forState:UIControlStateDisabled];
    [resendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    [resendButton setEnabled:NO];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeInvoke:) userInfo:nil repeats:YES];
    
    
//    //异步获取手机验证码
//    NetWork* netWork = [[NetWork alloc] init];
//    NSDictionary* message = [[NSDictionary alloc] initWithObjects:@[_userInfo.phoneNum, @"/confirmPhone"] forKeys:@[@"user_phone", @"childpath"]];
//    
//    
//    NSDictionary* feedbackcall = [[NSDictionary alloc] initWithObjects:@[[NSValue valueWithBytes:&@selector(certificateCodeSend:) objCType:@encode(SEL)],[NSValue valueWithBytes:&@selector(phoneExist:) objCType:@encode(SEL)],[NSValue valueWithBytes:&@selector(CertificateCodeSended:) objCType:@encode(SEL)],[NSValue valueWithBytes:&@selector(certificateError:) objCType:@encode(SEL)],[NSValue valueWithBytes:&@selector(certificateException:) objCType:@encode(SEL)] ] forKeys:@[[[NSNumber alloc] initWithInt:CERTIFICATE_CODE_SEND],[[NSNumber alloc] initWithInt:PHONE_EXIST],[[NSNumber alloc] initWithInt:CERTIFICATE_CODE_SENDED],[[NSNumber alloc] initWithInt:ERROR], [[NSNumber alloc] initWithInt:EXCEPTION]]];
//    
//    [netWork message:message images:nil feedbackcall:feedbackcall complete:nil callObject:self];
}

- (void)CertificateCodeSended:(id)sender
{
    alertMsg(@"验证码已发送,请等待");
}

- (void)phoneExist:(id)sender
{
    alertMsg(@"电话号码已被注册");
}

- (void)certificateCodeSend:(id)sender
{
    alertMsg(@"验证码已发送");
}

- (void)certificateError:(id)sender
{
    alertMsg(@"网络问题");
}

- (void)certificateException:(id)sender
{
    alertMsg(@"未知问题");
}

- (void)nextStep:(id)sender
{
    [confirmTextField resignFirstResponder];
    confirmTextField.text = [confirmTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (confirmTextField.text.length==0||confirmTextField.text == nil) {
        alertMsg(@"验证码不能为空");
        return;
    }
    
    UserInfoModel* myInfo = [AppDelegate getMyUserInfo];
    
    myInfo.user_certificate_code = confirmTextField.text;
    NSString* encodePassword = [Tools encodePassword:myInfo.user_password];
    
    //异步注册信息
    NSDictionary* message = [[NSDictionary alloc] initWithObjects:@[myInfo.user_phone, myInfo.user_certificate_code, myInfo.user_name, encodePassword] forKeys:@[@"user_phone", @"user_certificate_code", @"user_name", @"user_password"]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [NetworkAPI callApiWithParam:message childpath:@"/user/register" successed:^(NSDictionary *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        if(code == CERTIFICATE_CODE_NOT_MATCH){
            alertMsg(@"验证码错误");
        }else if (code == REGISTER_SUCCESS){
            
            [self registerSuccess:[response objectForKey:@"data"]];
            
        }else if (code == PHONE_EXIST){
            alertMsg(@"电话号码已存在");
        }else{
            alertMsg(@"未知问题");
        }
        
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        alertMsg(@"网络问题");
    }];
    
}

- (void)registerSuccess:(NSDictionary*)data
{
    UserInfoModel* myInfo = [AppDelegate getMyUserInfo];

    myInfo = [UserInfoModel yy_modelWithDictionary:data];
    //用户登录信息持久化
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    [mySettingData setObject:myInfo.user_phone forKey:@"phone"];
    [mySettingData setObject:myInfo.user_password forKey:@"password"];
    [mySettingData synchronize];
    
    TabBarViewController* tabbarView = [[TabBarViewController alloc] init];
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    app.tabBarViewController = tabbarView;
    
    [self presentViewController:tabbarView animated:YES completion:nil];
}


- (void)certificateNotMatch:(id)sender
{
    //[Tools AlertBigMsg:@"验证码错误"];
}

- (void)registerException:(id)sender
{
    alertMsg(@"未知问题");
}

- (void)registerFail:(id)sender
{
    alertMsg(@"注册失败");
}

- (void)registerError:(id)sender
{
    alertMsg(@"网络问题");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && [self.view window] == nil) {
        NSLog(@"registerconfirm delloc");
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
