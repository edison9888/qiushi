//
//  CommentsViewController.h
//  NetDemo
//
//  Created by Michael on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentCell.h"
#import "CommentsCell.h"
#import "QiuShi.h"
#import "Comments.h"
#import "GADBannerView.h"
@class PullingRefreshTableView;
@class SHSShareViewController;

#define kTagActivity 301
@interface CommentsViewController : UIViewController
<UIGestureRecognizerDelegate,GADBannerViewDelegate>
{

    GADBannerView *bannerView_;//实例变量 bannerView_是一个view
    

    
    SHSShareViewController *_shareView;
    
    NSMutableArray *_qsList;
    int _index;
    BOOL _isHidden;//是否隐藏 cell三个按钮;正常时显示;收藏/缓存 时,不显示
    
  
}
@property (nonatomic, retain) PullingRefreshTableView *commentView;//评论的TableView
@property (nonatomic, retain) UITableView *tableView;//糗事内容的TableView
@property (nonatomic, retain) NSMutableArray *list; //记录评论的数组
@property (nonatomic, retain) QiuShi *qs; //糗事的对象
@property (nonatomic, retain) SHSShareViewController *shareView;
@property (nonatomic, retain) NSMutableArray *qsList;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) BOOL isHidden;
-(CGFloat) getTheHeight;
-(CGFloat) getTheCellHeight:(int) row;
@end

