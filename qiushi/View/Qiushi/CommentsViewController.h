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


@interface CommentsViewController : UIViewController
<UIGestureRecognizerDelegate,GADBannerViewDelegate>
{
    //糗事内容的TableView
    UITableView *tableView;
    //评论的TableView
    PullingRefreshTableView *_commentView;
    
    //糗事的对象
    QiuShi *qs;
    //记录评论的数组
    NSMutableArray *list;
    GADBannerView *bannerView_;//实例变量 bannerView_是一个view
    
    
//    UIBarButtonItem *_shareItem;//分享item
    
   
    
    SHSShareViewController *_shareView;
    
    NSMutableArray *_qsList;
    int _index;
    BOOL _isHidden;//是否隐藏 cell三个按钮;正常时显示;收藏/缓存 时,不显示
    
  
}
@property (nonatomic,retain) PullingRefreshTableView *commentView;
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *list;
@property (nonatomic,retain) QiuShi *qs;
@property (nonatomic,retain) SHSShareViewController *shareView;
@property (retain,nonatomic) NSMutableArray *qsList;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) BOOL isHidden;
-(CGFloat) getTheHeight;
-(CGFloat) getTheCellHeight:(int) row;
@end

