//
//  LeftController.m
//
//
//  Created by Devin Doty on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LeftController.h"
#import "MainViewController.h"

#import "AppDelegate.h"
#import "AboutViewController.h"
#import "SetViewController.h"
#import "PurchaseInViewController.h"
#import "MyNavigationController.h"
#import "FavouriteViewController.h"
#import "HistoryViewController.h"
#import "IIViewDeckController.h"

@interface LeftController ()
{
    UISlider *_mSlider;//伪 调节屏幕亮度
    int _mainType;
}
@property (nonatomic, assign) int mainType;
@end
@implementation LeftController

@synthesize tableView=_tableView;
@synthesize items = _items;
@synthesize navController = _navController;
@synthesize mainViewController = _mainViewController;
@synthesize mainType = _mainType;

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    _items = [[NSMutableArray alloc]initWithObjects:@"随便逛逛",@"新鲜出炉",@"有图有真相",@"个人收藏",@"缓存也精彩",@"",@"设置",@"关于", nil];
    
    
    
    [self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    
    
    
    
    //调节亮度的 滑动条
    _mSlider = [[UISlider alloc]initWithFrame:CGRectMake(15.0, 12 , 220, 20)];
    [_mSlider setMaximumValue:1.0];
    [_mSlider setMinimumValue:.3];
    [_mSlider setValue:1.0];
    [_mSlider setMaximumValueImage:[UIImage imageNamed:@"set_asc.png"]];
    [_mSlider setMinimumValueImage:[UIImage imageNamed:@"set_desc.png"]];
    [_mSlider addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventValueChanged];
    
    
    _mainType = 1001;
    
    
    
    
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480 -20) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = (id<UITableViewDelegate>)self;
        tableView.dataSource = (id<UITableViewDataSource>)self;
        tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        [self.view addSubview:tableView];
        self.tableView = tableView;
    }
    
    NSIndexPath *index0 = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:index0 animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
    //仿Path菜单
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"story-button.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"story-button-pressed.png"];
    
    // Camera MenuItem.
    QuadCurveMenuItem *cameraMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                highlightedImage:storyMenuItemImagePressed
                                                                    ContentImage:[UIImage imageNamed:@"story-camera.png"]
                                                         highlightedContentImage:nil];
    // People MenuItem.
    QuadCurveMenuItem *peopleMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                highlightedImage:storyMenuItemImagePressed
                                                                    ContentImage:[UIImage imageNamed:@"story-people.png"]
                                                         highlightedContentImage:nil];
    // Place MenuItem.
    QuadCurveMenuItem *placeMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"story-place.png"]
                                                        highlightedContentImage:nil];
    // Music MenuItem.
    QuadCurveMenuItem *musicMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"story-music.png"]
                                                        highlightedContentImage:nil];
    // Thought MenuItem.
    QuadCurveMenuItem *thoughtMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                 highlightedImage:storyMenuItemImagePressed
                                                                     ContentImage:[UIImage imageNamed:@"story-thought.png"]
                                                          highlightedContentImage:nil];
    // Sleep MenuItem.
    QuadCurveMenuItem *sleepMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"story-sleep.png"]
                                                        highlightedContentImage:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:cameraMenuItem, peopleMenuItem,placeMenuItem,
                      musicMenuItem, thoughtMenuItem, sleepMenuItem,
                      nil];
    
    QuadCurveMenu *menu = [[QuadCurveMenu alloc] initWithFrame:self.view.bounds menus:menus];
    menu.delegate = self;
//    [self.view addSubview:menu];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    _items = nil;
}


#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 4;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.items.count;
    }else{
        return 0;
    }
    
    
    
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if(cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //    }
    
    
    
    cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"微软雅黑" size:15.0];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    
    if (indexPath.row == 5) {
        [cell.contentView addSubview:_mSlider];
    }
    
    
    
    return cell;
    
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        return [NSString stringWithFormat:@"糗事囧事 v%@",version];
    }else if(section == 1)
    {
        return @"内容及版权归糗事百科所有";
    }else if(section == 2){
        return @"个人仅作学习之用";
    }else{
        return @"邮箱：xyxdasnjss@163.com";
    }
    
    
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
    //        if ([controller.centerController isKindOfClass:[UINavigationController class]]) {
    //            UITableViewController* cc = (UITableViewController*)((UINavigationController*)controller.centerController).topViewController;
    //            cc.navigationItem.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    //            if ([cc respondsToSelector:@selector(tableView)]) {
    //                [cc.tableView deselectRowAtIndexPath:[cc.tableView indexPathForSelectedRow] animated:NO];
    //            }
    //        }
    //
    //    }];

    
    if (_mainType == (1001 + indexPath.row)) {
      
        
    }else if (indexPath.row == 0){
        
        [self.navController popToRootViewControllerAnimated:YES];
        self.mainViewController.title = @"";
        
        self.mainViewController.typeQiuShi = 1001 + indexPath.row ; //
        [self.mainViewController refreshDate];
       
    }else if (indexPath.row == 1 || indexPath.row == 2){
        [self.navController popToRootViewControllerAnimated:YES];
        self.mainViewController.title = [NSString stringWithFormat:@"%@", [self.items objectAtIndex:indexPath.row]];
        
        self.mainViewController.typeQiuShi = 1001 + indexPath.row ; //
        [self.mainViewController refreshDate];
      
    }else if (indexPath.row == 3){
        FavouriteViewController *favourite = [[FavouriteViewController alloc]initWithNibName:@"FavouriteViewController" bundle:nil];
        
        [self.navController pushViewController:favourite animated:YES];
        
        
    }else if (indexPath.row == 4){
        HistoryViewController *history = [[HistoryViewController alloc]initWithNibName:@"HistoryViewController" bundle:nil];
        
        [self.navController pushViewController:history animated:YES];
        
        
    }else if (indexPath.row == 6){
        SetViewController *set = [[SetViewController alloc]initWithNibName:@"SetViewController" bundle:nil];
        
        [self.navController pushViewController:set animated:YES];
        
    }else if (indexPath.row == 7){
        AboutViewController *about = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
        [self.navController pushViewController:about animated:YES];
        
        
    }
    
    [self.viewDeckController closeLeftViewAnimated:YES];
    _mainType = 1001 + indexPath.row;
    
    
}

- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %d",idx);
    if (idx == 0)
    {
        //程序内购买
        PurchaseInViewController *purchase = [[PurchaseInViewController alloc]initWithNibName:@"PurchaseInViewController" bundle:nil];
        [self.navController pushViewController:purchase animated:YES];
        
        
    }
    [self.viewDeckController closeLeftViewAnimated:YES];
}





- (void)changeAction:(id)sender {
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.window bringSubviewToFront:delegate.lightView];
    UISlider *mSlider = (UISlider*)sender;
    
    
    [delegate.lightView setAlpha:(1 - [mSlider value])];
    
    
    
}



#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif

@end
