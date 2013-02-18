//
//  ContentCell.m
//  NetDemo
//
//  Created by Michael on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContentCell.h"

#import "CommentsViewController.h"

#import "MyNavigationController.h"
#import "EGOPhotoViewController.h"
#import "MyPhoto.h"
#import "MyPhotoSource.h"

#define FGOOD       101
#define FBAD        102
#define FCOMMITE    103
#define FSave       104
#define FImage      105

@implementation ContentCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [_imgPhoto setPlaceholderImage:[UIImage imageNamed:@"thumb_pic.png"]];
        [_imgPhoto setDelegate:self];
        [_imgPhoto setFrame:CGRectMake(0, 0, 0, 0)];
//        [_imgPhoto setTag:FImage];
//        [_imgPhoto addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}


-(void) resizeTheHeight:(int)type
{
    CGFloat contentWidth;
    if (type != kTypeHistory) {
        contentWidth = 280;
        contentWidth = [[self notRounding:(contentWidth / kSize) afterPoint:0] floatValue];
        contentWidth = contentWidth * kSize;
    }else{
        contentWidth = 250;
        contentWidth = [[self notRounding:(contentWidth / kSize) afterPoint:0] floatValue];
        contentWidth = contentWidth * kSize;
    }
    
    
    UIFont *font = [UIFont fontWithName:kFont size:kSize];
    
    CGSize size = CGSizeMake(0, 0);
    if (type == kTypeMain || type == kTypeHistory)
    {
        size = [_txtContent.text sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:UILineBreakModeTailTruncation];
    }else if (type == kTypeContent)
    {
        size = [_txtContent.text sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, (_txtContent.text.length * kSize /contentWidth + 1) * kSize) lineBreakMode:UILineBreakModeWordWrap];
        
        DLog(@"%f",(_txtContent.text.length * kSize /contentWidth + 1) * kSize);
        
        
    }
    
    DLog(@"%@",NSStringFromCGSize(size));
    
    //    if (type == kTypeContent) {
    //        [txtContent setFrame:CGRectMake(20,
    //                                        headPhoto.frame.origin.y + headPhoto.frame.size.height,
    //                                        contentWidth,
    //                                        size.height+80)];
    //    }else {
//    [_txtContent setFrame:CGRectMake(20,
//                                     _txtContent.frame.origin.y + _txtContent.frame.size.height,
//                                     contentWidth,
//                                     size.height)];
    CGRect frame = _txtContent.frame;
    CGRect frame1 = _txtContent.frame;
    frame.size.height = size.height;
    [_txtContent setFrame:frame];
    //    }
    
    
    
    CGFloat imageHeight = 0;
    if (_imgUrl != nil && ![_imgUrl isEqualToString:@""]) {
        
        imageHeight = 100;
        frame.origin.y = frame.origin.y + frame.size.height + 6;
        frame.size.height = 88;
        [_imgPhoto setFrame:frame];
        
        [_imgPhoto setImageURL:[NSURL URLWithString:_imgUrl]];
        [self imageButtonLoadedImage:_imgPhoto];
    }
    else
    {
         imageHeight = 0;
        [_imgPhoto cancelImageLoad];
        [_imgPhoto setFrame:CGRectMake(0, 0, 0, 0)];
        
    }
    
    
    
    frame = self.imageTag.frame;
    frame.origin.y = frame.origin.y + size.height - frame1.size.height + imageHeight;
    self.imageTag.frame = frame;
    
    frame = self.txtTag.frame;
    frame.origin.y = frame.origin.y + size.height - frame1.size.height + imageHeight;
    self.txtTag.frame = frame;
    
    frame = self.goodbtn.frame;
    frame.origin.y = frame.origin.y + size.height - frame1.size.height + imageHeight;
    self.goodbtn.frame = frame;
    
    frame = self.badbtn.frame;
    frame.origin.y = frame.origin.y + size.height - frame1.size.height + imageHeight;
    self.badbtn.frame = frame;
    
    frame = self.commentsbtn.frame;
    frame.origin.y = frame.origin.y + size.height - frame1.size.height + imageHeight;
    self.commentsbtn.frame = frame;
    
    frame = self.saveBtn.frame;
    frame.origin.y = frame.origin.y + size.height - frame1.size.height + imageHeight;
    self.saveBtn.frame = frame;
    
    frame = self.imageBg.frame;
    frame.size.height = frame.size.height + size.height - frame1.size.height + imageHeight;
    self.imageBg.frame = frame;
    
    frame = self.imageFoot.frame;
    frame.origin.y = frame.origin.y + size.height - frame1.size.height + imageHeight;
    self.imageFoot.frame = frame;
    

    
}

- (IBAction)btnClick:(id)sender
{
    DLog(@"click");
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //    _photoview = [[PhotoViewer alloc]initWithNibName:@"PhotoViewer" bundle:nil];
    //    _photoview.imgUrl = self.imgMidUrl;
    //    DLog(@"self.imgMidUrl:%@",self.imgMidUrl);
    //    _photoview.placeholderImage = [[self.imgPhoto imageView] image];
    //    [[delegate navController] presentModalViewController:_photoview animated:YES];
    
    
    MyPhoto *photo = [[MyPhoto alloc] initWithImageURL:[NSURL URLWithString:self.imgMidUrl] name:_txtContent.text image:nil pImage:[[self.imgPhoto imageView] image]];
    
    MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:[NSArray arrayWithObjects:photo, nil]];
    
    EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
    
    
    //            [[delegate navController] presentModalViewController:photoController animated:YES];
    UINavigationController *aboutNavController = [[UINavigationController alloc] initWithRootViewController:photoController];
    aboutNavController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [[delegate navController] presentModalViewController:aboutNavController animated:YES];
}

-(void) btnClicked:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    switch (btn.tag) {
        case FImage:
        {
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            //    _photoview = [[PhotoViewer alloc]initWithNibName:@"PhotoViewer" bundle:nil];
            //    _photoview.imgUrl = self.imgMidUrl;
            //    DLog(@"self.imgMidUrl:%@",self.imgMidUrl);
            //    _photoview.placeholderImage = [[self.imgPhoto imageView] image];
            //    [[delegate navController] presentModalViewController:_photoview animated:YES];
            
            
            MyPhoto *photo = [[MyPhoto alloc] initWithImageURL:[NSURL URLWithString:self.imgMidUrl] name:_txtContent.text image:nil pImage:[[self.imgPhoto imageView] image]];
            
            MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:[NSArray arrayWithObjects:photo, nil]];
            
            EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
            
            
            //            [[delegate navController] presentModalViewController:photoController animated:YES];
            UINavigationController *aboutNavController = [[UINavigationController alloc] initWithRootViewController:photoController];
            aboutNavController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            
            [[delegate navController] presentModalViewController:aboutNavController animated:YES];
            
            
        }break;
            
        default:
        {
            NSAssert(nil, @"button tag error");
        }break;
    }
}




#pragma mark - delegate

- (void)imageButtonLoadedImage:(EGOImageButton*)imageButton
{
    // NSLog(@" Did finish load %@",imgUrl);
    UIImage *image = imageButton.imageView.image;
    CGFloat w = 1.0f;
    CGFloat h = 1.0f;
    if (image.size.width>280) {
        w = image.size.width/280;
    }
    if (image.size.height>72) {
        h = image.size.height/72;
    }
    CGFloat scole = w>h ? w:h;
    
    CGRect rect = CGRectMake(30 ,imageButton.frame.origin.y,image.size.width/scole,image.size.height/scole);
    [_imgPhoto setFrame:rect];
    
}

- (void)imageButtonFailedToLoadImage:(EGOImageButton*)imageButton error:(NSError*)error;
{
    [imageButton cancelImageLoad];
    //NSLog(@"Failed to load %@", imgUrl);
}



-(NSString *)notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    //    [ouncesDecimal release];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}


@end
