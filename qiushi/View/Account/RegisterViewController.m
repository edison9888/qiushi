//
//  RegisterViewController.m
//  qiushi
//
//  Created by xyxd mac on 12-10-26.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>
#import "iToast.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize mName = _mName;
@synthesize mPsw = _mPsw;
@synthesize mRePsw = _mRePsw;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"注册";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //限制字符长度
    [self.mName addTarget:self action:@selector(textEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.mPsw addTarget:self action:@selector(textEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.mRePsw addTarget:self action:@selector(textEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMName:nil];
    [self setMPsw:nil];
    [self setMRePsw:nil];
    [super viewDidUnload];
}

#pragma mark - delegate textField

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _mName) {
        [_mPsw becomeFirstResponder];
    }else if (textField == _mPsw){
        [_mRePsw becomeFirstResponder];
    }else if (textField == _mRePsw){
        [self registerAction];
    }
    return YES;
}

-(void)textEditingChanged:(UITextField *)textField
{
    if (textField == self.mName || textField == self.mPsw || textField == self.mRePsw)
    {
        if ([textField.text length]>15)
        {
            textField.text=[textField.text substringToIndex:15];
            
        }
    }
    
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.mName resignFirstResponder];
    [self.mPsw resignFirstResponder];
    [self.mRePsw resignFirstResponder];
}

#pragma mark - action

- (void)registerAction
{
    if (self.mName.text.length == 0) {
        [[iToast makeText:@"用户名不能为空"] show];
        return;
    }
    if (self.mPsw.text.length == 0) {
        [[iToast makeText:@"密码不能为空"] show];
        return;
    }
    if (![self.mPsw.text isEqualToString:self.mRePsw.text]) {
        [[iToast makeText:@"两次密码不一致,请重新输入."] show];
        return;
    }
    
    PFUser *user = [PFUser user];
    user.username = self.mName.text;
    user.password = self.mPsw.text;
//    user.email = @"email@example.com";
//    
//    // other fields can be set just like with PFObject
//    [user setObject:@"415-392-0202" forKey:@"phone"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            DLog(@"注册成功");
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            // Show the errorString somewhere and let the user try again.
            DLog(@"注册失败，%@",errorString);
        }
    }];

}


@end
