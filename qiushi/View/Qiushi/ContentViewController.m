//
//  ContentViewController.m
//  NetDemo
//
//  Created by xyxd on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContentViewController.h"

#import "PullingRefreshTableView.h"
#import "CommentsViewController.h"
#import "QiuShi.h"
#import "SqliteUtil.h"
#import "MyNavigationController.h"
#import "AppDelegate.h"
#import "iToast.h"
#import "IsNetWorkUtil.h"
#import "Utils.h"
#import "IIViewDeckController.h"
#import "NetManager.h"
#import "Reachability.h"

@interface ContentViewController ()
<
PullingRefreshTableViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
RefreshDateNetDelegate
>
{
    
    EGOImageButton *tem;//读取图片缓存的
    
    BOOL isShowAd;//是否展示Ad
    
}

@property (nonatomic) BOOL refreshing;
@property (assign,nonatomic) NSInteger page;

@end

@implementation ContentViewController
@synthesize tableView = _tableView;
@synthesize list = _list;
@synthesize refreshing = _refreshing;
@synthesize page = _page;
@synthesize Qiutype;
@synthesize QiuTime;
@synthesize cacheArray = _cacheArray;
@synthesize imageUrlArray = _imageUrlArray;
@synthesize net = _net;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    _list = [[NSMutableArray alloc] init ];
    _imageUrlArray = [[NSMutableArray alloc]init];
    
    
    
    //ad
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if ([[ud objectForKey:@"isAdvanced"] boolValue] == NO) {
        bannerView_ = [[GADBannerView alloc]
                       initWithFrame:CGRectMake(0.0,
                                                0.0,
                                                GAD_SIZE_320x50.width,
                                                GAD_SIZE_320x50.height)];//设置位置
        
        DLog(@"%@",NSStringFromCGRect(bannerView_.frame));
        
        bannerView_.adUnitID = MY_BANNER_UNIT_ID;//调用你的id
        bannerView_.rootViewController = self;
        bannerView_.delegate = self;
        [self.view addSubview:bannerView_];
        
    }
    
    
    isShowAd = NO;
    
    
    
    CGRect bounds = self.view.bounds;
    bounds.size.height = KDeviceHeight - (44 + 20);
    _tableView = [[PullingRefreshTableView alloc] initWithFrame:bounds pullingDelegate:self];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    DLog(@"==:%f",_tableView.frame.size.height);
    [self.view addSubview:self.tableView];
    
    
    
    //读取缓存100条(实际上99条)
    _cacheArray = [SqliteUtil queryDbTop];
    if (_cacheArray != nil) {
        [self.list removeAllObjects];
        for (QiuShi *qiushi in _cacheArray)
        {
            QiuShi *qs = [[QiuShi alloc]initWithQiushi:qiushi];
            
            [self.list addObject:qs];
            
        }
        
        //数据源去重复
        self.list = [Utils removeRepeatArray:self.list];
        
        //打乱顺序
        self.list = [Utils randArray:self.list];
        //        DLog(@"读取缓存%d条",self.list.count);
        
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd  = NO;
        [self.tableView reloadData];
        
    }
    
    _net = [[NetManager alloc]init];
    _net.delegate = self;
    
    
    
    if (self.page == 0) {
        
        [self.tableView launchRefreshing];
    }
}

- (void)viewDidUnload
{
    DLog(@"~viewDidUnload ContentViewController");
    bannerView_.delegate = nil;
    self.net = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


#pragma mark - Your actions

- (void)loadData{
    
    if ([IsNetWorkUtil isNetWork] == NO) {
        [[iToast makeText:@"亲,网络不给力,请稍后再试呀..."] show];
        self.refreshing = NO;
        [self.tableView tableViewDidFinishedLoading];
        [self.tableView reloadData];
        return;
    }
    
    
    self.page++;
    NSString *url;
    
    if (Qiutype == QiuShiTypeTop) {
        switch (QiuTime) {
            case QiuShiTimeRandom:
                url = SuggestURLString(10,self.page);
                break;
            case QiuShiTimeDay:
                url = DayURLString(10,self.page);
                break;
            case QiuShiTimeWeek:
                url = WeakURlString(10,self.page);
                break;
            case QiuShiTimeMonth:
                url = MonthURLString(10,self.page);
                break;
            default:
                url = SuggestURLString(10,self.page);
                break;
        }
    }else{
        switch (Qiutype) {
            case QiuShiTypeTop:
                url = SuggestURLString(10,self.page);
                break;
            case QiuShiTypeNew:
                url = LastestURLString(10,self.page);
                break;
            case QiuShiTypePhoto:
                url = ImageURLString(10,self.page);
                break;
            default:
                url = SuggestURLString(10,self.page);
                break;
        }
    }
    
    
    
    
    NSLog(@"%@",url);
    
    
    
    [_net requestWithURL:url withType:kRequestTypeGetQiushi withDictionary:nil];
    
    
}






#pragma mark - TableView data source
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *Contentidentifier = @"_ContentCELL";
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:Contentidentifier];
    if (cell == nil){
        //设置cell 样式
        cell = [[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Contentidentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.opaque = YES;
        
    }
    
    QiuShi *qs = [self.list objectAtIndex:[indexPath row]];
    //设置内容
    cell.txtContent.text = qs.content;
    
    
    [cell.txtContent setNumberOfLines: 12];
    
    //设置图片
    if (qs.imageURL!=nil && ![qs.imageURL isEqual: @""]) {
        cell.imgUrl = qs.imageURL;
        cell.imgMidUrl = qs.imageMidURL;
        // cell.imgPhoto.hidden = NO;
    }else
    {
        cell.imgUrl = @"";
        cell.imgMidUrl = @"";
        // cell.imgPhoto.hidden = YES;
    }
    //设置用户名
    if (qs.anchor!=nil && ![qs.anchor isEqual: @""])
    {
        cell.txtAnchor.text = qs.anchor;
    }else
    {
        cell.txtAnchor.text = @"匿名";
    }
    //设置标签
    if (qs.tag==nil || [qs.tag isEqualToString:@""] || qs.tag.length == 0)
    {
        
        cell.txtTag.text = qs.tag;
        
    }else
    {
        cell.txtTag.text = @"";
        
    }
    //设置up ，down and commits
    [cell.goodbtn setTitle:[NSString stringWithFormat:@"%d",qs.upCount] forState:UIControlStateNormal];
    [cell.badbtn setTitle:[NSString stringWithFormat:@"%d",qs.downCount] forState:UIControlStateNormal];
    [cell.commentsbtn setTitle:[NSString stringWithFormat:@"%d",qs.commentsCount] forState:UIControlStateNormal];
    
    //发布时间
    cell.txtTime.text = [NSString stringWithFormat:@"%d/%d",indexPath.row+1,[self.list count]];//qs.fbTime;
    
    [cell.saveBtn setTag:indexPath.row ];
    [cell.saveBtn addTarget:self action:@selector(favoriteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [cell.commentsbtn setTag:indexPath.row];
    
    [cell.commentsbtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.goodbtn setTag:indexPath.row];
    [cell.goodbtn addTarget:self action:@selector(goodClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.badbtn setTag:indexPath.row];
    [cell.badbtn addTarget:self action:@selector(badClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //自适应函数
    [cell resizeTheHeight:kTypeMain];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getTheHeight:indexPath.row];
}



#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}


- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

#pragma mark - Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.viewDeckController leftControllerIsOpen]==YES) {
        [self.viewDeckController closeLeftView];
    }else{
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        CommentsViewController *comments=[[CommentsViewController alloc]initWithNibName:@"CommentsViewController" bundle:nil];
        comments.qs = [self.list objectAtIndex:indexPath.row];
        comments.qsList = self.list;
        comments.index = indexPath.row;
        [[delegate navController] pushViewController:comments animated:YES];
    }
    
    
}

#pragma mark - LoadPage
-(void) LoadPageOfQiushiType:(QiuShiType) type Time:(QiuShiTime) time
{
    self.Qiutype = type;
    self.QiuTime = time;
    self.page =0;
    [self.tableView launchRefreshing];
    
}


//cell 动态 高度
-(CGFloat) getTheHeight:(NSInteger)row
{
    CGFloat contentWidth = 280;
    // 设置字体
    UIFont *font = [UIFont fontWithName:kFont size:14];
    
    QiuShi *qs =[self.list objectAtIndex:row];
    // 显示的内容
    NSString *content = qs.content;
    
    // 计算出长宽
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:UILineBreakModeTailTruncation];
    CGFloat height;
    if (qs.imageURL==nil || [qs.imageURL isEqualToString:@""]) {
        height = size.height+140;
    }else
    {
        height = size.height+220;
    }
    // 返回需要的高度
    return height;
}



- (void)favoriteAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    int index = [btn tag] ;
    QiuShi *qs = [self.list objectAtIndex:index];
    
    DLog(@"%@",qs.qiushiID);
    [SqliteUtil updateDataIsFavourite:qs.qiushiID isFavourite:@"yes"];
    
    [[iToast makeText:@"已添加到收藏..."] show];
}


- (void)commentAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    int index = [btn tag] ;
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    CommentsViewController *comments=[[CommentsViewController alloc]initWithNibName:@"CommentsViewController" bundle:nil];
    comments.qs = [self.list objectAtIndex:index];
    comments.qsList = self.list;
    comments.index = index;
    [[delegate navController] pushViewController:comments animated:YES];
    
    
}

- (void) goodClick:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    int tag = [btn tag] ;
    
    NSString *str = btn.currentTitle ;
    
    int i = [str intValue];
    i += 1;
    [btn setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
    
    QiuShi *qs = [self.list objectAtIndex:tag];
    qs.upCount = i;
    [self.list replaceObjectAtIndex:tag withObject:qs];
}

- (void) badClick:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    int tag = [btn tag] ;
    
    NSString *str = btn.currentTitle ;
    
    int i = [str intValue];
    i -= 1;
    [btn setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
    
    QiuShi *qs = [self.list objectAtIndex:tag];
    qs.downCount = i;
    [self.list replaceObjectAtIndex:tag withObject:qs];
}



- (void)getImageCache:(int)type
{
    
    NSLog(@"图片数：%d",self.imageUrlArray.count);
    
    
    tem = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"main_background.png"] delegate:self];
    for (NSString* strUrl in self.imageUrlArray)
    {
        
        [tem setImageURL:[NSURL URLWithString:strUrl]];
        
        
    }
    
    NSLog(@"获取缓存完成");
    
}


- (void)imageButtonLoadedImage:(EGOImageButton*)imageButton
{
    
    NSLog(@"预下载图片成功");
}

- (void)imageButtonFailedToLoadImage:(EGOImageButton*)imageButton error:(NSError*)error;
{
    [imageButton cancelImageLoad];
    NSLog(@"预下载图片失败");
}


#pragma mark - delegate ad

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    DLog(@"收到 Ad");
    if (isShowAd == NO) {
        isShowAd = YES;
        [bannerView_ setHidden:NO];
        CGRect bounds = self.view.bounds;
        bounds.size.height = KDeviceHeight - (44 + 20 + GAD_SIZE_320x50.height);
        bounds.origin.y = bounds.origin.y + GAD_SIZE_320x50.height;
        [UIView animateWithDuration:.4 animations:^{
            [self.tableView setFrame:bounds];
            
        }];
        
        
    }
    
    
    
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    if (isShowAd == YES) {
        isShowAd = NO;
        [bannerView_ setHidden:YES];
        CGRect bounds = self.view.bounds;
        bounds.size.height = KDeviceHeight - (44 + 20);
        [UIView animateWithDuration:.4 animations:^{
            [self.tableView setFrame:bounds];
        }];
    }
    
    
    DLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
    
}

// Sent just before the application will background or terminate because the
// user clicked on an ad that will launch another application (such as the App
// Store).  The normal UIApplicationDelegate methods, like
// applicationDidEnterBackground:, will be called immediately before this.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView
{
    DLog(@"adViewWillLeaveApplication");
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithBool:YES] forKey:@"isAdvanced"];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    [ud setObject:currentDateStr forKey:@"lastClickAd"];
    
    
    CGRect bounds = self.view.bounds;
    bounds.size.height = KDeviceHeight - (44 + 20);
    [UIView animateWithDuration:.4 animations:^{
        [self.tableView setFrame:bounds];
        isShowAd = YES;
        [bannerView_ removeFromSuperview];
        
    }];
}





#pragma mark - delegate net
-(void)refreshDate1:(NSMutableDictionary*)dic data2:(NSMutableArray*)array withType:(int)type
{
    if (type == kRequestTypeGetQiushi)
    {
        
        if (dic != nil) {
            if (self.refreshing)
            {
                self.page = 1;
                self.refreshing = NO;
                
                [self.list removeAllObjects];
                [self.imageUrlArray removeAllObjects];
                
                [SqliteUtil initDb];
            }
            
            
            
            if ([dic objectForKey:@"items"])
            {
                NSArray *array = [NSArray arrayWithArray:[dic objectForKey:@"items"]];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //设定时间格式,这里可以设置成自己需要的格式
                [dateFormatter setDateFormat:@"yy年MM月dd日"];
                
                for (NSDictionary *qiushi in array)
                {
                    
                    
                    QiuShi *qs = [[QiuShi alloc]initWithDictionary:qiushi];
                    
                    //            qs.fbTime = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:qs.published_at]];
                    qs.fbTime =  [dateFormatter stringFromDate:[NSDate date]];
                    
                    //            //ttttttttttt
                    //            qs.content = @"test...";
                    //            qs.imageURL = @"http://img.qiushibaike.com/system/pictures/6317243/small/app6317243.jpg";
                    //            qs.imageMidURL = @"http://img.qiushibaike.com/system/pictures/6317243/medium/app6317243.jpg";
                    //            qs.fbTime = @"12-10-28";
                    //            //tttttttttttt
                    
                    
                    
                    [self.list addObject:qs];
                    
                    if (qs.imageURL != nil && ![qs.imageURL isEqual: @""]) {
                        [self.imageUrlArray addObject:qs.imageURL];
                        [self.imageUrlArray addObject:qs.imageMidURL];
                    }
                    
                    
                }
                
                
            }
            
            
            //数据源去重复
            self.list = [Utils removeRepeatArray:self.list];
            //保存到数据库
            dispatch_queue_t newThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); 
            dispatch_async(newThread, ^{
                [SqliteUtil saveDbWithArray:self.list];
            });
            
            
            //预先加载 图片
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            int loadType = [[ud objectForKey:@"loadImage"] intValue];
            if (loadType == 0) {//全部加载
                [self getImageCache:kTagGetNormal];
            }else if (loadType == 1){//仅wifi加载
                if ([IsNetWorkUtil netWorkType] == kTypeWifi) {
                    [self getImageCache:kTagGetNormal];
                }
            }else if (loadType == 2){//不加载
                
            }
            
            if (self.page >= 20) {
                [self.tableView tableViewDidFinishedLoadingWithMessage:@"亲，下面没有了哦..."];
                self.tableView.reachedTheEnd  = YES;
            } else {
                [self.tableView tableViewDidFinishedLoading];
                self.tableView.reachedTheEnd  = NO;
                [self.tableView reloadData];
            }
            
            if (isShowAd == NO) {
                //请求 ad
                [bannerView_ loadRequest:[GADRequest request]];
            }
        
            
        }else{
            
            if (self.page > 0) {
                self.page--;
            }
            
            
            self.refreshing = NO;
            [self.tableView tableViewDidFinishedLoading];
            
        }
        
        
        
        
        
        
    }
}



@end