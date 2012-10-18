//
//  ProgressStatusBar.m
//  ProgressStatusBar
//
//  Created by chenfei on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProgressStatusBar.h"

@implementation ProgressStatusBar

@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = [UIApplication sharedApplication].statusBarFrame;
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.backgroundColor = [UIColor grayColor];
        
        loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
        loadingView.backgroundColor = [UIColor redColor];
        [self addSubview:loadingView];
        
        loadingLabel = [[UILabel alloc] initWithFrame:self.frame];
        loadingLabel.backgroundColor = [UIColor clearColor];
        loadingLabel.textAlignment = UITextAlignmentCenter;
        loadingLabel.textColor = [UIColor whiteColor];
        loadingLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:loadingLabel];
        
        flashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 17, 0, 3)];
        flashView.image = [UIImage imageNamed:@"info_offline_flash"];
        flashView.alpha = 0;
        [self addSubview:flashView];
        
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(300, 5, 15, 10);
        [closeButton setShowsTouchWhenHighlighted:YES];
        [closeButton setImage:[UIImage imageNamed:@"statusbar_close"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
    }
    return self;
}

- (void)dealloc
{
    [loadingLabel release];
    [loadingView release];
    [flashView release];
    [timer invalidate];
    timer = nil;
    
    [super dealloc];
}

- (void)setProgress:(CGFloat)progress
{
    if (progress < 0)
        progress = 0;
    else if (progress > 1)
        progress = 1;
    
    CGRect newFrame = loadingView.frame;
    CGFloat width = progress * 320;    
    newFrame.size.width = width;
    loadingView.frame = newFrame;
}

- (void)setLoadingMsg:(NSString *)msg
{
    loadingLabel.text = msg;
}

- (void)restoreFlashView
{
    CGRect newFrame = flashView.frame;
    newFrame.size.width = 0;
    flashView.frame = newFrame;
    flashView.alpha = 0;
}

- (void)showOfflineFlash:(NSTimer *)timer
{
    flashView.alpha = 1;
    
    const NSTimeInterval duration = 1;
    [UIView animateWithDuration:duration animations:^(void) {
        CGRect newFrame = flashView.frame;
        newFrame.size.width = 320;
        flashView.frame = newFrame;
    }];
    
    [self performSelector:@selector(restoreFlashView) withObject:nil afterDelay:duration];
}

- (void)show
{
    self.hidden = NO;
    self.alpha = 1;
    
    [timer invalidate];
    timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(showOfflineFlash:) userInfo:nil repeats:YES];
}

- (void)hide
{
    [UIView animateWithDuration:1 animations:^(void) {
        self.alpha = 0;
    }];
    
    loadingLabel.text = @"";
    
    CGRect newFrame = loadingView.frame;
    newFrame.size.width = 0;
    loadingView.frame = newFrame;
    
    [timer invalidate];
    timer = nil;
}

- (void)close:(UIButton *)button
{
    if ([delegate respondsToSelector:@selector(closeButtonClicked)])
        [delegate performSelector:@selector(closeButtonClicked)];
    
    [self performSelector:@selector(hide) withObject:nil afterDelay:1];
}

@end
