//
//  RegisterNickNameViewController.m
//  CarSocial
//
//  Created by wang jam on 8/29/14.
//  Copyright (c) 2014 jam wang. All rights reserved.
//

#import "RegisterNickNameViewController.h"
//#import "TextFieldView.h"
//#import "Constant.h"
//#import "RegisterUserInfoViewController.h"
#import "UserInfoModel.h"
//#import "Tools.h"
//#import "NetWork.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "macro.h"
#import "RegisterCellViewTableViewCell.h"
//#import "RegisterPhoneNumViewController.h"
#import <Masonry.h>
#import "NetworkAPI.h"
#import "Tools.h"
#import "returnCode.h"
#import "AppDelegate.h"
#import "RegisterPhoneNumViewController.h"
#import "webViewCtrl.h"

@interface RegisterNickNameViewController ()
{
    //TextFieldView* textField;
    UITableView* tableview;
    UITextField* nickNameTextField;
    UILabel* noticeLabel;
}
@end

@implementation RegisterNickNameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setTextColor:[UIColor blackColor]];
    navTitle.font = [UIFont fontWithName:fontName size:middleFont];
    [navTitle setText:@"输入名称"];
    navTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep:)];
    
    tableview = [[UITableView alloc] init];
    
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    tableview.scrollEnabled = NO;
    [self.view addSubview: tableview];
    
    noticeLabel = [[UILabel alloc] init];
    
    
    [self.view addSubview:noticeLabel];
    noticeLabel.text = @"注册即表示同意《懒人股票用户协议》";
    noticeLabel.textColor = OurBlue;
    noticeLabel.font = [UIFont fontWithName:fontName size:microFont];
    noticeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    noticeLabel.numberOfLines = 0;
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.userInteractionEnabled = YES;
    [noticeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickNotice:)]];

    
}


- (void)clickNotice:(id)sender
{
    webViewCtrl* eula = [[webViewCtrl alloc] initWithUrl:@"http://112.74.102.178:10808/eula" title:@"用户协议"];
    [self.navigationController pushViewController:eula animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top).offset(4*minSpace);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 3*[RegisterCellViewTableViewCell cellHeight]));
    }];
    
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tableview.mas_bottom);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 2*minSpace, 2*minSpace));
    }];
    
    //[nickNameTextField becomeFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [nickNameTextField resignFirstResponder];
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
    return 1;
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
            textField.placeholder = @"请输入名称";
            nickNameTextField = textField;
            cell.imageView.image = [UIImage imageNamed:@"nickname64px.png"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}


- (void)viewDidAppear:(BOOL)animated
{
    [nickNameTextField becomeFirstResponder];
}

- (void)nextStep:(id)sender
{
    nickNameTextField.text = [nickNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (nickNameTextField.text.length==0||nickNameTextField.text==nil) {
        
        alertMsg(@"名字不能为空");
        return;
    }

    [nickNameTextField resignFirstResponder];
    
    //验证名字是否已存在
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSDictionary* message = [[NSDictionary alloc] initWithObjects:@[nickNameTextField.text] forKeys:@[@"user_name"]];
    
    [NetworkAPI callApiWithParam:message childpath:@"/user/checkNameExist" successed:^(NSDictionary *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == USER_NOT_EXIST){
            
            UserInfoModel* myinfo = [AppDelegate getMyUserInfo];
            myinfo.user_name = nickNameTextField.text;
            
            [self.navigationController pushViewController:[[RegisterPhoneNumViewController alloc] init] animated:YES];
            
            
        }else if(code == USER_EXIST){
            alertMsg(@"用户名已存在");
        }else{
            alertMsg(@"未知错误");
        }

        
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        alertMsg(@"网络问题");
    }];
}

- (void)userNameNotExist:(id)sender
{
//    _userInfo.nickName = textField.text;
//    
//    RegisterPhoneNumViewController* registerPhoneInfo = [[RegisterPhoneNumViewController alloc] init];
//    registerPhoneInfo.userInfo = _userInfo;
//    
//    [self.navigationController pushViewController:registerPhoneInfo animated:YES];
}


- (void)userNameExist:(id)sender
{
//    [Tools AlertBigMsg:@"名称已被注册"];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && [self.view window] == nil) {
        NSLog(@"registernickname delloc");
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
