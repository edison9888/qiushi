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

@interface History1ViewController ()

@end

@implementation History1ViewController
@synthesize mTableView = _mTableView;
@synthesize mDic = _mDic;

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
    
    
    [self.view addSubview:[MyProgressHud getInstance]];
    dispatch_async(dispatch_get_current_queue(), ^{
        
        _mDic = [SqliteUtil queryDbGroupByData];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (_mDic != nil) {
                
                [self.mTableView reloadData];
                              
            }

            
            if (_mDic.count == 0) {
                [[iToast makeText:@"亲,暂时还没有缓存..."] show];
            }
            
            [MyProgressHud remove];
            
        });
        
    });
    

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
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
    
}

#pragma mark - TableView*
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.mDic count];
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
    
    cell.textLabel.text = [self.mDic.allKeys objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@条",[self.mDic.allValues objectAtIndex:indexPath.row]];
    

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HistoryViewController *history = [[HistoryViewController alloc]initWithNibName:@"HistoryViewController" bundle:nil];
    history.mDate = [self.mDic.allKeys objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:history animated:YES];
    
}



@end
