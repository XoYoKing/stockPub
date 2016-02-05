//
//  FaceImageViewController.h
//  stockFront
//
//  Created by wang jam on 1/21/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"

@interface FaceImageViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
- (id)init:(UserInfoModel*)userinfo;
@end
