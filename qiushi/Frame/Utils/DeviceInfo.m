//
//  DeviceInfo.m
//  TowerDefenseB
//
//  Created by xyxd mac on 12-12-18.
//  Copyright (c) 2012年 Beijing XYXD Technology Co., LTD. All rights reserved.
//

#import "DeviceInfo.h"

@implementation DeviceInfo


+(NSString*)deviceString

{
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    
    return deviceString;
    
}

+(BOOL)isRetina

{
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return NO;
    
    if ([deviceString isEqualToString:@"iPhone1,2"])    return NO;
    
    if ([deviceString isEqualToString:@"iPhone2,1"])    return NO;
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return YES;
    
    if ([deviceString isEqualToString:@"iPhone3,2"])    return YES;
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return NO;
    
    if ([deviceString isEqualToString:@"iPod2,1"])      return NO;
    
    if ([deviceString isEqualToString:@"iPod3,1"])      return NO;
    
    if ([deviceString isEqualToString:@"iPod4,1"])      return YES;
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return YES;
    
    if ([deviceString isEqualToString:@"iPad2,1"])      return YES;
    
    if ([deviceString isEqualToString:@"iPad2,2"])      return YES;
    
    if ([deviceString isEqualToString:@"iPad2,3"])      return YES;
    
    if ([deviceString isEqualToString:@"i386"])         return NO;
    
    if ([deviceString isEqualToString:@"x86_64"])       return NO;
    
    return NO;
    //    return deviceString;
    
}


+ (NSString*)getOSVersion
{
    return [[UIDevice currentDevice]systemVersion];
}


+ (BOOL)isIpad
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}



+ (BOOL)isIphone
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
    
}


+ (BOOL)hasCamera
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}


@end
