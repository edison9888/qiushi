//
//  FavouriteViewController.h
//  qiushi
//
//  Created by xyxd on 12-9-4.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FavouriteViewController : UIViewController
{
    
    
    NSMutableArray *_cacheArray;//保存到数据库里的缓存
    
   
}
@property (nonatomic,retain) NSMutableArray *cacheArray;
@end
