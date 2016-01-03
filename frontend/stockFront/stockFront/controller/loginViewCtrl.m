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
    loginButton.titleLabel.font = [UIFont fontWithName:fontName size:32];
    
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

- (void)nextStep:(id)sender
{
    
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
        textField.font = [UIFont fontWithName:fontName size:16];
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
