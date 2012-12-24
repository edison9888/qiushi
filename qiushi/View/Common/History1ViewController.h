//
//  History1ViewController.h
//  qiushi
//  
//  Created by xyxd mac on 12-10-29.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//
/** 
 根据日期 显示缓存
 */

#import <UIKit/UIKit.h>

@interface History1ViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate
>
{
    NSMutableArray *_mArray;
}
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) NSMutableArray *mArray;

@end
