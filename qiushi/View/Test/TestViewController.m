//
//  TestViewController.m
//  qiushi
//
//  Created by xuanyuan on 13-1-4.
//  Copyright (c) 2013年 XYXD. All rights reserved.
//

#import "TestViewController.h"
#import "NetManager.h"
#import <Parse/Parse.h>
@interface TestViewController ()

@end

@implementation TestViewController
@synthesize net = _net;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    _net = [[NetManager alloc]init];
//    _net.delegate = self;
//    [_net requestWithURL:nil withType:kRequestTypeGetQsParse withDictionary:nil];
    
    PFQuery *query = [PFQuery queryWithClassName:@"QIUSHI"];
    query.limit = 10;
    query.skip = 0;
    // Sorts the results in descending order by the score field
    [query orderByDescending:@"createdAt"];
    // Sorts the results in descending order by the score field if the previous sort keys are equal.
    [query addDescendingOrder:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        // comments now contains the comments for myPost
        if (!comments) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            // The find succeeded.
            NSLog(@"Successfully retrieved the object.");
            for (PFObject *object in comments) {
//                DLog(@"%@",[object objectForKey:@"content"]);
            }
           
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate net
- (void)refreshDate1:(NSMutableDictionary*)dic data2:(NSMutableArray*)array withType:(int)type
{
    
}


@end
