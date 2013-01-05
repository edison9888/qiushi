//
//  MyTableController.m
//  qiushi
//
//  Created by xyxd on 12-12-24.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import "MyTableController.h"
#import "ContentCell.h"

@implementation MyTableController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.className = @"QIUSHI";
        
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
//- (PFQuery *)queryForTable {
//    PFQuery *query = [PFQuery queryWithClassName:self.className];
//
//    // If no objects are loaded in memory, we look to the cache first to fill the table
//    // and then subsequently do a query against the network.
//    if ([self.objects count] == 0) {
//        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//    }
//
//    [query orderByAscending:@"priority"];
//
//    return query;
//}



// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    
    
    
    static NSString *Contentidentifier = @"_ContentCELL";
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:Contentidentifier];
    if (cell == nil){
        //设置cell 样式
        cell = [[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Contentidentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.opaque = YES;
        
    }
    
    
    
    //设置内容
    cell.txtContent.text = [NSString stringWithFormat:@"%@", [object objectForKey:@"content"]];
    
    
    [cell.txtContent setNumberOfLines: 12];
    
    //设置图片
    NSString *imageUrl = [NSString stringWithFormat:@"%@", [object objectForKey:@"imageurl"]];
    if (imageUrl!=nil && ![imageUrl isEqual: @""] && ![imageUrl isEqual: @"(null)"]) {
        cell.imgUrl = imageUrl;
        cell.imgMidUrl = [NSString stringWithFormat:@"%@", [object objectForKey:@"imagemidurl"]];
        // cell.imgPhoto.hidden = NO;
    }else
    {
        cell.imgUrl = @"";
        cell.imgMidUrl = @"";
        // cell.imgPhoto.hidden = YES;
    }
    //设置用户名
    NSString *anchor = [NSString stringWithFormat:@"%@", [object objectForKey:@"anchor"]];
    if (anchor!=nil && ![anchor isEqual: @""])
    {
        cell.txtAnchor.text = anchor;
    }else
    {
        cell.txtAnchor.text = @"匿名";
    }
    //设置标签
    NSString *tag = [NSString stringWithFormat:@"%@", [object objectForKey:@"tag"]];
    if (tag==nil || [tag isEqualToString:@""] || tag.length == 0)
    {
        
        cell.txtTag.text = tag;
        
    }else
    {
        cell.txtTag.text = @"";
        
    }
    //设置up ，down and commits
    NSString *upCount = [NSString stringWithFormat:@"%@", [object objectForKey:@"upcount"]];
    [cell.goodbtn setTitle:upCount forState:UIControlStateNormal];
    
    NSString *downCount = [NSString stringWithFormat:@"%@", [object objectForKey:@"downcount"]];
    [cell.badbtn setTitle:downCount forState:UIControlStateNormal];
    
    NSString *commentCount = [NSString stringWithFormat:@"%@", [object objectForKey:@"commentscount"]];
    [cell.commentsbtn setTitle:commentCount forState:UIControlStateNormal];
    
    //发布时间
    //    cell.txtTime.text = [NSString stringWithFormat:@"%d/%d",indexPath.row+1,[self.list count]];//qs.fbTime;
    
    //    [cell.saveBtn setTag:indexPath.row ];
    //    [cell.saveBtn addTarget:self action:@selector(favoriteAction:) forControlEvents:UIControlEventTouchUpInside];
    //
    //
    //    [cell.commentsbtn setTag:indexPath.row];
    //
    //    [cell.commentsbtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [cell.goodbtn setTag:indexPath.row];
    //    [cell.goodbtn addTarget:self action:@selector(goodClick:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [cell.badbtn setTag:indexPath.row];
    //    [cell.badbtn addTarget:self action:@selector(badClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //自适应函数
    [cell resizeTheHeight:kTypeMain];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    //    DLog(@"%d",self.objects.count);
    //    DLog(@"row:%d",indexPath.row);
    //    DLog(@"%@",[self.objects description]);
    if (indexPath.row <= self.objects.count-1) {
        
        NSString *imageUrl = [NSString stringWithFormat:@"%@",[[self.objects objectAtIndex:indexPath.row] objectForKey:@"imageurl"]];
        
        if (imageUrl!=nil && ![imageUrl isEqual: @""] && ![imageUrl isEqual: @"(null)"]) {
            return [self getTheHeight:[NSString stringWithFormat:@"%@",[[self.objects objectAtIndex:indexPath.row] objectForKey:@"content"]] withImage:YES];
        }
        return [self getTheHeight:[NSString stringWithFormat:@"%@",[[self.objects objectAtIndex:indexPath.row] objectForKey:@"content"]] withImage:NO];
        
    }
    
    return 44;
}


//cell 动态 高度
-(CGFloat) getTheHeight:(NSString*)content withImage:(BOOL)isImage
{
    CGFloat contentWidth = 280;
    // 设置字体
    UIFont *font = [UIFont fontWithName:kFont size:14];
    
    
    // 计算出长宽
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, (content.length * 14 * 0.05 + 1 ) * 14) lineBreakMode:UILineBreakModeTailTruncation];
    CGFloat height;
    if (!isImage) {
        height = size.height+140;
    }else
    {
        height = size.height+220;
    }
    // 返回需要的高度
    return height;
    
    
}





 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...test";
 
 return cell;
 }




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}


@end

