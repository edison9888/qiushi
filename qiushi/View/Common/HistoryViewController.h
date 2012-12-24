//
//  HistoryViewController.h
//  qiushi
//
//  Created by xyxd mac on 12-10-16.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@interface HistoryViewController : UIViewController
{
    
    
    NSMutableArray *_cacheArray;//保存到数据库里的缓存
    NSString *_mDate;//

}

@property (nonatomic,retain) NSMutableArray *cacheArray;
@property (nonatomic,retain)  NSString *mDate;

@end
