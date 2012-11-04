//
//  History1ViewController.h
//  qiushi
//  根据日期 显示缓存
//  Created by xyxd mac on 12-10-29.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface History1ViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate
>
{
    NSMutableDictionary *_mDic;
}
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) NSMutableDictionary *mDic;

@end
