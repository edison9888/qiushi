//
//  MyTicketLabel.h
//  TestDpA
//
//  Created by xyxd mac on 13-1-16.
//  Copyright (c) 2013年 XYXD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Ticket;
@interface MyTicketLabel : UIView
{
    NSString *_text;
    UIFont *_font;
    Ticket *_ticket;
}
@property (retain, nonatomic) NSString *text;
@property (retain, nonatomic) UIFont *font;
@property (retain, nonatomic) Ticket *ticket;

@end
