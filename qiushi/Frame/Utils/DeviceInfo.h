//
//  DeviceInfo.h
//  TowerDefenseB
//
//  Created by xyxd mac on 12-12-18.
//  Copyright (c) 2012年 Beijing XYXD Technology Co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>

@interface DeviceInfo : NSObject
+(NSString*)deviceString;
+(BOOL)isRetina;

+ (NSString*)getOSVersion;


+ (BOOL)isIpad;



+ (BOOL)isIphone;


+ (BOOL)hasCamera;

@end
