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

#define mygreen [UIColor colorWithRed:60/255.0 green:144/255.0 blue:15/255.0 alpha:1.0]


#define myred [UIColor colorWithRed:180/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]


#define minSpace 8

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height



#define alertMsg(x) [Tools AlertBigMsg:x];;


#endif /* macro_h */
