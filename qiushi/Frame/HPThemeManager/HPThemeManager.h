//
//  HPThemeManager.h
//  HPThemeManager
//
//  Created by Evangel on 11-6-16.
//  Copyright 2011  __HP__. All rights reserved.
//


@interface HPThemeManager : NSObject 
{
  NSDictionary *themeDictionary;
  
  NSInteger currentThemeIndex;
  NSString *currentTheme;
}
@property (assign) NSInteger currentThemeIndex;
@property(nonatomic,retain) NSDictionary *themeDictionary;
@property(nonatomic,copy) NSString *currentTheme;

+(HPThemeManager*)sharedThemeManager;
//-(NSString*)getCurrentThemePathWithThemeName:(NSString*)name;
@end
