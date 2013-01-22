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
#import "Flurry.h"
#import "DeviceInfo.h"
#import "IsNetWorkUtil.h"



@implementation AppDelegate

@synthesize window = _window;
@synthesize mainController = _mainController;
@synthesize navController = _navController;
@synthesize leftController = _leftController;
@synthesize lightView = _lightView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);


    NSString *string = @"dfdsfasddfdasl大发了多少12楼的说法是范德萨发斯蒂芬";
    int i = [string intValue];
    DLog(@"i====%d",i);

    NSScanner *scanner = [NSScanner scannerWithString:@"楼"];
    DLog(@"",scanner.scanLocation)

    
    [Parse setApplicationId:kParseApplicationId
                  clientKey:kParseClientKey];

    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [Flurry setAppVersion:version];
    [Flurry startSession:kFlurryAppKey];
    
    //    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    //    [testObject setObject:@"bar111" forKey:@"foo"];
    //    [testObject save];
    
    
//    [TestFlight takeOff:TestFlightTeamToken];
    
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge
     | UIRemoteNotificationTypeAlert
     | UIRemoteNotificationTypeSound];
    
    
    [IsNetWorkUtil initNetWorkStatus];
    
    [self readPlist];
    
    
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
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    
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
    DLog(@"applicationWillEnterForeground");
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    DLog(@"applicationDidBecomeActive");
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;//应用程序右上角的数字=0（消失）
    [[UIApplication sharedApplication] cancelAllLocalNotifications];//取消所有的通知
    
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *lastClickAd  = [ud objectForKey:@"lastClickAd"];
    
    if ([currentDateStr intValue] > [lastClickAd intValue]) {
        [ud setObject:[NSNumber numberWithBool:NO] forKey:@"isAdvanced"];
    }
    
  
    
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
//    [PFPush subscribeToChannelInBackground:@""];

    [PFPush subscribeToChannelInBackground:kPushChannel];

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

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *) [UIApplication sharedApplication].delegate;
}


//寫入
- (void)writePlist :(NSMutableDictionary *)dic
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //plist命名
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/excption.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *plistDict;
    
    //檢查檔案是否存在，return false則創建
    if ([fileManager fileExistsAtPath: filePath])
    {
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    }else{
        plistDict = [[NSMutableDictionary alloc] init];
    }
    
    [plistDict addEntriesFromDictionary:dic];
    
    //把剛追加之參數寫入file
    if ([plistDict writeToFile:filePath atomically: YES]) {
        
        NSLog(@"writePlist success");
    } else {
        NSLog(@"writePlist fail");
    }
    
    
}

//讀取
- (void)readPlist
{
    
    
    //取得檔案路徑
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/excption.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *plistDict;
    //檢查檔案是否存在
    if ([fileManager fileExistsAtPath: filePath])
    {
        NSLog(@"File here.");
        //存在的話把plist中的資料取出並寫入動態字典plistDict
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        
        
        BOOL isException = [[plistDict objectForKey:@"Exception"] boolValue];
        if (isException == YES) {
            DLog(@"%@",[plistDict description]);
            
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            [plistDict setObject:version forKey:@"SoftVersion"];
            [plistDict setObject:kPushChannel forKey:@"channel"];
            [plistDict setObject:[DeviceInfo deviceString] forKey:@"deviceInfo"];
            [plistDict setObject:[DeviceInfo getOSVersion] forKey:@"OSVersion"];
            
            
            PFObject *exception = [PFObject objectWithClassName:@"Exception" dictionary:plistDict];
            [exception saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [plistDict setObject:[NSNumber numberWithBool:NO] forKey:@"Exception"];
                    //把剛追加之參數寫入file
                    if ([plistDict writeToFile:filePath atomically: YES]) {
                        
                        NSLog(@"writePlist success");
                    } else {
                        NSLog(@"writePlist fail");
                    }
                }
            }];
            
            
            
            
        }
        
    }else{
        NSLog(@"File not here.");
        //        plistDict = [[NSMutableDictionary alloc] init];
    }
    
    
    
    
}





// Via http://stackoverflow.com/questions/7841610/xcode-4-2-debug-doesnt-symbolicate-stack-call

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    
    NSMutableDictionary *temDic = [[NSMutableDictionary alloc]init];
    
    [temDic setObject:[NSNumber numberWithBool:YES] forKey:@"Exception"];
    [temDic setObject:[NSString stringWithFormat:@"CRASH: %@",exception] forKey:@"Exception1"];
    [temDic setObject:[NSString stringWithFormat:@"Stack Trace: %@", [exception callStackSymbols]] forKey:@"Exception2"];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //plist命名
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/excption.plist"];
    
    DLog(@"%@",filePath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *plistDict;
    
    //檢查檔案是否存在，return false則創建
    if ([fileManager fileExistsAtPath: filePath])
    {
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    }else{
        plistDict = [[NSMutableDictionary alloc] init];
    }
    
    [plistDict addEntriesFromDictionary:temDic];
    
    //把剛追加之參數寫入file
    if ([plistDict writeToFile:filePath atomically: YES]) {
        
        NSLog(@"writePlist success");
    } else {
        NSLog(@"writePlist fail");
    }
    // Internal error reporting
}

@end
