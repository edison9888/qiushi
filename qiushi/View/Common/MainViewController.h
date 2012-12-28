//
//  MainViewController.h
//  NetDemo
//
//  Created by xyxd  on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIYMenu.h"
#import "ProgressStatusBar.h"
@class ContentViewController;

@interface MainViewController : UIViewController<UIAlertViewDelegate,DIYMenuDelegate,ProgressStatusBarDelegate>
{
    ContentViewController *m_contentView;  //内容页面

    int _typeQiuShi;
    int _timeType;
    
    UIBarButtonItem* _timeItem;
    
    
    ProgressStatusBar *statusBar;
    NSTimer *timer;
}

@property (nonatomic,retain) ContentViewController *m_contentView;
@property (nonatomic,assign) int typeQiuShi;


@property (nonatomic, retain) UISegmentedControl *timeSegment;
@property (nonatomic, retain) UIBarButtonItem *timeItem;

- (void)refreshDate;
@end
