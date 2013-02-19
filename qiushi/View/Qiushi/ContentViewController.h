//
//  ContentViewController.h
//  NetDemo
//
//  Created by xyxd  on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentCell.h"
#import "GADBannerView.h"
#import "BaseController.h"
@class EGOImageButton;
@class PullingRefreshTableView;


#define kTagGetNormal    1001
#define kTagGetOffline   1002
#define kTagGetOfflineOk    1003

@interface ContentViewController : BaseController
<EGOImageButtonDelegate,GADBannerViewDelegate>
{
   
    //糗事的类型:最新，最糗，真相
    QiuShiType Qiutype;


    GADBannerView *bannerView_;
    
    NSMutableArray *_cacheArray;//保存到数据库里的缓存
    NSMutableArray *_imageUrlArray;//预先把img读取 以便减少加载时间
    
    NSMutableArray *_list;
    PullingRefreshTableView *_tableView;
    
   
    
}
@property (retain,nonatomic) PullingRefreshTableView *tableView;
@property (nonatomic,assign) QiuShiType Qiutype;
@property (nonatomic,retain) NSMutableArray *cacheArray;
@property (nonatomic,retain) NSMutableArray *imageUrlArray;
@property (retain,nonatomic) NSMutableArray *list;


-(void) LoadPageOfQiushiType:(QiuShiType) type;
-(CGFloat) getTheHeight:(NSInteger)row;

@end
