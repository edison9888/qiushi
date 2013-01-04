//
//  TestViewController.m
//  qiushi
//
//  Created by xuanyuan on 13-1-4.
//  Copyright (c) 2013年 XYXD. All rights reserved.
//

#import "TestViewController.h"
#import "NetManager.h"

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
    _net = [[NetManager alloc]init];
    _net.delegate = self;
    [_net requestWithURL:nil withType:kRequestTypeGetQsParse withDictionary:nil];
    
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
