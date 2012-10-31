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
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "IsNetWorkUtil.h"
#import "MyProgressHud.h"
#import "JSON.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize nameTextField  = _nameTextField;
@synthesize pswTextField = _pswTextField;
@synthesize mTest = _mTest;
@synthesize httpRequest = _httpRequest;
@synthesize formRequest = _formRequest;

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

- (void)dealloc
{
    self.httpRequest.delegate = nil;
    
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
    //    [PFPush sendPushMessageToChannelInBackground:kPushChannelDebug
    //                                     withMessage:@"啦啦啦，收到了吗"];
    
    //
//    [self requestNetWork];
    
    
}

#pragma mark - 网络请求
- (void)requestNetWork
{
    if (![IsNetWorkUtil isNetWork1])
    {
        
        return;
    }
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.parse.com/1/classes/GameScoreTest"];
    
    self.httpRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    
    [self.httpRequest addRequestHeader:@"X-Parse-Application-Id" value:kParseApplicationId];
    [self.httpRequest addRequestHeader:@"X-Parse-REST-API-Key" value:kParseREST];
    [self.httpRequest addRequestHeader:@"Content-Type" value:@"application/json"];
    
    
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                    kParseApplicationId,@"appkey",
                                    kParseClientKey,@"mrid",
                                    kParseJavascript,@"bought_time",
                                    nil];
    
    DLog(@"%@",[tempDic description]);
    
//    NSString *body = [ NSString stringWithFormat:@"{\"appkey\":\"%@\"}",kParseApplicationId];
//    [self.formRequest appendPostData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"version"] isEqualToString:@">=5"] ) {
        [self.httpRequest appendPostData:[NSJSONSerialization dataWithJSONObject:tempDic options:NSJSONReadingMutableLeaves error:nil]];
    }else {
        [self.httpRequest appendPostData:[[tempDic JSONFragment] dataUsingEncoding: NSUTF8StringEncoding]];
    }

    [self.httpRequest setDidFailSelector:@selector(getInfoFail:)];
    [self.httpRequest setDidFinishSelector:@selector(getInfoSuccess:)];
    [self.httpRequest setDelegate:self];
    [self.httpRequest startAsynchronous];
    
    
    [self.view addSubview:[MyProgressHud getInstance]];
    
}
-(void)getInfoFail:(ASIHTTPRequest *)request{
    
    [MyProgressHud remove];
    
    
    NSError *error = [request error];
    DLog(@"-------------------------------\n");
    DLog(@"error:%@",error);
    
    NSString *temp = [NSString stringWithFormat:@"%@",error];
    NSString *jap = @"NSLocalizedDescription=The request timed out";
    NSRange foundObj=[temp rangeOfString:jap options:NSCaseInsensitiveSearch];
    if(foundObj.length>0)
    {
        
        
        [[iToast makeText:@"网络连接超时，请稍后再试"] show];
        return;
        
    }
    
    NSString *responseString = [request responseString];
    
    
    DLog(@"%@\n",responseString);
    
    
    
}

-(void)getInfoSuccess:(ASIHTTPRequest *)request{
    
    [MyProgressHud remove];
    
    // 当以文本形式读取返回内容时用这个方法
    NSString *responseString = [request responseString];
    
    
    DLog(@"%@\n",responseString);
    
    if ([request responseStatusCode]==200) {
        
        
    }
    
    
}





@end
