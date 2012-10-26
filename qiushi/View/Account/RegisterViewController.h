//
//  RegisterViewController.h
//  qiushi
//
//  Created by xyxd mac on 12-10-26.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
<UITextFieldDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *mName;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *mPsw;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *mRePsw;


@end
