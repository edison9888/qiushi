//
//  CommentsViewController.m
//  NetDemo
//
//  Created by Michael on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentsViewController.h"


#import "QiuShi.h"
#import "PullingRefreshTableView.h"
#import "SHSShareViewController.h"
#import "SqliteUtil.h"
#import "iToast.h"
#import "IIViewDeckController.h"
#import "SqliteUtil.h"
#import "IsNetWorkUtil.h"
#import "NetManager.h"

#define FShareBtn       101
#define FBackBtn        102
#define FAddComments    103

#define kContentWidth    280

@interface CommentsViewController ()
<PullingRefreshTableViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
RefreshDateNetDelegate
>
{
    BOOL isShowAd;//是否展示Ad
}

-(void) btnClicked:(id)sender;
- (void)loadData;
@property (nonatomic) BOOL refreshing;
@property (assign,nonatomic) NSInteger page;
@end

@implementation CommentsViewController



-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"精彩评论";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib


    //是否显示广告
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    if ([[ud objectForKey:@"isAdvanced"] boolValue] == NO) {
        bannerView_ = [[GADBannerView alloc]
                       initWithFrame:CGRectMake(0.0,
                                                KDeviceHeight - GAD_SIZE_320x50.height - 44 -20,
                                                GAD_SIZE_320x50.width,
                                                GAD_SIZE_320x50.height)];//设置位置

        bannerView_.adUnitID = MY_BANNER_UNIT_ID;//调用你的id
        bannerView_.rootViewController = self;
        bannerView_.delegate = self;
        [self.view addSubview:bannerView_];

    }

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    _list = [SqliteUtil queryCommentsById:self.qs.qiushiID];//[NSMutableArray array];

    UIImage* image= [UIImage imageNamed:@"comm_btn_top_n.png"];
    UIImage* imagef= [UIImage imageNamed:@"comm_btn_top_s.png"];
    CGRect frame_1= CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* backButton= [[UIButton alloc] initWithFrame:frame_1];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setBackgroundImage:imagef forState:UIControlStateHighlighted];
    [backButton setTitle:@"分享" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [backButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //定制自己的风格的  UIBarButtonItem
    UIBarButtonItem* someBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setRightBarButtonItem:someBarButtonItem];

    //糗事列表
    _tableView = [[UITableView alloc]  initWithFrame:CGRectMake(0, 0, kDeviceWidth, [self getTheHeight])];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    [_commentView addSubview:_tableView];


    _commentView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-44-20) pullingDelegate:self];
    _commentView.backgroundColor = [UIColor clearColor];
    _commentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _commentView.dataSource = self;
    _commentView.delegate = self;
    _commentView.scrollEnabled = YES;
    [self.view addSubview:_commentView];
    _commentView.tableHeaderView = _tableView;


    //添加footimage
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIImage *footbg= [UIImage imageNamed:@"block_center_background.png"];
    UIImageView *footbgView = [[UIImageView alloc]initWithImage:footbg];
    [footbgView setFrame:CGRectMake(0, 0, 320, 25)];
    [footView addSubview:footbgView];


    UIImage *footimage = [UIImage imageNamed:@"block_foot_background.png"];
    UIImageView *footimageView = [[UIImageView alloc]initWithImage:footimage];
    [footimageView setFrame:CGRectMake(0, 25, 320, 15)];
    [footView addSubview:footimageView];

    //    //添加评论
    //    UIButton *addcomments = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [addcomments setFrame:CGRectMake(20,2,280,28)];
    //    [addcomments setBackgroundImage:[[UIImage imageNamed:@"button_vote.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    //    [addcomments setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    //    [addcomments.titleLabel setFont: [UIFont fontWithName:kFont size:14]];
    //    [addcomments setTitle:@"点击发表评论" forState:UIControlStateNormal];
    //    [addcomments addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [addcomments setTag:FAddComments];
    //    [footView addSubview:addcomments];

    _commentView.tableFooterView = footView;
    [_commentView addSubview:footView];



    if (self.page == 0) {

        [self.commentView launchRefreshing];
    }

    [self registerGesture];
}





-(void)registerGesture{

    UISwipeGestureRecognizer *swipeRcognize1 = [[UISwipeGestureRecognizer alloc]
                                              initWithTarget:self
                                                action:@selector(handleSwipe:)];
    swipeRcognize1.delegate=self;
    [swipeRcognize1 setEnabled:YES];
    [swipeRcognize1 delaysTouchesEnded];
    [swipeRcognize1 cancelsTouchesInView];
    swipeRcognize1.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRcognize1];
}

-(void)handleSwipe:(UISwipeGestureRecognizer *)recognizer
{
    UISwipeGestureRecognizerDirection direction = recognizer.direction;
    if (direction == 1)
    {
        //右
        [self backMainContent];

    }else if (direction == 2)
    {
        //左

    }

}



-(void) btnClicked:(id)sender
{

    _shareView = [[SHSShareViewController alloc]initWithRootViewController:self];
    [_shareView.view setFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    _shareView.sharedtitle = @"糗事囧事";

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    _shareView.sharedText = [NSString stringWithFormat:@"测试数据,%@",currentDateStr];//qs.content;
    _shareView.sharedURL =@"http://www.qiushibaike.com";
    _shareView.sharedImageURL = self.qs.imageURL;
    [_shareView showShareKitView];
    //    [self.view addSubview:_shareView.view];

    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [window addSubview:_shareView.view];

}


- (void)favoriteAction:(id)sender
{

    [SqliteUtil updateDataIsFavourite:self.qs.qiushiID isFavourite:@"yes"];

    [[iToast makeText:@"已添加到收藏..."] show];
}

- (void)viewDidUnload
{

    _shareView = nil;

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ([self.viewDeckController leftControllerIsOpen]==YES) {
        [self.viewDeckController closeLeftView];
    }
    //解决本view与root 共同的手势 冲突
    [self.viewDeckController setPanningMode:IIViewDeckNoPanning];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];

}


#pragma mark - Your actions

- (void)loadData{

    if ([IsNetWorkUtil isNetWork] == NO) {
        [[iToast makeText:@"亲，网络不给力，请稍后再试呀..."] show];
        self.refreshing = NO;
        [self.commentView tableViewDidFinishedLoading];
        [self.commentView reloadData];
        return;
    }


    self.page++;
    NSString *url = CommentsURLString(self.qs.qiushiID,self.page);


    NSLog(@"%@",url);


    [[NetManager SharedNetManager] requestWithURL:url
                                         withType:kRequestTypeGetComment
                                   withDictionary:nil
                                     withDelegate:self];
}



#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section{
    if (tableview == self.tableView) {
        return 1;
    }else {
        return [self.list count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableview == self.tableView) {

        static NSString *identifier = @"_QiShiCELL";
        ContentCell *cell = (ContentCell *) [tableview dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil){
            //设置cell 样式
//            cell = [[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ContentCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];

            cell.txtContent.NumberOfLines = 0;//number;
        }

        NSString *content = self.qs.content;

        //设置内容
        cell.txtContent.text = content;
        //发布时间
        cell.txtTime.text = self.qs.fbTime;
        //设置图片
        if (self.qs.imageURL!=nil && ![self.qs.imageURL isEqual: @""]) {
            cell.imgUrl = self.qs.imageURL;
            cell.imgMidUrl = self.qs.imageMidURL;

        }else
        {
            cell.imgUrl = @"";
            cell.imgMidUrl = @"";

        }
        //设置用户名
        if (self.qs.anchor!=nil && ![self.qs.anchor isEqual: @""])
        {
            cell.txtAnchor.text = self.qs.anchor;
        }else
        {
            cell.txtAnchor.text = @"匿名";
        }
        //设置标签
        if (self.qs.tag!=nil && ![self.qs.tag isEqual: @""])
        {
            cell.txtTag.text = self.qs.tag;
        }else
        {
            cell.txtTag.text = @"";
        }

        if (self.isHidden == YES) {//隐藏
            [cell.goodbtn setHidden:YES];
            [cell.badbtn setHidden:YES];
            [cell.commentsbtn setHidden:YES];
        }else{//显示
            //设置up ，down and commits
            [cell.goodbtn setTitle:[NSString stringWithFormat:@"%d",self.qs.upCount] forState:UIControlStateNormal];
            //        [cell.goodbtn setEnabled:NO];
            [cell.badbtn setTitle:[NSString stringWithFormat:@"%d",self.qs.downCount] forState:UIControlStateNormal];
            //        [cell.badbtn setEnabled:NO];

            [cell.goodbtn addTarget:self action:@selector(goodClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.badbtn addTarget:self action:@selector(badClick:) forControlEvents:UIControlEventTouchUpInside];
        }


        [cell.saveBtn addTarget:self action:@selector(favoriteAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.commentsbtn setTitle:[NSString stringWithFormat:@"%d",self.qs.commentsCount] forState:UIControlStateNormal];


        //自适应函数
        [cell resizeTheHeight:kTypeContent];
        return cell;
    }else {
        static NSString *identifier1 = @"_CommentCell";
        CommentsCell *cell = (CommentsCell *) [tableview dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil){
            //设置cell 样式
            cell = [[CommentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.txtContent.NumberOfLines = 0;
        }
        Comments *cm = [self.list objectAtIndex:indexPath.row];
        //设置内容
        DLog(@"%@",cm.content);
        cell.txtContent.text = cm.content;

        //        int i = [cm.content intValue];
        ////        NSLog(@"%d",i);
        //
        //        if (i > 0 ) {
        //            NSRange range1 = [cm.content rangeOfString:[NSString stringWithFormat:@"%d楼",i]];
        //            NSRange range2 = [cm.content rangeOfString:[NSString stringWithFormat:@"%dl",i]];
        //            NSRange range3 = [cm.content rangeOfString:[NSString stringWithFormat:@"%dL",i]];
        //
        //
        //
        //
        //            if (range1.length > 0) {
        //                NSLog(@"Range is: %@", NSStringFromRange(range1));
        //                NSLog (@" shortname: %@", [cm.content substringWithRange:range1]);
        ////                NSLog(@"==%@",range1.location);
        ////                cell.textLabel.textColor
        //            }else if (range2.length > 0) {
        //                 NSLog(@"Range is: %@", NSStringFromRange(range2));
        //                 NSLog (@" shortname: %@", [cm.content substringWithRange:range2]);
        //            }else if (range3.length > 0) {
        //                 NSLog(@"Range is: %@", NSStringFromRange(range3));
        //                 NSLog (@" shortname: %@", [cm.content substringWithRange:range3]);
        //            }else{//只有数字
        ////                 NSLog(@"没有");
        //            }
        //        }


        cell.txtfloor.text = [NSString stringWithFormat:@"%d",cm.floor];
        //设置用户名
        if (cm.anchor!=nil && ![cm.anchor isEqual: @""])
        {
            cell.txtAnchor.text = cm.anchor;
        }else
        {
            cell.txtAnchor.text = @"匿名";
        }
        //自适应函数
        [cell resizeTheHeight];
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableview heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.tableView == tableview) {
        CGFloat height = [self getTheHeight];
        [self.tableView setFrame:CGRectMake(0, 0, kDeviceWidth, height)];
        return  height;
    }else {
        return [self getTheCellHeight:indexPath.row];
    }

}


#pragma mark - Table view delegate
-(CGFloat) getTheHeight
{
    CGFloat contentWidth = 280;
    
    contentWidth = [[self notRounding:(contentWidth / kSize) afterPoint:0] floatValue];
    contentWidth = contentWidth * kSize;
    // 设置字体
    UIFont *font = [UIFont fontWithName:kFont size:kSize];
    
    // 显示的内容
    NSString *content = self.qs.content;
    
    // 计算出长宽
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:UILineBreakModeTailTruncation];
    
    DLog(@"%f,%f",size.height,size.width);
    CGFloat height;
    if (self.qs.imageURL == nil || [self.qs.imageURL isEqualToString:@""]) {
        height = size.height + 149 - 25;
    }else
    {
        height = size.height + 100 + 149 -25;//88+6+6
    }
    
    DLog(@"%f",height);
    // 返回需要的高度
    return height;
}

-(CGFloat) getTheCellHeight:(int) row
{
    CGFloat contentWidth = 280;
    // 设置字体
    UIFont *font = [UIFont fontWithName:kFont size:14];

    Comments *cm = [self.list objectAtIndex:row];
    // 显示的内容
    NSString *content = cm.content;
    // 计算出长宽
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:UILineBreakModeTailTruncation];
    CGFloat height = size.height+30;
    // 返回需要的高度
    return height;
}


- (void) goodClick:(id)sender
{
    UIButton *btn = (UIButton*)sender;


    NSString *str = btn.currentTitle ;

    int i = [str intValue];
    i += 1;
    [btn setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];

    QiuShi *qs1 = self.qs;//[self.list objectAtIndex:self.index];
    qs1.upCount = i;
    [self.qsList replaceObjectAtIndex:self.index withObject:qs1];
}

- (void) badClick:(id)sender
{
    UIButton *btn = (UIButton*)sender;

    NSString *str = btn.currentTitle ;

    int i = [str intValue];
    i -= 1;
    [btn setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];

    QiuShi *qs1 = self.qs;
    qs1.downCount = i;
    [self.qsList replaceObjectAtIndex:self.index withObject:qs1];
}



- (void)backMainContent
{

    [self.navigationController popViewControllerAnimated:YES];
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
    [self.commentView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.commentView tableViewDidEndDragging:scrollView];
}



#pragma mark - delegate ad

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    DLog(@"收到 Ad");
    if (isShowAd == NO) {
        isShowAd = YES;
        CGRect bounds = self.view.bounds;
        bounds.size.height = KDeviceHeight - (44 + 20 + GAD_SIZE_320x50.height);
        [UIView animateWithDuration:.4 animations:^{
            [self.commentView setFrame:bounds];

        }];


    }



}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    if (isShowAd == YES) {
        isShowAd = NO;
        CGRect bounds = self.view.bounds;
        bounds.size.height = KDeviceHeight - (44 + 20);
        [UIView animateWithDuration:.4 animations:^{
            [self.commentView setFrame:bounds];
        }];
    }


    DLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);

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

    CGRect bounds = self.view.bounds;
    bounds.size.height = KDeviceHeight - (44 + 20);
    [UIView animateWithDuration:.4 animations:^{
        [self.commentView setFrame:bounds];
    } completion:^(BOOL finished) {
        [bannerView_ removeFromSuperview];
    }];

}



#pragma mark - delegate net
-(void)refreshDate1:(NSMutableDictionary*)dic data2:(NSMutableArray*)array withType:(int)type isOk:(BOOL)isOk
{
    if (type == kRequestTypeGetComment)
    {
        if (isOk == YES) {
            if (dic != nil) {

                if (self.refreshing)
                {
                    self.page = 1;
                    self.refreshing = NO;

                }

                NSArray *comments = [dic objectForKey:@"items"];
                if (comments.count > 0) {
                    NSArray *array = [NSArray arrayWithArray:[dic objectForKey:@"items"]];
                    for (NSDictionary *comments in array) {
                        Comments *cm = [[Comments alloc]initWithDictionary:comments];
                        cm.qsId = self.qs.qiushiID;
                        cm.createTime = self.qs.fbTime;
                        [self.list addObject:cm];
                    }

                    [self.commentView reloadData];

                    [self.commentView tableViewDidFinishedLoading];
                    self.commentView.reachedTheEnd  = NO;


                    

                }else {
                    if (self.page > 0)
                    {
                        self.page--;
                    }

                    [self.commentView tableViewDidFinishedLoadingWithMessage:@"亲，下面没有了哦..."];
                    self.commentView.reachedTheEnd  = YES;
                    self.refreshing = NO;
                    [self.commentView tableViewDidFinishedLoading];

                }

                if (isShowAd == NO) {
                    [bannerView_ loadRequest:[GADRequest request]];
                }


        //保存到数据库
        dispatch_queue_t newThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(newThread, ^{
            [SqliteUtil saveCommentWithArray:self.list];
        });

            }
            
        }else {
            self.refreshing = NO;
            [self.commentView tableViewDidFinishedLoading];
        }

    }
}


-(NSString *)notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    //    [ouncesDecimal release];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

@end