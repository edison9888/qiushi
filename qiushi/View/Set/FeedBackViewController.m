//
//  FeedBackViewController.m
//  qiushi
//
//  Created by xyxd on 12-11-3.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import "FeedBackViewController.h"
#import "iToast.h"
#import <Parse/Parse.h>
#import "MyProgressHud.h"
#import "IsNetWorkUtil.h"
@interface FeedBackViewController ()

@end

@implementation FeedBackViewController
@synthesize mTextView = _mTextView;
@synthesize mName = _mName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"意见反馈";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage* image1= [UIImage imageNamed:@"comm_btn_top_n.png"];
    UIImage* imagef1 = [UIImage imageNamed:@"comm_btn_top_s.png"];
    CGRect backframe1= CGRectMake(0, 0, image1.size.width, image1.size.height);
    UIButton* listBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    listBtn.frame = backframe1;
    [listBtn setBackgroundImage:image1 forState:UIControlStateNormal];
    [listBtn setBackgroundImage:imagef1 forState:UIControlStateHighlighted];
    [listBtn setTitle:@"提交" forState:UIControlStateNormal];
    [listBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    listBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [listBtn setShowsTouchWhenHighlighted:YES];
    [listBtn addTarget:self action:@selector(listAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* listBarButton = [[UIBarButtonItem alloc] initWithCustomView:listBtn];
    self.navigationItem.rightBarButtonItem = listBarButton;
    
    
    [self.mName addTarget:self action:@selector(textEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMTextView:nil];
    [self setMName:nil];
    [super viewDidUnload];
}


-(void)textEditingChanged:(UITextField *)textField
{
    if (textField == self.mName) {
        if ([textField.text length]>20) {
            textField.text=[textField.text substringToIndex:20];

        }
    }
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    if (range.location>=100)
    {
        return  NO;
    }
    else
    {
        return YES;
    }
}



- (void)listAction:(id)sender
{
    [self.mTextView resignFirstResponder];
    [self.mName resignFirstResponder];
    
    if ([IsNetWorkUtil isNetWork1] == NO) {
        return;
    }
    
    if ([self.mTextView.text isEqualToString:@"我们期待您的反馈并会快速处理."] || [self.mTextView.text isEqualToString:@""] || self.mTextView.text.length == 0) {
        [[iToast makeText:@"请输入反馈建议..."] show];
        return;
    }
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *strName = self.mName.text;
    if (strName.length == 0) {
        strName = @"anonymous";
    }
    PFObject *feedback = [PFObject objectWithClassName:@"FeedBack"];
    [feedback setObject:self.mName.text forKey:@"contact"];
    [feedback setObject:self.mTextView.text forKey:@"content"];
    [feedback setObject:version forKey:@"version"];
    [self.view addSubview:[MyProgressHud getInstance]];
    [feedback saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MyProgressHud remove];
        if (succeeded == YES) {
            [[iToast makeText:@"提交成功"] show];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            DLog(@"%@",[error description]);
            [[iToast makeText:@"提交失败,请稍后再试."] show];
            
        }
    }];

}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.mTextView.text isEqualToString:@"我们期待您的反馈并会快速处理."]) {
        [self.mTextView setText:@""];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [self.mTextView becomeFirstResponder];
    [self.mName resignFirstResponder];

    return YES;
}



@end
