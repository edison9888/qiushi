//
//  ProgressStatusBar.h
//  ProgressStatusBar
//
//  Created by chenfei on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProgressStatusBarDelegate <NSObject>

- (void)closeButtonClicked;

@end

@interface ProgressStatusBar : UIWindow {
    UILabel     *loadingLabel;
    UIView      *loadingView;
    UIImageView *flashView;
    UIButton    *closeButton;
    
    NSTimer     *timer;
    
    id<ProgressStatusBarDelegate> delegate;
}

@property(nonatomic, assign) id<ProgressStatusBarDelegate> delegate;

/*
 * progress: [0, 1]
 */
- (void)setProgress:(CGFloat)progress;
- (void)setLoadingMsg:(NSString *)msg;
- (void)show;
- (void)hide;

@end
