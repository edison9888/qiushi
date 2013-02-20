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
#import "MyNavigationController.h"
#import "FavouriteViewController.h"
#import "History1ViewController.h"
#import "IIViewDeckController.h"
#import "LoginViewController.h"
#import "MyTableController.h"
#import "ContentFromParseViewController.h"
#import "LeftCell.h"


@interface LeftController ()
{
    UISlider *_mSlider;//伪 调节屏幕亮度
    UISwitch *_mSwitch;
}
@property (nonatomic, assign) int mainType;
@property (nonatomic, retain) UISwitch *mSwitch;
@end
@implementation LeftController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _items = [[NSMutableArray alloc]initWithObjects:
              @"随便逛逛",
              @"精华",
              @"有图有真相",
              @"穿越",
              @"个人收藏",
              @"缓存也精彩",
              @"夜间模式",
              @"设置",
              @"关于",
              nil];
    
    
    
    [self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];

    
   
    _mSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(190, 8, 79, 27)];
    [_mSwitch setOn:NO animated:NO];
    
    //调节亮度的 滑动条
    _mSlider = [[UISlider alloc]initWithFrame:CGRectMake(15.0, 12 , 220, 20)];
    [_mSlider setMaximumValue:1.0];
    [_mSlider setMinimumValue:.3];
    [_mSlider setValue:1.0];
    [_mSlider setMaximumValueImage:[UIImage imageNamed:@"set_asc.png"]];
    [_mSlider setMinimumValueImage:[UIImage imageNamed:@"set_desc.png"]];
    [_mSlider addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventValueChanged];
    
    

    
    
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480 -20) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = (id<UITableViewDelegate>)self;
        tableView.dataSource = (id<UITableViewDataSource>)self;
//        tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        tableView.backgroundView = nil;
        tableView.backgroundColor = [UIColor clearColor];
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
#ifdef DEBUG
    [self.view addSubview:menu];
#endif
    
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

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    LeftCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LeftCell" owner:self options:nil] lastObject];
    }

     

    if (indexPath.row == 6) {
        [cell.mSwitch setHidden:NO];
        cell.selectedBackgroundView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else {
        [cell.mSwitch setHidden:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }


    cell.mTitle.text = [self.items objectAtIndex:indexPath.row];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    
    
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
    if (indexPath.row == 6) {
        return;
    }
    
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller)
    {

        if (indexPath.row == 0
            || indexPath.row == 1
            || indexPath.row == 2
            || indexPath.row == 3) {
            [self.navController popToRootViewControllerAnimated:NO];
            
            self.mainViewController.title = indexPath.row == 3 ? @"穿越中..." :@"";

            self.mainViewController.index = indexPath.row;
            [self.mainViewController refreshDate];
        }else if (indexPath.row == 4){
            FavouriteViewController *favourite = [[FavouriteViewController alloc]initWithNibName:@"FavouriteViewController" bundle:nil];

            [self.navController pushViewController:favourite animated:NO];


        }else if (indexPath.row == 5){
            History1ViewController *history = [[History1ViewController alloc]initWithNibName:@"History1ViewController" bundle:nil];

            [self.navController pushViewController:history animated:NO];


        }else if (indexPath.row == 7){
            SetViewController *set = [[SetViewController alloc]initWithNibName:@"SetViewController" bundle:nil];

            [self.navController pushViewController:set animated:NO];

        }else if (indexPath.row == 8){
            AboutViewController *about = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
            [self.navController pushViewController:about animated:NO];
            
            
        }

    }];

    
//    if (_mainType == (1001 + indexPath.row)) {
//      
//        
//    }else if (indexPath.row == 0){
//        
//        
//       
//    }else if (indexPath.row == 1 || indexPath.row == 2){
//        [self.navController popToRootViewControllerAnimated:NO];
//        self.mainViewController.title = @"";
//
//        self.mainViewController.index = indexPath.row;
//        [self.mainViewController refreshDate];
//      
//    }else if (indexPath.row == 8){
//        
//    }
//    
//    [self.viewDeckController closeLeftViewAnimated:YES];
//    _mainType = 1001 + indexPath.row;

    
}

- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %d",idx);
    if (idx == 0)
    {
        
        
        
    }else if (idx == 1)
    {
        LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [self.navController pushViewController:login animated:NO];
    }
    else if (idx == 2)
    {
        MyTableController *my = [[MyTableController alloc]init];
        [self.navController pushViewController:my animated:YES];
    }
    else if (idx == 3)
    {
        ContentFromParseViewController *parse = [[ContentFromParseViewController alloc]initWithNibName:@"ContentFromParseViewController" bundle:nil];
        [self.navController pushViewController:parse animated:YES];
    }
    
    
    [self.viewDeckController closeLeftViewAnimated:YES];
}





- (void)changeAction:(id)sender
{
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.window bringSubviewToFront:delegate.lightView];
    UISlider *mSlider = (UISlider*)sender;
    
    
    [delegate.lightView setAlpha:(1 - [mSlider value])];
    
    
    
}

@end
