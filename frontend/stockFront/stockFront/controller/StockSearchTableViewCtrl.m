//
//  StockSearchTableViewCtrl.m
//  stockFront
//
//  Created by wang jam on 1/11/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "StockSearchTableViewCtrl.h"
#import "macro.h"
#import "NetworkAPI.h"

@implementation StockSearchTableViewCtrl
{
    NSMutableArray* stockList;
    UITextField* stockSearchTextField;
}

- (void)viewDidLoad
{
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setText:@"搜索"];
    [navTitle setFont:[UIFont fontWithName:fontName size:middleFont]];
    navTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    stockList = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    [self.tableView setDataSource:self];
    [self.tableView reloadData];

}


- (void)viewWillDisappear:(BOOL)animated
{
    [stockSearchTextField resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [stockSearchTextField becomeFirstResponder];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString* cellIdentifier = @"searchcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        // Configure the cell...
        // Configure the cell...
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        
        UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 4*minSpace, 6*minSpace)];
        textField.textAlignment = NSTextAlignmentLeft;
        textField.font = [UIFont fontWithName:fontName size:minFont];
        textField.placeholder = @"请输入股票代码";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        stockSearchTextField = textField;
        cell.accessoryView = textField;
        stockSearchTextField.delegate = self;
        [stockSearchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    
    return nil;

}


- (void)textFieldDidChange:(UITextField*)textField
{
    if(textField.text.length == 6){
        NSLog(@"search stock code: %@", textField.text);
        NSString* stockCode = textField.text;
        
        
        
    }
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (section == 1) {
        return @"搜索结果";
    }
    return @"";
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    if(section == 1){
        return [stockList count];
    }
    
    return 0;
}

@end
