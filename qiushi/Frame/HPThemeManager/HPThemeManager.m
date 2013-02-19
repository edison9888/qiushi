//
//  HPThemeManager.m
//  HPThemeManager
//
//  Created by Evangel on 11-6-16.
//  Copyright 2011  __HP__. All rights reserved.
//

#import "HPThemeManager.h"

NSString *const kThemeDidChangeNotification = @"kThemeDidChangeNotification";


@implementation HPThemeManager
@synthesize currentThemeIndex;
@synthesize themeDictionary;
@synthesize currentTheme;

-(id)init
{
  self = [super init];
  if(self)
  {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"themes" ofType:@"plist"];
    themeDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.currentThemeIndex = 0;
    self.currentTheme = @"day"; //default theme
  }
  return self;
}

+(HPThemeManager*)sharedThemeManager
{   
  static HPThemeManager *instance = nil;
  if (!instance) 
  {
    instance = [[HPThemeManager alloc] init];
  }
  return instance;
}

//-(NSString*)getCurrentThemePathWithThemeName:(NSString*)name
//{
//  return [themeDictionary objectForKey:name];
//}


@end
