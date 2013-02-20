//
//  Utils.m
//  qiushi
//
//  Created by xyxd mac on 12-10-30.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import "Utils.h"
#import "QiuShi.h"

@implementation Utils


//去掉 重复数据
+ (NSMutableArray *)removeRepeatArray:(NSMutableArray*)array
{
    DLog(@"原来：%d",array.count);
    NSMutableArray* filterResults = [[NSMutableArray alloc] init];
    BOOL copy;
    if (![array count] == 0) {
        for (QiuShi *a1 in array) {
            copy = YES;
            for (QiuShi *a2 in filterResults) {
                if ([a1.qiushiID isEqualToString:a2.qiushiID] && [a1.anchor isEqualToString:a2.anchor]) {
                    copy = NO;
                    break;
                }
            }
            if (copy) {
                [filterResults addObject:a1];
            }
        }
    }
    
    DLog(@"之后：%d",filterResults.count);
    return filterResults;

    
}

#pragma mark –
#pragma mark NSMutableArray 重排序
+ (NSMutableArray *)randArray:(NSMutableArray *)ary
{
    NSMutableArray *tmpAry = [NSMutableArray arrayWithArray:ary];
    NSUInteger count = [ary count];
    for (NSUInteger i = 0; i < count; ++i) {
        int nElements = count - i;
        srandom(time(NULL));
        int n = (random() % nElements) + i;
        [tmpAry exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    return tmpAry;
}


#pragma mark 舍掉小数点后几位
+ (NSString *)notRounding:(float)price afterPoint:(int)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    //    [ouncesDecimal release];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}


+ (int)getRandomNumber:(int)from to:(int)to
{
    int i = to - from +1;
    i = arc4random() % i;
    i = from + i;
    return i;
}

@end
