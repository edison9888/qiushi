//
//  HistoryViewController.m
//  qiushi
//
//  Created by xyxd mac on 12-10-16.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import "HistoryViewController.h"

#import "CommentsViewController.h"
#import "QiuShi.h"
#import "GADBannerView.h"
#import "SqliteUtil.h"
#import "MyNavigationController.h"
#import "AppDelegate.h"
#import "iToast.h"
#import "EGOCache.h"
#import "IIViewDeckController.h"
#import "MyProgressHud.h"

@interface HistoryViewController ()<
UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate
>

@property (retain,nonatomic) UITableView *tableView;
@property (retain,nonatomic) NSMutableArray *list;

@end

@implementation HistoryViewController

@synthesize tableView = _tableView;
@synthesize list = _list;
@synthesize cacheArray = _cacheArray;
@synthesize mDate = _mDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"缓存也精彩";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.hidesBackButton = YES;
    
    
    [self setBarButtonItems];
    
    
    

    
    //设置背景颜色
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    
    
    _list = [[NSMutableArray alloc] init ];
    
    
    
    
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
    bounds.size.height = KDeviceHeight - (44);
    self.tableView = [[UITableView alloc] initWithFrame:bounds];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    
    
    
    
    [self.view addSubview:[MyProgressHud getInstance]];
    dispatch_async(dispatch_get_current_queue(), ^{
        
        _cacheArray = [SqliteUtil queryDbByDate:_mDate];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_cacheArray != nil) {
                [self.list removeAllObjects];
                for (QiuShi *qiushi in _cacheArray)
                {
                    QiuShi *qs = [[QiuShi alloc]initWithQiushi:qiushi];
                    NSLog(@"%@",qs.fbTime);
                    [self.list addObject:qs];
                    
                }
                
                //数据源去重复
                [self removeRepeatArray];

                [self.tableView reloadData];
                
            }
            
            
            if (_cacheArray.count == 0) {
                [[iToast makeText:@"亲,暂时还没有缓存..."] show];
            }

            [MyProgressHud remove];
            
        });
                
    });

    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self.viewDeckController leftControllerIsOpen]==YES) {
        [self.viewDeckController closeLeftView];
    }
//    //解决本view与root 共同的手势 冲突
//    [self.viewDeckController setPanningMode:IIViewDeckNoPanning];
    [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
}
- (void)viewDidDisappear:(BOOL)animated
{
    
    [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
    
}

#pragma mark - Your actions


- (void) setBarButtonItems
{
    UIImage *image = [UIImage imageNamed:@"nav_menu_icon.png"];
    UIImage *imagef = [UIImage imageNamed:@"nav_menu_icon_f.png"];
    CGRect backframe= CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:backframe];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:imagef forState:UIControlStateHighlighted];
    [btn addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* someBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = someBarButtonItem;
    
    
    UIImage* image1= [UIImage imageNamed:@"comm_btn_top_n.png"];
    UIImage* imagef1 = [UIImage imageNamed:@"comm_btn_top_s.png"];
    CGRect backframe1= CGRectMake(0, 0, image1.size.width, image1.size.height);
    UIButton* editButton= [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = backframe1;
    [editButton setBackgroundImage:image1 forState:UIControlStateNormal];
    [editButton setBackgroundImage:imagef1 forState:UIControlStateHighlighted];
    [editButton setTitle:@"清除" forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    editButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [editButton addTarget:self action:@selector(cleanCache:) forControlEvents:UIControlEventTouchUpInside];
    //定制自己的风格的  UIBarButtonItem
    UIBarButtonItem* addBarButton= [[UIBarButtonItem alloc] initWithCustomView:editButton];
    [self.navigationItem setRightBarButtonItem:addBarButton];
    
    
    
}

- (void)cleanCache:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:[NSString stringWithFormat:@"亲,确定要清除(%@)所有缓存吗?]",_mDate]
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            //GCD为Grand Central Dispatch的缩写。
            //dispatch_queue_t myQueue = dispatch_queue_create("com.iphonedevblog.post", NULL);
            //          其中，第一个参数是标识队列的，第二个参数是用来定义队列的参数（目前不支持，因此传入NULL）。
            //            执行一个队列如下会异步执行传入的代码：dispatch_async(myQueue, ^{ [self doSomething]; });
            //            其中，首先传入之前创建的队列，然后提供由队列运行的代码块。
            dispatch_queue_t m_queue = dispatch_get_current_queue();
            
            dispatch_async(m_queue, ^{
                [SqliteUtil delCacheByDate:_mDate];
                EGOCache *cache = [[EGOCache alloc]init];
                [cache clearCache];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[iToast makeText:@"已完成"] show];
                });
            });
            
            
            
            
        }break;
            
    }
}


#pragma mark - TableView*
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    CommentsViewController *comments=[[CommentsViewController alloc]initWithNibName:@"CommentsViewController" bundle:nil];
    comments.qs = [self.list objectAtIndex:indexPath.row];
    
    
    [[delegate navController] pushViewController:comments animated:YES];
    
}


//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        
//       
//        dispatch_async(dispatch_get_current_queue(), ^{
//            QiuShi *qs = [self.list objectAtIndex:indexPath.row];
//            [SqliteUtil deleteData:qs.qiushiID];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.list removeObjectAtIndex:indexPath.row];
//                [self.tableView reloadData];
//            });
//        });
//        
//        
//    }
//    
//}



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

- (void)removeRepeatArray
{
//    DLog(@"原来：%d",self.list.count);
    NSMutableArray* filterResults = [[NSMutableArray alloc] init];
    BOOL copy;
    if (![self.list count] == 0) {
        for (QiuShi *a1 in self.list) {
            copy = YES;
            for (QiuShi *a2 in filterResults) {
                if ([a1.qiushiID isEqualToString:a2.qiushiID] && [a1.anchor isEqualToString:a2.anchor]) {
                    copy = NO;
                    break;
                }
            }
            if (copy) {
                [filterResults addObject:a1];
            }
        }
    }
    
    self.list = filterResults;
//    DLog(@"之后：%d",self.list.count);
    //    self.list = [NSMutableArray arrayWithArray:[self.list sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
    
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



@end
