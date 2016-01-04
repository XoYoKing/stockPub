//
//  macro.h
//  stockFront
//
//  Created by wang jam on 1/3/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#ifndef macro_h
#define macro_h


#define fontName @"HelveticaNeue-Thin"
#define bigFont 32
#define middleFont 24
#define minFont 16
#define microFont 12


#define minSpace 8

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height



#define alertMsg(x) MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];hud.mode = MBProgressHUDModeText;hud.labelText = x;hud.removeFromSuperViewOnHide = YES;[hud hide:YES afterDelay:2];


#endif /* macro_h */
