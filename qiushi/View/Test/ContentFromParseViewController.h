//
//  ContentFromParseViewController.h
//  qiushi
//
//  Created by xuanyuan on 13-1-6.
//  Copyright (c) 2013年 XYXD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PullingRefreshTableView;
#import "EGOImageButton.h"


#define kTagGetNormal    1001
#define kTagGetOffline   1002
#define kTagGetOfflineOk    1003


@interface ContentFromParseViewController : UIViewController
<EGOImageButtonDelegate>
{
    NSMutableArray *_cacheArray;//保存到数据库里的缓存
    NSMutableArray *_imageUrlArray;//预先把img读取 以便减少加载时间
    NSMutableArray *_list;
    PullingRefreshTableView *_tableView;

}

@property (retain,nonatomic) PullingRefreshTableView *tableView;
@property (nonatomic,retain) NSMutableArray *cacheArray;
@property (nonatomic,retain) NSMutableArray *imageUrlArray;
@property (retain,nonatomic) NSMutableArray *list;


-(CGFloat) getTheHeight:(NSInteger)row;
@end
