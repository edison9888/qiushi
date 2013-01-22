////
////  MyTicketLabel.m
////  TestDpA
////
////  Created by xyxd mac on 13-1-16.
////  Copyright (c) 2013年 XYXD. All rights reserved.
////
//
//#import "MyTicketLabel.h"
//
//
//@implementation MyTicketLabel
//
////会自动添加@synthesize <#property#>
//
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//       
//    }
//    return self;
//}
//
//
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    _font = [UIFont boldSystemFontOfSize:12];
//    self.backgroundColor = [UIColor clearColor];
//    self.text = @"大家";
//   
//    
//    int mWidth = 0;
//
//
//    
//    
//    if (![ticket.swz isEqualToString:@"--"]) {
//       
//        NSString *string = @" 商务座:";
//        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
//        
//        [string drawAtPoint:CGPointMake(mWidth, 0) withFont:self.font];
//        
//        mWidth += [string sizeWithFont:self.font].width;
//        
//        NSString *piaoshu = ticket.swz;
//        if ([self isPureInt:piaoshu]) {//是 整数
//        
//
//            
//            int i = [piaoshu intValue];
//            if (i < 10) {
//                CGColorRef _color = [UIColor redColor].CGColor;
//                CGContextSetFillColorWithColor(context, _color);
//                [piaoshu drawAtPoint:CGPointMake(mWidth, 0) withFont:self.font];
//                CGContextSetAllowsAntialiasing(context, YES);
//            }else if (i < 20) {
//                CGColorRef _color = [UIColor orangeColor].CGColor;
//                CGContextSetFillColorWithColor(context, _color);
//                [piaoshu drawAtPoint:CGPointMake(mWidth, 0) withFont:self.font];
//                CGContextSetAllowsAntialiasing(context, YES);
//            }else {
//                CGColorRef _color = [UIColor greenColor].CGColor;
//                CGContextSetFillColorWithColor(context, _color);
//                [piaoshu drawAtPoint:CGPointMake(mWidth, 0) withFont:self.font];
//                CGContextSetAllowsAntialiasing(context, YES);
//
//            }
//            
//
//        
//            mWidth += [piaoshu sizeWithFont:self.font].width;
//        }else if ([piaoshu isEqualToString:@"有"]) {
//            
//            CGColorRef _color = [UIColor greenColor].CGColor;
//            CGContextSetFillColorWithColor(context, _color);
//            [piaoshu drawAtPoint:CGPointMake(mWidth, 0) withFont:self.font];
//            CGContextSetAllowsAntialiasing(context, YES);
//            
//            mWidth += [piaoshu sizeWithFont:self.font].width;
//        }else {//无
//            
//            CGColorRef _color = [UIColor grayColor].CGColor;
//            CGContextSetFillColorWithColor(context, _color);
//            [piaoshu drawAtPoint:CGPointMake(mWidth, 0) withFont:self.font];
//            CGContextSetAllowsAntialiasing(context, YES);
//            
//            mWidth += [piaoshu sizeWithFont:self.font].width;
//        }
//    }
//    
//        
//    
//
//    
//    
//}
//
////判断是否为整形：
//
//- (BOOL)isPureInt:(NSString*)string{
//    
//    NSScanner* scan = [NSScanner scannerWithString:string];
//    
//    int val;
//    
//    return[scan scanInt:&val] && [scan isAtEnd];
//    
//}
//
//
//@end
