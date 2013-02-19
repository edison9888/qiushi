//
//  LeftCell.m
//  qiushi
//
//  Created by xyxd mac on 12-9-11.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import "LeftCell.h"
#import "HPThemeManager.h"

@implementation LeftCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)valueChanged:(id)sender
{
    UISwitch* switchControl = sender;
    DLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    
    NSString *selectName = switchControl.on ? @"night" : @"day" ;
    [[HPThemeManager sharedThemeManager] setCurrentTheme:selectName]; //must set before post
    [[HPThemeManager sharedThemeManager] setCurrentThemeIndex:switchControl.on ? 1 : 0];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"kThemeDidChangeNotification"
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObject:selectName forKey:@"selectedTheme"]];
    
}


@end
