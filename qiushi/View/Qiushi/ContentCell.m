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

@interface ContentCell()
{
    UIImage *tagImage;
    UIImage *saveImage;
}

@end;

@implementation ContentCell
//@property(nonatomic,retain) EGOImageButton *imgPhoto;
//
//
//@property(nonatomic,retain) NSString *imgUrl;
//@property(nonatomic,retain) NSString *imgMidUrl;
//
//@property (weak, nonatomic) IBOutlet UIImageView *headPhoto;
//@property (weak, nonatomic) IBOutlet UIButton *goodbtn;
//@property (weak, nonatomic) IBOutlet UIButton *badbtn;
//@property (weak, nonatomic) IBOutlet UIButton *commentsbtn;
//@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
//@property (weak, nonatomic) IBOutlet UILabel *txtTime;
//@property (weak, nonatomic) IBOutlet UILabel *txtAnchor;
//@property (weak, nonatomic) IBOutlet UILabel *txtContent;
//@property (weak, nonatomic) IBOutlet UILabel *txtTag;

@synthesize imgPhoto;
@synthesize imgUrl;
@synthesize imgMidUrl;
@synthesize headPhoto;
@synthesize goodbtn;
@synthesize badbtn;
@synthesize commentsbtn;
@synthesize saveBtn;
@synthesize txtTime;
@synthesize txtAnchor;
@synthesize txtContent;
@synthesize txtTag;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
     


        
//        _imgPhoto = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"thumb_pic.png"] delegate:self];
//        [_imgPhoto setFrame:CGRectMake(0, 0, 0, 0)];
//        [_imgPhoto setTag:FImage];
//        [_imgPhoto addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_imgPhoto];


        
        }
    return self;
}


//-(void) resizeTheHeight:(int)type
//{
//    CGFloat contentWidth;
//    if (type != kTypeHistory) {
//        contentWidth = 280;
//        contentWidth =  floorf(contentWidth / kSize) * kSize;
//    }else{
//        contentWidth = 250;
//        contentWidth =  floorf(contentWidth / kSize) * kSize;
//    }
//
// 
//    UIFont *font = [UIFont fontWithName:kFont size:kSize];
//    
//    CGSize size = CGSizeMake(0, 0);
//    if (type == kTypeMain || type == kTypeHistory)
//    {
//        size = [_txtContent.text sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:UILineBreakModeTailTruncation];
//    }else if (type == kTypeContent)
//    {
//        size = [_txtContent.text sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, (_txtContent.text.length * kSize /contentWidth + 1) * kSize) lineBreakMode:UILineBreakModeWordWrap];
//
//        DLog(@"%f",(_txtContent.text.length * kSize /contentWidth + 1) * kSize);
//        
//
//    }
//
//    DLog(@"%@",NSStringFromCGSize(size));
//    
////    if (type == kTypeContent) {
////        [txtContent setFrame:CGRectMake(20,
////                                        headPhoto.frame.origin.y + headPhoto.frame.size.height,
////                                        contentWidth,
////                                        size.height+80)];
////    }else {
//        [_txtContent setFrame:CGRectMake(20,
//                                        _txtContent.frame.origin.y + _txtContent.frame.size.height,
//                                        contentWidth,
//                                        size.height)];
////    }
//
//    
//    if (_imgUrl != nil && ![_imgUrl isEqualToString:@""]) {
//       [_imgPhoto setFrame:CGRectMake(30, size.height+30, 72, 72)];
//
//       [_imgPhoto setImageURL:[NSURL URLWithString:_imgUrl]];
//       [self imageButtonLoadedImage:_imgPhoto];
//    }
//    else
//    {
//        [_imgPhoto cancelImageLoad];
//        [_imgPhoto setFrame:CGRectMake(120, size.height, 0, 0)];
//        
//    }
//    
//
//
//    
//}
//
//
//-(void) btnClicked:(id)sender
//{
//    UIButton *btn =(UIButton *) sender;
//    switch (btn.tag) {
//        case FImage:
//        {
//            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//            
//            //    _photoview = [[PhotoViewer alloc]initWithNibName:@"PhotoViewer" bundle:nil];
//            //    _photoview.imgUrl = self.imgMidUrl;
//            //    DLog(@"self.imgMidUrl:%@",self.imgMidUrl);
//            //    _photoview.placeholderImage = [[self.imgPhoto imageView] image];
//            //    [[delegate navController] presentModalViewController:_photoview animated:YES];
//            
//            
//            MyPhoto *photo = [[MyPhoto alloc] initWithImageURL:[NSURL URLWithString:self.imgMidUrl] name:_txtContent.text image:nil pImage:[[self.imgPhoto imageView] image]];
//           
//            MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:[NSArray arrayWithObjects:photo, nil]];
//            
//            EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
//            
//
////            [[delegate navController] presentModalViewController:photoController animated:YES];
//            UINavigationController *aboutNavController = [[UINavigationController alloc] initWithRootViewController:photoController];
//            aboutNavController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//
//            [[delegate navController] presentModalViewController:aboutNavController animated:YES];
//            
//            
//        }break;
//
//        default:
//        {
//            NSAssert(nil, @"button tag error");
//        }break;
//    }
//}
//
//
//
//
//#pragma mark - delegate
//
//- (void)imageButtonLoadedImage:(EGOImageButton*)imageButton
//{
//     // NSLog(@" Did finish load %@",imgUrl);
//    UIImage *image = imageButton.imageView.image;
//    CGFloat w = 1.0f;
//    CGFloat h = 1.0f;
//    if (image.size.width>280) {
//        w = image.size.width/280;
//    }
//    if (image.size.height>72) {
//        h = image.size.height/72;
//    }
//    CGFloat scole = w>h ? w:h;
//    
//    CGRect rect = CGRectMake(30 ,imageButton.frame.origin.y,image.size.width/scole,image.size.height/scole);
//    [_imgPhoto setFrame:rect];
//   
//}
//
//- (void)imageButtonFailedToLoadImage:(EGOImageButton*)imageButton error:(NSError*)error;
//{
//    [imageButton cancelImageLoad];
//    //NSLog(@"Failed to load %@", imgUrl);
//}
//
//

@end
