//
//  PhotoViewer.m
//  NetDemo
//
//  Created by Michael on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewer.h"

#import "TestNavigationBar.h"
#import "MyNavigationController.h"
#import "IIViewDeckController.h"


inline static NSString* keyForURL(NSURL* url, NSString* style) {
	if(style) {
		return [NSString stringWithFormat:@"EGOImageLoader-%u-%u", [[url description] hash], [style hash]];
	} else {
		return [NSString stringWithFormat:@"EGOImageLoader-%u", [[url description] hash]];
	}
}

#define kImageNotificationUpdateProgress(s) [@"kEGOImageLoaderNotificationLoadUpdate-" stringByAppendingString:keyForURL(s, nil)]


@interface PhotoViewer()
{

}
-(void) BtnClicked:(id)sender;
-(void)handlePan:(UIPanGestureRecognizer *)recognizer;
-(void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo;
@end

@implementation PhotoViewer
@synthesize imgUrl;
@synthesize imageView = _imageView;
@synthesize hud = _hud;
@synthesize placeholderImage = _placeholderImage;



#pragma mark - View lifecycle


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //设置背景颜色
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        roation = 0;
        scale = 1;
    }
    return self;
}







- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    TestNavigationBar *navigationBar = [[TestNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"有图有真相"];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];
    
    UIImage* image= [UIImage imageNamed:@"navi_back_btn"];
    UIImage* imagef = [UIImage imageNamed:@"navi_back_f_btn"];
    CGRect backframe= CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backframe;
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setBackgroundImage:imagef forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(fadeOut) forControlEvents:UIControlEventTouchUpInside];
    //定制自己的风格的  UIBarButtonItem
    UIBarButtonItem* someBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:backButton];
    navigationItem.leftBarButtonItem = someBarButtonItem;
    
    
    _imageView = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"thumb_pic.png"] delegate:self];
    [_imageView setFrame:self.view.bounds];
    [self.view addSubview:_imageView];
    
    

    _hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:_hud];
	_hud.mode = MBProgressHUDModeDeterminate;
	_hud.labelText = @"亲,正在努力加载中...";
    [_hud show:YES];

    
    NSArray *array = [NSArray arrayWithObjects:@"rotate_left",@"rotate_right",@"zoom_in",@"zoom_out",nil];
    for (int i=0; i<[array count]; i++)
    {
        UIImage *normal = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[array objectAtIndex:i]]];
        UIImage *active = [[UIImage imageNamed:@"imageviewer_toolbar_background.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(60+50*i,420,52,40)];
        [btn setImage:normal forState:UIControlStateNormal];
        [btn setBackgroundImage:active forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        [self.view addSubview:btn];
        
    }
    
    
    //
    //    UIButton *savebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [savebtn setFrame:CGRectMake(220,10,100,40)];
    //    [savebtn setImageEdgeInsets:UIEdgeInsetsMake(0,2,0,0)];
    //    [savebtn setTitleEdgeInsets:UIEdgeInsetsMake(2,-2,0,0)];
    //    [savebtn setImage:[UIImage imageNamed:@"imageviewer_save.png"] forState:UIControlStateNormal];
    //     [savebtn setTitle:@"保存" forState:UIControlStateNormal];
    //    [savebtn setBackgroundImage:[[UIImage imageNamed:@"imageviewer_toolbar_background.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    //    [savebtn setTag:5];
    //    [savebtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:savebtn];
    
    [_imageView setUserInteractionEnabled:YES];
//    UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    [panRcognize setMinimumNumberOfTouches:1];
//    panRcognize.delegate=self;
//    [panRcognize setEnabled:YES];
//    [panRcognize delaysTouchesEnded];
//    [panRcognize cancelsTouchesInView];
//    
//    UIPinchGestureRecognizer *pinchRcognize=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
//    [pinchRcognize setEnabled:YES];
//    [pinchRcognize delaysTouchesEnded];
//    [pinchRcognize cancelsTouchesInView];
//    
//    UIRotationGestureRecognizer *rotationRecognize=[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
//    [rotationRecognize setEnabled:YES];
//    [rotationRecognize delaysTouchesEnded];
//    [rotationRecognize cancelsTouchesInView];
//    rotationRecognize.delegate=self;
//    pinchRcognize.delegate=self;
    
    UISwipeGestureRecognizer *swipeRcognize1=[[UISwipeGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handleSwipe:)];
    swipeRcognize1.delegate=self;
    [swipeRcognize1 setEnabled:YES];
    [swipeRcognize1 delaysTouchesEnded];
    [swipeRcognize1 cancelsTouchesInView];
    swipeRcognize1.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:swipeRcognize1];
    [_imageView addGestureRecognizer:swipeRcognize1];
    
//    [_imageView addGestureRecognizer:rotationRecognize];
//    [_imageView addGestureRecognizer:panRcognize];
//    [_imageView addGestureRecognizer:pinchRcognize];
}

- (void)viewDidUnload
{
    //    NSLog(@"viewDidUnload photoViewer");
    
    [_imageView cancelImageLoad];
    _imageView = nil;
    imgUrl = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([self.viewDeckController leftControllerIsOpen]==YES) {
        [self.viewDeckController closeLeftView];
    }
    
    //    DLog(@"viewWillAppear");
    [_imageView setPlaceholderImage:_placeholderImage];
    
    [_imageView setImageURL:[NSURL URLWithString:imgUrl]];
    //    DLog(@"imgUrl:%@",imgUrl);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(update:)
                                                 name:kImageNotificationUpdateProgress([NSURL URLWithString:imgUrl])
                                               object:nil];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)update:(NSNotification *)notification
{
    //    NSLog(@"Received notification: %@", notification);
    
    float progress = [[[notification userInfo] objectForKey:@"progress"] floatValue];
    NSLog(@"%f",progress);
    

    [_hud setProgress:progress];
    
    
    
}


#pragma mark - user action

-(void) BtnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:  //向左
        {
            [UIView animateWithDuration:0.5f animations:^{
                roation -=M_PI_2;
                _imageView.transform = CGAffineTransformMakeRotation(roation);
            }];
        }
            break;
        case 1:  //向右
        {
            
            [UIView animateWithDuration:0.5f animations:^{
                roation +=M_PI_2;
                _imageView.transform = CGAffineTransformMakeRotation(roation);
            }];
        }
            break;
        case 2:  //放大
        {
            [UIView animateWithDuration:0.5f animations:^{
                scale*=1.5;
                _imageView.transform = CGAffineTransformMakeScale(scale,scale);
            }];
        }
            break;
        case 3:  //缩小
        {
            [UIView animateWithDuration:0.5f animations:^{
                scale/=1.5;
                _imageView.transform = CGAffineTransformMakeScale(scale,scale);
            }];
        }
            break;
        case 4://返回
        {
            [self fadeOut];
        }
            break;
        case 5://保存.
        {
            //调用方法保存到相册的代码
            UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
            
        }
            break;
        default:
            break;
    }
    
}



//实现类中实现
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo
{
    NSString *message;
    NSString *title;
    if (!error) {
        title = @"成功提示";
        message = [NSString stringWithFormat:@"成功保存到相冊"];
    } else {
        title = @"失败提示";
        message = [error description];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"知道了"
                                          otherButtonTitles:nil];
    [alert show];
    
}

-(void)handleSwipe:(UISwipeGestureRecognizer *)recognizer
{
    [self fadeOut];
    
    
//    UISwipeGestureRecognizerDirection direction = recognizer.direction;
//    if (direction == 1)
//    {
//        //右
//        [self fadeOut];
//        
//        
//    }else if (direction == 2)
//    {
//        [self fadeOut];
//        //左
//        
//    }else if (direction == UISwipeGestureRecognizerDirectionDown){
//        [self fadeOut];
//    }
    
}


/*
 *  移动图片处理的函数
 *  @recognizer 移动手势
 */
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    //    CGPoint translation = [recognizer translationInView:self.view];
    //
    //    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    //
    //    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
}
/*
 * handPinch 缩放的函数
 * @recognizer UIPinchGestureRecognizer 手势识别器
 */
- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer{
    
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    
    recognizer.scale = 1;
    
}

/*
 * handleRotate 旋转的函数
 * recognizer UIRotationGestureRecognizer 手势识别器
 */
- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer{
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}



- (void)imageViewLoadedImage:(EGOImageView*)imageview
{
    
    CGFloat w = 1.0f;
    CGFloat h = 1.0f;
    if (imageview.image.size.width>self.view.bounds.size.width) {
        w = imageview.image.size.width/self.view.bounds.size.width;
    }
    if (imageview.image.size.height>self.view.bounds.size.height) {
        h = imageview.image.size.height/self.view.bounds.size.height;
    }
    CGFloat scole = w>h ? w:h;
    
    CGRect rect = CGRectMake(0, 0,imageview.image.size.width/scole,imageview.image.size.height/scole);
    [_imageView setFrame:rect];
    _imageView.center = self.view.center;
    

    [_hud hide:YES afterDelay:0];
    [_hud setProgress:0];
}

- (void)imageViewFailedToLoadImage:(EGOImageView*)imageview error:(NSError*)error
{
    
    [self.imageView cancelImageLoad];
    NSLog(@"Failed to load %@", imgUrl);
    

    [_hud setLabelText:@"网络连接失败"];
    [_hud hide:YES];
    [_hud setProgress:0];

    
}



-(void) fadeOut
{
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [[delegate navController] dismissModalViewControllerAnimated:YES];
}



@end
