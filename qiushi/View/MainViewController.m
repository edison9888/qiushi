//
//  MainViewController.m
//  NetDemo
//
//  Created by xyxd on 12-8-10.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import "MainViewController.h"


#import "SqliteUtil.h"
#import "ContentViewController.h"
#import "DIYMenuOptions.h"
#import "IIViewDeckController.h"
#import "iToast.h"


#define kTagMenu        101
#define kTagRefresh     102


//启动一定次数，引导用户去评分
#define kQDCS @"qdcs"  //启动次数
#define kTime 10


@interface MainViewController ()
{
    UIButton *_segmentButton;//
    UIImageView *_arrowImage;
    UIButton *_refreshBtn;//刷新btn 
}
@property (retain, nonatomic) UIButton *refreshBtn;//刷新按钮
@end

@implementation MainViewController
@synthesize m_contentView;
@synthesize typeQiuShi = _typeQiuShi;
@synthesize timeSegment = _timeSegment;
@synthesize timeItem = _timeItem;
@synthesize refreshBtn = _refreshBtn;

static CGFloat progress = 0;

#pragma mark - view life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
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
    
    UIButton *lxBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [lxBtn addTarget:self action:@selector(lixian:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* lxItem = [[UIBarButtonItem alloc]initWithCustomView:lxBtn];
    self.navigationItem.rightBarButtonItem = lxItem;
    
    
    statusBar = [[ProgressStatusBar alloc] init];
    statusBar.delegate = self;
    
    
    UIFont *font = [UIFont fontWithName:MENUFONT_FAMILY size:MENUFONT_SIZE];
    [DIYMenu setDelegate:self];
    
    // Add menu items
    [DIYMenu addMenuItem:@"随便逛逛"
                withIcon:[UIImage imageNamed:@"portfolioIcon.png"]
               withColor:[UIColor colorWithRed:0.18f green:0.76f blue:0.93f alpha:1.0f]
                withFont:font];
    [DIYMenu addMenuItem:@"日精选"
                withIcon:[UIImage imageNamed:@"skillsIcon.png"]
               withColor:[UIColor colorWithRed:0.28f green:0.55f blue:0.95f alpha:1.0f]
                withFont:font];
    [DIYMenu addMenuItem:@"周精选"
                withIcon:[UIImage imageNamed:@"exploreIcon.png"]
               withColor:[UIColor colorWithRed:0.47f green:0.24f blue:0.93f alpha:1.0f]
                withFont:font];
    [DIYMenu addMenuItem:@"月精选"
                withIcon:[UIImage imageNamed:@"settingsIcon.png"]
               withColor:[UIColor colorWithRed:0.57f green:0.0f blue:0.85f alpha:1.0f]
                withFont:font];
    
    
    //初始化 摇一摇刷新
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shake" ofType:@"wav"];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    
    
    
    //设置糗事类型
    if (!_typeQiuShi) {
        _typeQiuShi = QiuShiTypeTop;
    }
    
    //时间类型
    if (!_timeType) {
        _timeType = QiuShiTimeRandom;
    }
    
    
    
    _segmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_segmentButton setFrame:CGRectMake(0, 0, 200, 35)];
    [_segmentButton setTag:kTagMenu];
    [_segmentButton setTintColor:[UIColor whiteColor]];
    _segmentButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [_segmentButton setTitle:@"随便逛逛" forState:UIControlStateNormal];
    
    [_segmentButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _arrowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_att_input_pressed.png"]];
    [_arrowImage setCenter:CGPointMake(155, 16)];
    [_segmentButton addSubview:_arrowImage];
    
    if (_typeQiuShi == QiuShiTypeTop) {
        self.navigationItem.titleView = _segmentButton;
    }else
        self.navigationItem.titleView = nil;
    
    
    
    //设置背景颜色
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    
    
    
    [SqliteUtil initDb];
    
    
    
    //每隔一段时间，提示用户去评分
    [self pingFen];
    
    DLog(@"kDeviceWidth:%f,kDeviceHeight:%f",kDeviceWidth,KDeviceHeight);
    
    CGRect bounds = self.view.bounds;
    DLog(@"bounds.size.width:%f,bounds.size.height:%f",bounds.size.width,bounds.size.height);
    bounds.size.height = KDeviceHeight - (44);
    
    
    //添加内容的TableView
    self.m_contentView = [[ContentViewController alloc]initWithNibName:@"ContentViewController" bundle:nil];
    [m_contentView.view setFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight - 44 -20)];
    DLog(@":%f",m_contentView.view.frame.size.height);
    [m_contentView LoadPageOfQiushiType:_typeQiuShi Time:_timeType];
    [self.view addSubview:m_contentView.view];
    
 
    

    _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *refreshImg = [UIImage imageNamed:@"refresh.png"];
    [self.refreshBtn setFrame:CGRectMake(kDeviceWidth-refreshImg.size.width-15,
                                         KDeviceHeight-refreshImg.size.height-44-20-15,
                                         refreshImg.size.width,
                                         refreshImg.size.height)];
    [self.refreshBtn setBackgroundImage:refreshImg forState:UIControlStateNormal];
    [self.refreshBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.refreshBtn setTag:kTagRefresh];
    [self.view addSubview:_refreshBtn];

    
    
}

- (void)viewDidUnload
{
    DLog(@"viewDidUnload");
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [timer invalidate];
    timer = nil;
}

//摇一摇 的准备
-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    DLog("viewDidAppear");
    [self becomeFirstResponder];
    [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
    [super viewDidAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    DLog("viewWillDisappear");
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    DLog("viewWillAppear");
    [super viewWillAppear:animated];
}


#pragma mark - action


- (void)btnClick:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    switch ([btn tag])
    {
        case kTagMenu:
        {
            [DIYMenu show];
        }break;
        case kTagRefresh:
        {
            [self refreshDate];
        }break;
            
            
    }
}

- (void)lixian:(id)sender
{

    
//    [TestFlight openFeedbackView];
    
//    [statusBar show];
//    
//    
//    [self startOffline];
//    
//    [m_contentView LoadDataForCache];
}





// 模拟离线
- (void)startOffline
{
    progress = 0;
    
    [timer invalidate];
    timer = nil;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
}

- (void)stopOffline
{
    [timer invalidate];
    timer = nil;
}

- (void)updateProgress:(NSTimer *)sender
{
    progress += 0.05;
    
    [statusBar setProgress:progress];
    [statusBar setLoadingMsg:[NSString stringWithFormat:@"正在离线: %.0f%%", progress * 100]];
    
    if (progress > 1) {
        progress = 0;
        [statusBar setLoadingMsg:@"离线完成"];
        
        [self stopOffline];
        
        [statusBar performSelector:@selector(hide) withObject:nil afterDelay:1];
    }
}

#pragma mark - ProgressStatusBarDelegate

- (void)closeButtonClicked
{
    // stop offline
    [self stopOffline];
    
    [statusBar setLoadingMsg:@"停止离线"];
}

#pragma mark -  引导用户去 评分
- (void) pingFen
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int sum = [[ud objectForKey:kQDCS] intValue];
    
    if (sum < kTime) {
        sum++;
        
    }else if(sum == kTime){
        sum = 0;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"糗事囧事有什么需要改进的吗？去评个分吧~~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去评分", nil];
        
        [alert show];
        
    }
    
    [ud setInteger:sum forKey:kQDCS];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //前去评分
        NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",MyAppleID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}



//摇动后
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    DLog(@"UIEventSubType : %d",motion);
    if(motion==UIEventSubtypeMotionShake)
    {
        
        AudioServicesPlaySystemSound (soundID);

        [[iToast makeText:@"亲,摇动刷新哦"] show];
        //刷新 数据
        [self refreshDate];
        
    }
    
}

#pragma mark - 刷新数据
- (void)refreshDate
{

    if (_typeQiuShi == QiuShiTypeTop) {
        self.navigationItem.titleView = _segmentButton;
    }else
        self.navigationItem.titleView = nil;
    //刷新 数据
    [m_contentView LoadPageOfQiushiType:_typeQiuShi Time:_timeType];
}


#pragma mark - DIYMenuDelegate

- (void)menuItemSelected:(NSString *)action
{
    NSLog(@"Delegate: selected: %@", action);
    if ([action isEqualToString:@"随便逛逛"]) {
        if (_timeType != QiuShiTimeRandom) {
            _timeType = QiuShiTimeRandom;
        }else{
            return;
        }
        
        
    }else if ([action isEqualToString:@"日精选"]) {
        
        if (_timeType != QiuShiTimeDay) {
             _timeType = QiuShiTimeDay;
        }else{
            return;
        }

    }else if ([action isEqualToString:@"周精选"]) {
       
        if (_timeType != QiuShiTimeWeek) {
             _timeType = QiuShiTimeWeek;
        }else{
            return;
        }

    }else if ([action isEqualToString:@"月精选"]) {
        
        if (_timeType != QiuShiTimeMonth) {
            _timeType = QiuShiTimeMonth;
        }else{
            return;
        }

    }
    
    [_segmentButton setTitle:action forState:UIControlStateNormal];
    [m_contentView LoadPageOfQiushiType:_typeQiuShi Time:_timeType];
}

- (void)menuActivated
{
    NSLog(@"Delegate: menuActivated");
}

- (void)menuCancelled
{
    NSLog(@"Delegate: menuCancelled");
}




@end
