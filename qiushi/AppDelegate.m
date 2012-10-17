//
//  AppDelegate.m
//  qiushi
//
//  Created by xyxd mac on 12-8-22.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"


#import "LeftController.h"
#import "CustomNavigationBar.h"
#import "MyNavigationController.h"

#import <Parse/Parse.h>
#import "IIViewDeckController.h"



@implementation AppDelegate

@synthesize window = _window;
@synthesize mainController = _mainController;
@synthesize navController = _navController;
@synthesize leftController = _leftController;
@synthesize lightView = _lightView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{


    [Parse setApplicationId:@"vXGdzFpCmfMoSWuUX27sLCGKhOfFAB9NHll59IUp"
                  clientKey:@"Axa79C9vZRUZBzI90IXbnCUxtPZDMsr64fLjVcLw"];
    
    
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    [testObject setObject:@"bar111" forKey:@"foo"];
//    [testObject save];
    
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    //    //暂停2s
    ////    [NSThread sleepForTimeInterval:1.0];
    
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
//    } else {
//        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
//    }
//    self.window.rootViewController = self.viewController;
//    [self.window makeKeyAndVisible];
//    return YES;
    
    
    //想摇就写在这～～～
    application.applicationSupportsShakeToEdit=YES;
    
    //默认显示广告
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithBool:YES]  forKey:@"showAD"];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    CGRect _winSize = [[UIScreen mainScreen] bounds];
    _lightView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, _winSize.size.width, _winSize.size.height)];
    [_lightView setUserInteractionEnabled:NO];
    [_lightView setBackgroundColor:[UIColor blackColor]];
    [_lightView setAlpha:.0];
    [self.window addSubview:_lightView];
    
    
    _mainController = [[MainViewController alloc] init];
    
    _navController = [[MyNavigationController alloc] initWithRootViewController:_mainController];
    

    
    
    _leftController = [[LeftController alloc] init];
    _leftController.navController = _navController;
    _leftController.mainViewController = _mainController;
    


    
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    
    
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:_navController
                                                                                    leftViewController:self.leftController
                                                                                   rightViewController:nil];
    deckController.rightLedge = 100;
    
    self.window.rootViewController = deckController;
    
    
    
    
    
    //状态栏 样式 黑色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    
    [self.navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_background.png"]];
    
    //判断设备的版本
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
    if ([self.navController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        //ios5 新特性
        [self.navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_background.png"] forBarMetrics:UIBarMetricsDefault];
        [[NSUserDefaults standardUserDefaults] setObject:@">=5" forKey:@"version"];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:@"<5" forKey:@"version"];
    }
#endif
    
    
    [self.window makeKeyAndVisible];
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;//应用程序右上角的数字=0（消失）
    [[UIApplication sharedApplication] cancelAllLocalNotifications];//取消所有的通知
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Tell Parse about the device token.
    [PFPush storeDeviceToken:deviceToken];
    // Subscribe to the global broadcast channel.
    [PFPush subscribeToChannelInBackground:@""];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if ([error code] == 3010) {
        NSLog(@"Push notifications don't work in the simulator!");
    } else {
        NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}



@end
