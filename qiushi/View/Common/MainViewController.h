//
//  MainViewController.h
//  NetDemo
//
//  Created by xyxd  on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentViewController;

@interface MainViewController : UIViewController
<UIAlertViewDelegate>
{
    ContentViewController *m_contentView;  //内容页面

    int _typeQiuShi;
    int _index;

    UIBarButtonItem* _timeItem;



    NSTimer *timer;
}

@property (nonatomic, retain) ContentViewController *m_contentView;
@property (nonatomic, assign) int typeQiuShi;
@property (nonatomic, assign) int index;


@property (nonatomic, retain) UISegmentedControl *timeSegment;
@property (nonatomic, retain) UIBarButtonItem *timeItem;

- (void)refreshDate;
@end
