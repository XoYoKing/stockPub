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

@interface RegisterNickNameViewController ()
{
    //TextFieldView* textField;
    UITableView* tableview;
    UITextField* nickNameTextField;

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

    
    
//    UIView* textfieldBack = [[UIView alloc] initWithFrame:CGRectMake(textview_x, textview_y, ScreenWidth, textview_height)];
//    textfieldBack.backgroundColor = [UIColor whiteColor];
//    
//    textField = [[TextFieldView alloc] initWithFrame:CGRectMake(30, 0, ScreenWidth-30, textview_height)];
//    textField.placeholder = @"请输入名称";
//    [textfieldBack addSubview:textField];
//    
//    UIImageView* nickNameIcon = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 5, 32, 32)];
//    nickNameIcon.image = [UIImage imageNamed:@"nickname64px.png"];
//    
//    [textfieldBack addSubview:nickNameIcon];
//    
//    [self.view addSubview:textfieldBack];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top).offset(4*minSpace);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 3*[RegisterCellViewTableViewCell cellHeight]));
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
//    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    
//    if (textField.text.length==0||textField.text==nil) {
//        
//        [Tools AlertBigMsg:@"名字不能为空"];
//        return;
//    }
//    
//    [textField resignFirstResponder];
//    
//    //验证名字
//    MBProgressHUD* loadingView = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:loadingView];
//    [loadingView show:YES];
//    
//    NetWork* netWork = [[NetWork alloc] init];
//    NSDictionary* message = [[NSDictionary alloc] initWithObjects:@[textField.text, @"/checkNameExist"] forKeys:@[@"user_name", @"childpath"]];
//    
//    
//    NSDictionary* feedbackcall = [[NSDictionary alloc] initWithObjects:@[[NSValue valueWithBytes:&@selector(userNameExist:) objCType:@encode(SEL)],[NSValue valueWithBytes:&@selector(userNameNotExist:) objCType:@encode(SEL)]] forKeys:@[[[NSNumber alloc] initWithInt:USER_EXIST],[[NSNumber alloc] initWithInt:USER_NOT_EXIST]]];
//    
//    [netWork message:message images:nil feedbackcall:feedbackcall complete:^{
//        [loadingView hide:YES];
//        [loadingView removeFromSuperview];
//    } callObject:self];
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
