//
//  FeedBackViewController.h
//  qiushi
//
//  Created by xyxd on 12-11-3.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FeedBackViewController : UIViewController
<UITextViewDelegate,UITextFieldDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UITextView *mTextView;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *mName;


@end
