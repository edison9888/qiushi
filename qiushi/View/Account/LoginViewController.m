//
//  LoginViewController.m
//  qiushi
//
//  Created by xyxd mac on 12-10-26.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "iToast.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize nameTextField  = _nameTextField;
@synthesize pswTextField = _pswTextField;
@synthesize mTest = _mTest;

#pragma mark - view lifecycle

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
    // Do any additional setup after loading the view from its nib.
    //限制字符长度
    [self.nameTextField addTarget:self action:@selector(textEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.pswTextField addTarget:self action:@selector(textEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setPswTextField:nil];
    [self setMTest:nil];
    [super viewDidUnload];
}
#pragma mark - delegate textField

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _nameTextField) {
        [_pswTextField becomeFirstResponder];
    }else if (textField == _pswTextField){
        [self loginAction];
    }
    return YES;
}

-(void)textEditingChanged:(UITextField *)textField
{
    if (textField == self.nameTextField || textField == self.pswTextField)
    {
        if ([textField.text length]>15)
        {
            textField.text=[textField.text substringToIndex:15];

        }
    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameTextField resignFirstResponder];
    [self.pswTextField resignFirstResponder];
}

#pragma mark - action

- (void)loginAction
{
    if (self.nameTextField.text.length == 0) {
        [[iToast makeText:@"用户名不能为空"] show];
        return;
    }
    if (self.pswTextField.text.length == 0) {
        [[iToast makeText:@"密码不能为空"] show];
        return;
    }
    
    [PFUser logInWithUsernameInBackground:self.nameTextField.text password:self.pswTextField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            DLog(@"登录成功");
                                        } else {
                                            // The login failed. Check error to see why.
                                            DLog(@"登录失败，%@",[[error userInfo] objectForKey:@"error"] );
                                        }
                                    }];
}

- (IBAction)pushTest:(id)sender {
    [PFPush sendPushMessageToChannelInBackground:kPushChannelDebug
                                     withMessage:@"啦啦啦，收到了吗"];
}



@end
