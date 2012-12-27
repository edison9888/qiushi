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
#import "SqliteUtil.h"
#import "MyNavigationController.h"
#import "AppDelegate.h"
#import "iToast.h"
#import "EGOCache.h"
#import "IIViewDeckController.h"
#import "MyProgressHud.h"
#import "Utils.h"


@interface HistoryViewController ()<
UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate
>
{
    NSMutableArray *_alphaArray;
    
}
@property (nonatomic, retain) NSMutableArray *alphaArray;
@property (retain,nonatomic) UITableView *tableView;
@property (retain,nonatomic) NSMutableArray *list;

@end

@implementation HistoryViewController

@synthesize tableView = _tableView;
@synthesize list = _list;
@synthesize cacheArray = _cacheArray;
@synthesize mDate = _mDate;
@synthesize alphaArray = _alphaArray;

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
    
    
    
        
    CGRect bounds = self.view.bounds;
    bounds.size.height = KDeviceHeight - (44 + 20);
    self.tableView = [[UITableView alloc] initWithFrame:bounds];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    
    
    
    
    [self.view addSubview:[MyProgressHud getInstance]];
    dispatch_queue_t newThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newThread, ^{
        
        _cacheArray = [SqliteUtil queryDbByDate:_mDate];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_cacheArray != nil) {
                [self.list removeAllObjects];
                _alphaArray = [[NSMutableArray alloc]init];
                
                //                for (QiuShi *qiushi in _cacheArray)
                for (int i = 0; i < _cacheArray.count; i++)
                {
                    QiuShi *qs = [[QiuShi alloc]initWithQiushi:[_cacheArray objectAtIndex:i]];
//                    NSLog(@"%@",qs.fbTime);
                    [self.list addObject:qs];
                    [_alphaArray addObject:[NSString stringWithFormat:@"%d",i+1]];
                    
                }
                
                //数据源去重复
                self.list = [Utils removeRepeatArray:self.list];
                
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
//    [editButton setImage:[UIImage imageNamed:@"icon_bin.png"] forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    editButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [editButton addTarget:self action:@selector(cleanCache:) forControlEvents:UIControlEventTouchUpInside];
    [editButton setShowsTouchWhenHighlighted:YES];
    //定制自己的风格的  UIBarButtonItem
    UIBarButtonItem* cleanBarButton = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
    UIButton* listBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    listBtn.frame = backframe1;
    [listBtn setBackgroundImage:image1 forState:UIControlStateNormal];
    [listBtn setBackgroundImage:imagef1 forState:UIControlStateHighlighted];
//    [listBtn setImage:[UIImage imageNamed:@"icon_list.png"] forState:UIControlStateNormal];
    [listBtn setTitle:@"列表" forState:UIControlStateNormal];
    [listBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    listBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [listBtn setShowsTouchWhenHighlighted:YES];
    [listBtn addTarget:self action:@selector(listAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* listBarButton = [[UIBarButtonItem alloc] initWithCustomView:listBtn];
    
    
   
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"version"] isEqualToString:@">=5"] ) {
        NSArray *btnArray = [NSArray arrayWithObjects:cleanBarButton,listBarButton, nil];
        [self.navigationItem setRightBarButtonItems:btnArray];
    }else {
        [self.navigationItem setRightBarButtonItem:listBarButton];
    }
    
}

- (void)cleanCache:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:[NSString stringWithFormat:@"亲,确定要清除(%@)所有缓存吗?",_mDate]
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
                [SqliteUtil delCacheCommentsByDate:_mDate];
                
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
    return _alphaArray.count;//1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;//[self.list count];
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
//    CGRect frame = cell.txtContent.frame;
//    frame.size.width = 200;
//    cell.txtContent.frame = frame;
    QiuShi *qs = [self.list objectAtIndex:[indexPath section]];
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
    if (qs.tag!=nil && ![qs.tag isEqual: @""])
    {
        cell.txtTag.text = qs.tag;
    }else
    {
        cell.txtTag.text = @"";
    }
    //设置up ，down and commits
//    [cell.goodbtn setTitle:[NSString stringWithFormat:@"%d",qs.upCount] forState:UIControlStateNormal];
//    [cell.badbtn setTitle:[NSString stringWithFormat:@"%d",qs.downCount] forState:UIControlStateNormal];
//    [cell.commentsbtn setTitle:[NSString stringWithFormat:@"%d",qs.commentsCount] forState:UIControlStateNormal];
    [cell.goodbtn setHidden:YES];
    [cell.badbtn setHidden:YES];
    [cell.commentsbtn setHidden:YES];
    
    
    //发布时间
    cell.txtTime.text = [NSString stringWithFormat:@"%d/%d",indexPath.section+1,[self.list count]];//qs.fbTime;
    
    
    [cell.saveBtn setTag:indexPath.row ];
    [cell.saveBtn addTarget:self action:@selector(favoriteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //自适应函数
    [cell resizeTheHeight:kTypeHistory];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getTheHeight:indexPath.section];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.viewDeckController leftControllerIsOpen]==YES) {
        [self.viewDeckController closeLeftView];
    }else{
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        CommentsViewController *comments=[[CommentsViewController alloc]initWithNibName:@"CommentsViewController" bundle:nil];
        comments.qs = [self.list objectAtIndex:indexPath.section];
        comments.isHidden = YES;
        [[delegate navController] pushViewController:comments animated:YES];
    }
    
    
    
}



//index

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView
{
	if (aTableView == self.tableView)  // regular table
	{
        
        return self.alphaArray;
        
		
	}
	else return nil; // search table
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}



//滑动删除
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
    CGFloat contentWidth = 250;
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
    QiuShi *qs = [self.list objectAtIndex:[btn tag]];
    DLog(@"%@",qs.qiushiID);
    [SqliteUtil updateDataIsFavourite:qs.qiushiID isFavourite:@"yes"];
    [[iToast makeText:@"已添加到收藏..."] show];
}

- (void)listAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

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
}

@end
