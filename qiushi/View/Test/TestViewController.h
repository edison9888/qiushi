//
//  TestViewController.h
//  qiushi
//
//  Created by xuanyuan on 13-1-4.
//  Copyright (c) 2013年 XYXD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NetManager;
@interface TestViewController : UIViewController
{
    NetManager *_net;
}
@property (retain,nonatomic) NetManager *net;
@end
