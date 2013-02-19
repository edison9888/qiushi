//
//  ContentCell.h
//  NetDemo
//
//  Created by Michael on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface CommentsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *txtAnchor;
@property (weak, nonatomic) IBOutlet UILabel *txtContent;
@property (weak, nonatomic) IBOutlet UILabel *txtfloor;
@property (weak, nonatomic) IBOutlet UIImageView *imageBg;
@property (weak, nonatomic) IBOutlet UIImageView *imageFg;

-(void) resizeTheHeight;
@end
