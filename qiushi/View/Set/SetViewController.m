//
//  SetViewController.m
//  NetDemo
//
//  Created by xyxd mac on 12-8-20.
//
//

#import "SetViewController.h"

#import "iToast.h"
#import "SqliteUtil.h"
#import "EGOCache.h"
#import "IIViewDeckController.h"
#import "FeedBackViewController.h"

@interface SetViewController ()
{
    UIBarButtonItem *leftMenuBtn;
    
    NSMutableArray *_loadItems;//加载图片items
    int _typeLoad;
}
@property (nonatomic, retain) NSMutableArray *loadItems;
@property (nonatomic, assign) int typeLoad;
@end

@implementation SetViewController

@synthesize items = _items;
@synthesize subItems = _subItems;
@synthesize mTable = _mTable;
@synthesize loadItems = _loadItems;
@synthesize typeLoad = _typeLoad;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"设置";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.hidesBackButton = YES;
    
    
    
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
    
    

    
    
    _loadItems = [[NSMutableArray alloc]initWithObjects:@"全部自动加载",@"仅Wifi自动加载",@"不自动加载", nil];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int loadType = [[ud objectForKey:@"loadImage"] intValue];
    _typeLoad = loadType;
    
    //设置背景颜色
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    
    
    _mTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, 320, 480 - 20 - 44 - 30) style:UITableViewStyleGrouped];
    _mTable.delegate = self;
    _mTable.dataSource = self;
    _mTable.backgroundColor = [UIColor clearColor];
    [self.mTable setBackgroundView:nil];
    [self.view addSubview:_mTable];
    

    _items = [[NSMutableArray alloc]initWithObjects:@"去给评个分吧",@"图片加载方式",@"清除缓存",@"意见反馈", nil];
    _subItems = [[NSMutableArray alloc]initWithObjects:@"", nil];
    
   
    
}

- (void)viewDidUnload
{
    
      self.items = nil;
    self.subItems = nil;
    self.mTable = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




#pragma mark - TableView*
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"_ContentCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    //设置cell 样式
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
   
    cell.textLabel.font = [UIFont fontWithName:kFont size:15.0];
    cell.textLabel.text = [self.items objectAtIndex:indexPath.row];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
    
    if (indexPath.row == 1) {
        cell.detailTextLabel.text = [_loadItems objectAtIndex:_typeLoad];
    }

    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

        if (indexPath.row == 0){
        
        //多次跳转，没有下面的好
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=545549453&type=Purple+Software"]];
        
        //前去评分
        NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",MyAppleID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }else if (indexPath.row == 1){
        //图片加载方式
        NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
        [actionSheet showInView:self.view];
        
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        pickerView.tag = 101;
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.showsSelectionIndicator = YES;
        
        [actionSheet addSubview:pickerView];

        
    }else if (indexPath.row == 2){
        //清除缓存
        [self cleanCache];
       
        
    }else if (indexPath.row == 3){//意见反馈
        
        FeedBackViewController *feedback = [[FeedBackViewController alloc]initWithNibName:@"FeedBackViewController" bundle:nil];
        [self.navigationController pushViewController:feedback animated:YES];
        
    }else if (indexPath.row == 4){//升级，ipa
       
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [_loadItems count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return  [_loadItems objectAtIndex:row];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	UIPickerView *pickerView = (UIPickerView *)[actionSheet viewWithTag:101];
    
    _typeLoad = [pickerView selectedRowInComponent:0];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithInt:_typeLoad]  forKey:@"loadImage"];
    
    NSLog(@"%@",[ud objectForKey:@"loadImage"]);
    
    [_mTable reloadData];
    

}


- (void)cleanCache
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:[NSString stringWithFormat:@"亲,确定要清除所有缓存吗?"]
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
            dispatch_queue_t newThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(newThread, ^{
                [SqliteUtil delNoSave];
                [SqliteUtil delAllComments];
                EGOCache *cache = [[EGOCache alloc]init];
                [cache clearCache];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[iToast makeText:@"已完成"] show];
                });
            });

        }break;
            
    }
}




@end
