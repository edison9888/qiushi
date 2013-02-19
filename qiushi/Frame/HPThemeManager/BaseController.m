//
//  BaseController.m
//  HPThemeManager
//
//  Created by Evangel on 11-6-16.
//  Copyright 2011  __HP__. All rights reserved.
//

#import "BaseController.h"

@implementation BaseController

-(void)updateTheme:(NSNotification*)notif
{
  NSLog(@"implementation in sub class");
}

#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

- (void)loadView
{
  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(updateTheme:) 
                                               name:kThemeDidChangeNotification 
                                             object:nil];
  [super loadView];
}

- (void)viewDidUnload
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
 
  [super viewDidUnload];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];

}



@end