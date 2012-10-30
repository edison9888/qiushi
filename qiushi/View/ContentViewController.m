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
#import "PhotoViewer.h"
#import "iToast.h"
#import "IsNetWorkUtil.h"
#import "JSON.h"
#import "Utils.h"
#import "IIViewDeckController.h"


@interface ContentViewController () <
PullingRefreshTableViewDelegate,
ASIHTTPRequestDelegate,
UITableViewDataSource,
UITableViewDelegate
>
{
    
    EGOImageButton *tem;//读取图片缓存的
    int _iLixian;//离线用到的
    NSMutableArray *_lxArray;
    NSMutableArray *_lxImgArray;
    
}
-(void) GetErr:(ASIHTTPRequest *)request;
-(void) GetResult:(ASIHTTPRequest *)request;
@property (retain,nonatomic) PullingRefreshTableView *tableView;
@property (retain,nonatomic) NSMutableArray *list;
@property (nonatomic) BOOL refreshing;
@property (assign,nonatomic) NSInteger page;
@property (nonatomic, assign) int iLixian;
@property (retain, nonatomic) NSMutableArray *lxArray;
@property (retain, nonatomic) NSMutableArray *lxImgArray;
@end

@implementation ContentViewController
@synthesize tableView = _tableView;
@synthesize list = _list;
@synthesize refreshing = _refreshing;
@synthesize page = _page;
@synthesize asiRequest = _asiRequest;
@synthesize Qiutype,QiuTime;
@synthesize cacheArray = _cacheArray;
@synthesize imageUrlArray = _imageUrlArray;
@synthesize iLixian = _iLixian;
@synthesize lxArray = _lxArray;
@synthesize lxImgArray = _lxImgArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor clearColor]];
    _list = [[NSMutableArray alloc] init ];
    _imageUrlArray = [[NSMutableArray alloc]init];
    
    
    
    //ad
    bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
                                            KDeviceHeight - GAD_SIZE_320x50.height,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height)];//设置位置
    
    bannerView_.adUnitID = MY_BANNER_UNIT_ID;//调用你的id
    bannerView_.rootViewController = self;
#ifdef DEBUG
#else
    [bannerView_ loadRequest:[GADRequest request]];
#endif
    
    
    
    CGRect bounds = self.view.bounds;
    bounds.size.height = KDeviceHeight - (44 + 20);
    self.tableView = [[PullingRefreshTableView alloc] initWithFrame:bounds pullingDelegate:self];
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
    
    if (self.page == 0) {
        
        [self.tableView launchRefreshing];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    //    NSLog(@"dealloc content");
    self.asiRequest.delegate = nil;
}

#pragma mark - Your actions

- (void)loadData{
    
    if ([IsNetWorkUtil isNetWork] == NO) {
        [[iToast makeText:@"亲，网络不给力，请稍后再试呀..."] show];
        self.refreshing = NO;
        [self.tableView tableViewDidFinishedLoading];
        [self.tableView reloadData];
        return;
    }
    
    //刷新一下AD
#ifdef DEBUG
#else
    [bannerView_ loadRequest:[GADRequest request]];
#endif
    
    self.page++;
    NSURL *url;
    
    
    
    if (Qiutype == QiuShiTypeTop) {
        switch (QiuTime) {
            case QiuShiTimeRandom:
                url = [NSURL URLWithString:SuggestURLString(10,self.page)];
                break;
            case QiuShiTimeDay:
                url = [NSURL URLWithString:DayURLString(10,self.page)];
                break;
            case QiuShiTimeWeek:
                url = [NSURL URLWithString:WeakURlString(10,self.page)];
                break;
            case QiuShiTimeMonth:
                url = [NSURL URLWithString:MonthURLString(10,self.page)];
                break;
            default:
                url = [NSURL URLWithString:SuggestURLString(10,self.page)];
                break;
        }
    }else{
        switch (Qiutype) {
            case QiuShiTypeTop:
                url = [NSURL URLWithString:SuggestURLString(10,self.page)];
                break;
            case QiuShiTypeNew:
                url = [NSURL URLWithString:LastestURLString(10,self.page)];
                break;
            case QiuShiTypePhoto:
                url = [NSURL URLWithString:ImageURLString(10,self.page)];
                break;
            default:
                url = [NSURL URLWithString:SuggestURLString(10,self.page)];
                break;
        }
    }
    
    
    
    
    NSLog(@"%@",url);
    
    
    _asiRequest = [ASIHTTPRequest requestWithURL:url];
    [_asiRequest setDelegate:self];
    [_asiRequest setDidFinishSelector:@selector(GetResult:)];
    [_asiRequest setDidFailSelector:@selector(GetErr:)];
    [_asiRequest setTag:kTagGetNormal];
    [_asiRequest startAsynchronous];
    
    
}

-(void) GetErr:(ASIHTTPRequest *)request
{
    
    
    self.refreshing = NO;
    [self.tableView tableViewDidFinishedLoading];
    
    
#ifdef DEBUG
    NSString *responseString = [request responseString];
    NSLog(@"%@\n",responseString);
    NSError *error = [request error];
    NSLog(@"-------------------------------\n");
    NSLog(@"error:%@",error);
#endif
    
    
    [[iToast makeText:@"网络连接失败"] show];
    
    
    
}

-(void) GetResult:(ASIHTTPRequest *)request
{
    
    if (self.refreshing && [request tag] == kTagGetNormal) {
        self.page = 1;
        self.refreshing = NO;
        
        [self.list removeAllObjects];
        [self.imageUrlArray removeAllObjects];
        
        [SqliteUtil initDb];
    }
    
    NSString *responseString = [request responseString];
    //    NSLog(@"%@\n",responseString);
    
    NSMutableDictionary *dictionary;
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"version"] isEqualToString:@">=5"] ) {
        dictionary = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUnicodeStringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    }else {
        dictionary = [responseString JSONValue];
    }
    
    
    if ([dictionary objectForKey:@"items"])
    {
		NSArray *array = [NSArray arrayWithArray:[dictionary objectForKey:@"items"]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yy年MM月dd日"];//[dateFormatter setDateFormat:@"yy-MM-dd HH:mm"];
        
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
            
                if ([request tag] == kTagGetNormal) {
                    
                    [self.list addObject:qs];
                    
                    if (qs.imageURL != nil && qs.imageURL != @"") {
                        [self.imageUrlArray addObject:qs.imageURL];
                        [self.imageUrlArray addObject:qs.imageMidURL];
                    }
                }else if ([request tag] == kTagGetOffline){
                    [self.lxArray addObject:qs];
                    if (qs.imageURL != nil && qs.imageURL != @"") {
                        [self.lxImgArray addObject:qs.imageURL];
                        [self.lxImgArray addObject:qs.imageMidURL];
                        
                        
                    }
                }
            
            
        }
        
        
    }
    
    if ([request tag] == kTagGetNormal) {
        //数据源去重复
        self.list = [Utils removeRepeatArray:self.list];
        //保存到数据库
        dispatch_async(dispatch_get_current_queue(), ^{
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
        
        
    }else if ([request tag] == kTagGetOfflineOk){
        //保存到数据库
        
        DLog(@"%d",_lxArray.count);
        dispatch_queue_t newThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(newThread, ^{
            [SqliteUtil saveDbWithArray:_lxArray];
            //预先加载 图片
            [self getImageCache:kTagGetOfflineOk];
            
        });
        
        
        
    }
    
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
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
    }
    
    QiuShi *qs = [self.list objectAtIndex:[indexPath row]];
    //设置内容
    cell.txtContent.text = qs.content;
    
    
    [cell.txtContent setNumberOfLines: 12];
    
    //设置图片
    if (qs.imageURL!=nil && qs.imageURL!= @"") {
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
    if (qs.anchor!=nil && qs.anchor!= @"")
    {
        cell.txtAnchor.text = qs.anchor;
    }else
    {
        cell.txtAnchor.text = @"匿名";
    }
    //设置标签
    if (qs.tag!=nil && qs.tag!= @"")
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
    
    [cell.saveBtn setTag:(indexPath.row +100) ];
    [cell.saveBtn addTarget:self action:@selector(favoriteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //自适应函数
    [cell resizeTheHeight:kTypeMain];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getTheHeight:indexPath.row];
}

//自定义 头内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    //是否显示广告
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if ([[ud objectForKey:@"showAD"] boolValue] == YES) {
        return bannerView_;
    }else{
        return nil;
    }
   	
}

//自定义 头高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //是否显示广告
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if ([[ud objectForKey:@"showAD"] boolValue] == YES) {
        return GAD_SIZE_320x50.height;;
    }else{
        return .0f;
    }
    
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

-(void) LoadDataForCache
{
    
    _lxArray = [[NSMutableArray alloc]init];
    _lxImgArray = [[NSMutableArray alloc]init];
    NSURL *url;
    NSMutableArray *urlArray = [[NSMutableArray alloc]init];
    for (int i = 1; i<2; i++) {
        
        [urlArray addObject:[NSURL URLWithString:SuggestURLString(10,i)]];
        [urlArray addObject:[NSURL URLWithString:WeakURlString(10,i)]];
        [urlArray addObject:[NSURL URLWithString:MonthURLString(10,i)]];
        [urlArray addObject:[NSURL URLWithString:LastestURLString(10,i)]];
        [urlArray addObject:[NSURL URLWithString:ImageURLString(10,i)]];
    }
    
    
    for (int j=0; j<urlArray.count; j++) {
        url = [urlArray objectAtIndex:j];
        
        NSLog(@"%d,%d,%@",j,urlArray.count,url);
        
        
        _asiRequest = [ASIHTTPRequest requestWithURL:url];
        [_asiRequest setDelegate:self];
        if (j == (urlArray.count - 1)) {
            [_asiRequest setTag:kTagGetOfflineOk];
        }else{
            [_asiRequest setTag:kTagGetOffline];
        }
        [_asiRequest setDidFinishSelector:@selector(GetResult:)];
        [_asiRequest setDidFailSelector:@selector(GetErr:)];
        [_asiRequest startAsynchronous];
    }
    
    
}

//cell 动态 高度
-(CGFloat) getTheHeight:(NSInteger)row
{
    CGFloat contentWidth = 280;
    // 设置字体
    UIFont *font = [UIFont fontWithName:@"微软雅黑" size:14];
    
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
    int index = ([btn tag] - 100) ;
    QiuShi *qs = [self.list objectAtIndex:index];
    
    DLog(@"%@",qs.qiushiID);
    [SqliteUtil updateDataIsFavourite:qs.qiushiID isFavourite:@"yes"];
    
    [[iToast makeText:@"已添加到收藏..."] show];
}


- (void)getImageCache:(int)type
{
    
    NSLog(@"图片数：%d",type==kTagGetNormal?self.imageUrlArray.count:self.lxImgArray.count);
    
    
    tem = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"main_background.png"] delegate:self];
    for (NSString* strUrl in (type==kTagGetNormal?self.imageUrlArray:self.lxImgArray))
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




@end