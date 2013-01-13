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
#import "IIViewDeckController.h"
#import "iToast.h"
#import "ContentViewController.h"
#import "PullingRefreshTableView.h"


#define kTagMenu        101
#define kTagRefresh     102

#define kTagYingCai     103
#define kTagNenCao      104
#define kTagDay         105
#define kTagWeek        106
#define kTagMonth       107
#define kTagImgYc       108
#define kTagImgSl       109
#define kTagCy          100

#define kTagSeg0        101
#define kTagSeg1        102
#define kTagSeg2        103




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
@synthesize index = _index;



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

    //设置背景颜色
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];


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
    UIButton* btn1= [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = backframe1;
    [btn1 setBackgroundImage:image1 forState:UIControlStateNormal];
    [btn1 setBackgroundImage:imagef1 forState:UIControlStateHighlighted];
    [btn1 setTitle:@"刷新" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.titleLabel.font=[UIFont systemFontOfSize:12];
    [btn1 setShowsTouchWhenHighlighted:YES];
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTag:kTagRefresh];
    UIBarButtonItem* someBarButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItem = someBarButtonItem1;







    //设置糗事类型
    if (!_typeQiuShi) {
        _typeQiuShi = QiuShiTypeTop;
    }




    _segmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_segmentButton setFrame:CGRectMake(0, 0, 200, 35)];
    [_segmentButton setTag:kTagMenu];
    [_segmentButton setTintColor:[UIColor whiteColor]];
    _segmentButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [_segmentButton setTitle:@"随便逛逛" forState:UIControlStateNormal];

    [_segmentButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];






    [self refreshTitle];








    [SqliteUtil initDb];




    CGRect bounds = self.view.bounds;
    bounds.size.height = KDeviceHeight - (44);


    //添加内容的TableView
    self.m_contentView = [[ContentViewController alloc]initWithNibName:@"ContentViewController" bundle:nil];
    [m_contentView.view setFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight - 44 -20)];
    [m_contentView LoadPageOfQiushiType:_typeQiuShi];
    [self.view addSubview:m_contentView.view];




    //    _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    UIImage *refreshImg = [UIImage imageNamed:@"refresh.png"];
    //    [self.refreshBtn setFrame:CGRectMake(kDeviceWidth-refreshImg.size.width-15,
    //                                         KDeviceHeight-refreshImg.size.height-44-20-15,
    //                                         refreshImg.size.width,
    //                                         refreshImg.size.height)];
    //    [self.refreshBtn setBackgroundImage:refreshImg forState:UIControlStateNormal];
    //    [self.refreshBtn setImage:[UIImage imageNamed:@"icon_bg.png"] forState:UIControlStateNormal];
    //    [self.refreshBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.refreshBtn setTag:kTagRefresh];
    //    [self.view addSubview:_refreshBtn];



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


-(void)viewDidAppear:(BOOL)animated
{
    DLog("viewDidAppear");

    [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
    [super viewDidAppear:animated];

}



#pragma mark - action


- (void)btnClick:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    switch ([btn tag])
    {

        case kTagRefresh:
        {
            [self refreshDate];
        }break;
        default:
        {
            NSAssert(nil, @"tag is error!!!");
        }break;


    }
}



#pragma mark - 刷新数据
- (void)refreshDate
{

    [self refreshTitle];

    if (_index == 0) {
        _typeQiuShi = QiuShiTypeTop;
    }else if (_index == 1){
        _typeQiuShi = QiuShiTimeDay;
    }else if (_index == 2){
        _typeQiuShi = QiuShiTypePhotoYC;
    }else if(_index == 3){
        _typeQiuShi = QiuShiTypeCy;
    }




    //刷新 数据
    [m_contentView LoadPageOfQiushiType:_typeQiuShi];
}


-(void) segmentAction: (UISegmentedControl *) sender
{
	if (sender.tag == kTagSeg0) {
        if (sender.selectedSegmentIndex == 0) {
            _typeQiuShi = QiuShiTypeTop;
        }else if (sender.selectedSegmentIndex == 1) {
            _typeQiuShi = QiuShiTypeNew;
        }
    }else if (sender.tag == kTagSeg1) {
        if (sender.selectedSegmentIndex == 0) {
            _typeQiuShi = QiuShiTimeDay;
        }else if (sender.selectedSegmentIndex == 1) {
            _typeQiuShi = QiuShiTimeWeek;
        }else if (sender.selectedSegmentIndex == 2) {
            _typeQiuShi = QiuShiTimeMonth;
        }
    }else if (sender.tag == kTagSeg2) {
        if (sender.selectedSegmentIndex == 0) {
            _typeQiuShi = QiuShiTypePhotoYC;
        }else if (sender.selectedSegmentIndex == 1) {
            _typeQiuShi = QiuShiTypePhotoSL;
        }
    }

    //刷新 数据
    [m_contentView LoadPageOfQiushiType:_typeQiuShi];


}

- (void) refreshTitle
{
    if (_index == 0) {


        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"硬菜",@"嫩草",nil];
        //初始化UISegmentedControl
        UISegmentedControl *segmentedTemp = [[UISegmentedControl alloc]initWithItems:segmentedArray];
        segmentedTemp.segmentedControlStyle = UISegmentedControlStyleBar;
        [segmentedTemp addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        segmentedTemp.tag = kTagSeg0;
        segmentedTemp.selectedSegmentIndex = 0;
        self.navigationItem.titleView = segmentedTemp;
    }else if (_index == 1){
        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"日",@"月",@"年",nil];
        //初始化UISegmentedControl
        UISegmentedControl *segmentedTemp = [[UISegmentedControl alloc]initWithItems:segmentedArray];
        segmentedTemp.segmentedControlStyle = UISegmentedControlStyleBar;
        [segmentedTemp addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        segmentedTemp.tag = kTagSeg1;
        segmentedTemp.selectedSegmentIndex = 0;
        self.navigationItem.titleView = segmentedTemp;
    }else if (_index == 2){
        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"硬菜",@"时令",nil];
        //初始化UISegmentedControl
        UISegmentedControl *segmentedTemp = [[UISegmentedControl alloc]initWithItems:segmentedArray];
        segmentedTemp.segmentedControlStyle = UISegmentedControlStyleBar;
        [segmentedTemp addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        segmentedTemp.tag = kTagSeg2;
        segmentedTemp.selectedSegmentIndex = 0;
        self.navigationItem.titleView = segmentedTemp;
        
    }else{
        self.navigationItem.titleView = nil;
    }
    
}

@end
