//
//  History1ViewController.m
//  qiushi
//
//  Created by xyxd mac on 12-10-29.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import "History1ViewController.h"
#import "MyProgressHud.h"
#import "SqliteUtil.h"
#import "iToast.h"
#import "HistoryViewController.h"
#import "IIViewDeckController.h"
#import "SqliteUtil.h"
@interface History1ViewController ()


@end

@implementation History1ViewController
@synthesize mTableView = _mTableView;
@synthesize mArray = _mArray;

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
    
    

    [self setBarButtonItems];
        

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)viewDidUnload {
    [self setMTableView:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
    
    //获取缓存
    [self.view addSubview:[MyProgressHud getInstance]];
    dispatch_queue_t newThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); 
    dispatch_async(newThread, ^{
        
        _mArray = [SqliteUtil queryDbGroupByData];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_mArray.count == 0) {
                [[iToast makeText:@"亲,暂时还没有缓存..."] show];
            }
            
            [MyProgressHud remove];
            
            [self.mTableView reloadData];
            
        });
        
    });

}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
    
}


- (void) setBarButtonItems
{
	if (_mTableView.isEditing)
        //		self.navigationItem.rightBarButtonItem = SYSBARBUTTON(@"完成",UIBarButtonItemStyleDone, @selector(leaveEditMode));
    {
        UIImage* image1= [UIImage imageNamed:@"comm_btn_top_n.png"];
        UIImage* imagef1 = [UIImage imageNamed:@"comm_btn_top_s.png"];
        CGRect backframe1= CGRectMake(0, 0, image1.size.width, image1.size.height);
        UIButton* editButton= [UIButton buttonWithType:UIButtonTypeCustom];
        editButton.frame = backframe1;
        [editButton setBackgroundImage:image1 forState:UIControlStateNormal];
        [editButton setBackgroundImage:imagef1 forState:UIControlStateHighlighted];
        [editButton setTitle:@"完成" forState:UIControlStateNormal];
        [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        editButton.titleLabel.font=[UIFont systemFontOfSize:12];
        [editButton addTarget:self action:@selector(leaveEditMode) forControlEvents:UIControlEventTouchUpInside];
        //定制自己的风格的  UIBarButtonItem
        UIBarButtonItem* addBarButton= [[UIBarButtonItem alloc] initWithCustomView:editButton];
        [self.navigationItem setRightBarButtonItem:addBarButton];
    }
	else
        //        self.navigationItem.rightBarButtonItem = SYSBARBUTTON(@"编辑",UIBarButtonItemStylePlain, @selector(enterEditMode));
    {
        UIImage* image1= [UIImage imageNamed:@"comm_btn_top_n.png"];
        UIImage* imagef1 = [UIImage imageNamed:@"comm_btn_top_s.png"];
        CGRect backframe1= CGRectMake(0, 0, image1.size.width, image1.size.height);
        UIButton* editButton= [UIButton buttonWithType:UIButtonTypeCustom];
        editButton.frame = backframe1;
        [editButton setBackgroundImage:image1 forState:UIControlStateNormal];
        [editButton setBackgroundImage:imagef1 forState:UIControlStateHighlighted];
        [editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        editButton.titleLabel.font=[UIFont systemFontOfSize:12];
        [editButton addTarget:self action:@selector(enterEditMode) forControlEvents:UIControlEventTouchUpInside];
        //定制自己的风格的  UIBarButtonItem
        UIBarButtonItem* addBarButton= [[UIBarButtonItem alloc] initWithCustomView:editButton];
        [self.navigationItem setRightBarButtonItem:addBarButton];
    }
    
    
}

-(void)enterEditMode
{
	[_mTableView deselectRowAtIndexPath:[_mTableView indexPathForSelectedRow] animated:YES];
	[_mTableView setEditing:YES animated:YES];
    [self setBarButtonItems];
    
}
-(void)leaveEditMode
{
	[_mTableView setEditing:NO animated:YES];
	[self setBarButtonItems];
}


#pragma mark - TableView*
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.mArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Contentidentifier = @"_ContentCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Contentidentifier];
    if (!cell){
        //设置cell 样式
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Contentidentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
    }
    
    NSMutableDictionary *temDic = [self.mArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[temDic.allKeys objectAtIndex:0]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@条",[temDic.allValues objectAtIndex:0]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    

    return cell;
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.view addSubview:[MyProgressHud getInstance]];
        dispatch_queue_t newThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(newThread, ^{
            
            NSMutableDictionary *temDic = [self.mArray objectAtIndex:indexPath.row];
            [SqliteUtil delCacheByDate:[temDic.allKeys objectAtIndex:0]];
            [SqliteUtil delCacheCommentsByDate:[temDic.allKeys objectAtIndex:0]];
            [self.mArray removeObjectAtIndex:indexPath.row];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MyProgressHud remove];
                [self.mTableView reloadData];
            });
        });
        
        
    }
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.viewDeckController leftControllerIsOpen]==YES) {
        [self.viewDeckController closeLeftView];
    }else{
        HistoryViewController *history = [[HistoryViewController alloc]initWithNibName:@"HistoryViewController" bundle:nil];
        NSMutableDictionary *temDic = [self.mArray objectAtIndex:indexPath.row];
        history.mDate = [NSString stringWithFormat:@"%@",[temDic.allKeys objectAtIndex:0]];
        [self.navigationController pushViewController:history animated:YES];
    }

   
    
}



@end
