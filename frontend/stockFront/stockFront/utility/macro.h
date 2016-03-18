//
//  macro.h
//  stockFront
//
//  Created by wang jam on 1/3/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#ifndef macro_h
#define macro_h

#import <MBProgressHUD.h>
#import "Tools.h"


#define fontName @"HelveticaNeue-Light"
#define bigbigFont 46
#define bigFont 32
#define middleFont 24
#define minMiddleFont 20
#define minFont 16
#define microFont 12


#define activeViewControllerbackgroundColor [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]


#define sepeartelineColor activeViewControllerbackgroundColor


#define OurBlue [UIColor colorWithRed:49.0/255.0 green:117.0/255.0 blue:181.0/255.0 alpha:1.0]

#define mygreen [UIColor colorWithRed:56/255.0 green:142/255.0 blue:60/255.0 alpha:1.0]


#define myred [UIColor colorWithRed:211/255.0 green:47/255.0 blue:47/255.0 alpha:1.0]

#define noticeRed [UIColor colorWithRed:238/255.0 green:90/255.0 blue:68/255.0 alpha:1.0]

#define minSpace 8

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define IS_IPHONE_4_OR_LESS (ScreenHeight < 568.0)
#define IS_IPHONE_5 (ScreenHeight == 568.0)
#define IS_IPHONE_6 (ScreenHeight == 667.0)
#define IS_IPHONE_6P (ScreenHeight == 736.0)


#define alertMsg(x) [Tools AlertBigMsg:x];;


#endif /* macro_h */
