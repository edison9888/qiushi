//
//  Utils.h
//  qiushi
//
//  Created by xyxd mac on 12-10-30.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

//去重复
+ (NSMutableArray *)removeRepeatArray:(NSMutableArray*)array;
//重排序
+ (NSMutableArray *)randArray:(NSMutableArray *)ary;


+ (NSString *)notRounding:(float)price afterPoint:(int)position;
+ (int)getRandomNumber:(int)from to:(int)to;
@end
