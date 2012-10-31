//
//  LoginViewController.h
//  qiushi
//
//  Created by xyxd mac on 12-10-26.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASIHTTPRequest;
@class ASIFormDataRequest;

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
     ASIHTTPRequest *_httpRequest;
    ASIFormDataRequest *_formRequest;
}

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *nameTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *pswTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *mTest;
@property (nonatomic, retain) ASIHTTPRequest *httpRequest;
@property (nonatomic, retain) ASIFormDataRequest *formRequest;
@end
