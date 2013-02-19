//
//  ContentCell.m
//  NetDemo
//
//  Created by Michael on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentsCell.h"
#import "Utils.h"

@interface CommentsCell()
@end;

@implementation CommentsCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

              
    }
    return self;
}



-(void) resizeTheHeight
{
    CGFloat contentWidth = 280;
    contentWidth = [[Utils notRounding:(contentWidth / kSize) afterPoint:0] floatValue];
    contentWidth = contentWidth * kSize;

    UIFont *font = [UIFont fontWithName:kFont size:kSize];
    
    CGSize size = [_txtContent.text sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 2200) lineBreakMode:UILineBreakModeTailTruncation];
    
    CGRect frame = _txtContent.frame;
    CGRect frame1 = _txtContent.frame;
    frame.size.height = size.height;
    [_txtContent setFrame:frame];
    
    
    frame = self.imageBg.frame;
    frame.size.height = frame.size.height + size.height - frame1.size.height;
    self.imageBg.frame = frame;
    
    frame = self.imageFg.frame;
    frame.origin.y = frame.origin.y + size.height - frame1.size.height;
    self.imageFg.frame = frame;
}





@end
