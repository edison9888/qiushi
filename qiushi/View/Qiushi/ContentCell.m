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
#import "Utils.h"


@implementation ContentCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [_imgPhoto setPlaceholderImage:[UIImage imageNamed:@"thumb_pic.png"]];
        [_imgPhoto setDelegate:self];
        [_imgPhoto setFrame:CGRectMake(0, 0, 0, 0)];
        
        
    }
    return self;
}


-(void) resizeTheHeight:(int)type
{
    CGFloat contentWidth;
    if (type != kTypeHistory) {
        contentWidth = 280;
        contentWidth = [[Utils notRounding:(contentWidth / kSize) afterPoint:0] floatValue];
        contentWidth = contentWidth * kSize;
    }else{
        contentWidth = 250;
        contentWidth = [[Utils notRounding:(contentWidth / kSize) afterPoint:0] floatValue];
        contentWidth = contentWidth * kSize;
    }
    
    
    
    UIFont *font = [UIFont fontWithName:kFont size:kSize];
    
    CGSize size = CGSizeMake(0, 0);
    
    if (type == kTypeContent) {
        size = [_txtContent.text sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 2200) lineBreakMode:UILineBreakModeTailTruncation];
    }else {
        size = [_txtContent.text sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:UILineBreakModeTailTruncation];
    }
    
    
    
    
//    DLog(@"%@",NSStringFromCGSize(size));
    
    
    CGRect frame = _txtContent.frame;
    CGRect frame1 = _txtContent.frame;
    frame.size.height = size.height;
    [_txtContent setFrame:frame];
    
    
    
    
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
        [_imgPhoto setFrame:CGRectZero];
        
    }
    
    
    
    frame = self.imageTag.frame;
    frame.origin.y = frame.origin.y + size.height - frame1.size.height + imageHeight;
    self.imageTag.frame = frame;
    
    CGFloat tagHeight = 0;
    if (self.txtTag.text.length == 0) {
        tagHeight = 30;//self.imageTag.frame.size.height;
        [self.imageTag setHidden:YES];
    }else {
        tagHeight = 0;
        [self.imageTag setHidden:NO];
    }
    
    frame = self.txtTag.frame;
    frame.origin.y = frame.origin.y + size.height - frame1.size.height + imageHeight;
    self.txtTag.frame = frame;
    
    frame = self.goodbtn.frame;
    frame.origin.y = frame.origin.y + size.height - frame1.size.height + imageHeight - tagHeight;
    self.goodbtn.frame = frame;
    
    frame = self.badbtn.frame;
    frame.origin.y = frame.origin.y + size.height - frame1.size.height + imageHeight - tagHeight;
    self.badbtn.frame = frame;
    
    frame = self.commentsbtn.frame;
    frame.origin.y = frame.origin.y + size.height - frame1.size.height + imageHeight - tagHeight;
    self.commentsbtn.frame = frame;
    
    frame = self.saveBtn.frame;
    frame.origin.y = frame.origin.y + size.height - frame1.size.height + imageHeight - tagHeight;
    self.saveBtn.frame = frame;
    
    frame = self.imageBg.frame;
    frame.size.height = frame.size.height + size.height - frame1.size.height + imageHeight - tagHeight;
    self.imageBg.frame = frame;
    
    UIImage *bg = [UIImage imageNamed:@"block_center_background.png"];
    if ([bg respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]) {
        UIEdgeInsets ed = {1.0f, 1.0f, 1.0f, 1.0f};
        self.imageBg.image = [bg resizableImageWithCapInsets:ed resizingMode:UIImageResizingModeTile];
    }else if ([bg respondsToSelector:@selector(stretchableImageWithLeftCapWidth:topCapHeight:)]) {
        self.imageBg.image = [bg stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    }
    
    
    frame = self.imageFoot.frame;
    frame.origin.y = frame.origin.y + size.height - frame1.size.height + imageHeight - tagHeight;
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





@end
