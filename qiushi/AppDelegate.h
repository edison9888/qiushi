//
//  AppDelegate.h
//  qiushi
//
//  Created by xyxd mac on 12-8-22.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;
@class LeftController;
@class MyNavigationController;

//@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
    MainViewController *_mainController;
    MyNavigationController *_navController;
    LeftController *_leftController;
    
    UIView *_lightView;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainViewController *mainController;
@property (strong, nonatomic) MyNavigationController *navController;
@property (strong, nonatomic) LeftController *leftController;
@property (strong, nonatomic) UIView *lightView;
+ (AppDelegate *)sharedAppDelegate;

@end
