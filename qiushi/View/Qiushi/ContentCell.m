//
//  ContentCell.m
//  NetDemo
//
//  Created by Michael on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContentCell.h"

#import "CommentsViewController.h"
#import "PhotoViewer.h"
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
@synthesize txtContent,txtAnchor,headPhoto,footView,centerimageView,TagPhoto;
@synthesize commentsbtn,badbtn,goodbtn,imgUrl,txtTag,txtTime;
@synthesize imgPhoto,imgMidUrl;
@synthesize photoview = _photoview;
@synthesize saveBtn = _saveBtn;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
     
//        NSLog(@"init ContentCell");

        UIImage *centerimage = [UIImage imageNamed:@"block_center_background.png"];
        centerimageView = [[UIImageView alloc]initWithImage:centerimage];
        [centerimageView setFrame:CGRectMake(0, 0, 320, 220)];
        [self addSubview:centerimageView];
 
        
        txtContent = [[UILabel alloc]init];
        [txtContent setBackgroundColor:[UIColor clearColor]];
        [txtContent setFrame:CGRectMake(20, 10, 280, 220)];
        [txtContent setFont:[UIFont fontWithName:kFont size:14]];
        [txtContent setLineBreakMode:UILineBreakModeTailTruncation];
        [self addSubview:txtContent];
    
        imgPhoto = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"thumb_pic.png"] delegate:self];
        [imgPhoto setFrame:CGRectMake(0, 0, 0, 0)];
        [imgPhoto setTag:FImage];
        [imgPhoto addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imgPhoto];
        
        headPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 24, 24)];
        [headPhoto setImage:[UIImage imageNamed:@"thumb_avatar.png"]];
        [self addSubview:headPhoto];
    
        txtAnchor = [[UILabel alloc]initWithFrame:CGRectMake(45,5, 240-45, 30)];
        [txtAnchor setText:@"匿名"];
        [txtAnchor setFont:[UIFont fontWithName:kFont size:14]];
        [txtAnchor setBackgroundColor:[UIColor clearColor]];
        [txtAnchor setTextColor:[UIColor brownColor]];
        [self addSubview:txtAnchor];
        
        //发布时间
        txtTime = [[UILabel alloc]initWithFrame:CGRectMake(235, 5, 90, 32)];
        [txtTime setFont:[UIFont fontWithName:kFont size:10]];
        [txtTime setBackgroundColor:[UIColor clearColor]];
        [txtTime setTextColor:[UIColor brownColor]];
        [self addSubview:txtTime];

        
        
        txtTag = [[UILabel alloc]initWithFrame:CGRectMake(45,200, 200, 30)];
        [txtTag setText:@""];
        [txtTag setFont:[UIFont fontWithName:kFont size:14]];
        [txtTag setBackgroundColor:[UIColor clearColor]];
        [txtTag setTextColor:[UIColor brownColor]];
        [self addSubview:txtTag];
        
        tagImage = [UIImage imageNamed:@"icon_tag.png"];
        TagPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(15, 200, tagImage.size.width, tagImage.size.height)];
        [TagPhoto setImage:tagImage];
        [self addSubview:TagPhoto];
        
        UIImage *footimage = [UIImage imageNamed:@"block_foot_background.png"];
        footView = [[UIImageView alloc]initWithImage:footimage];
        [footView setFrame:CGRectMake(0, txtContent.frame.size.height, footimage.size.width, footimage.size.height)];
        [self addSubview:footView];
       
        //添加Button，顶，踩，评论  
        goodbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [goodbtn setFrame:CGRectMake(10,txtContent.frame.size.height-30,70,32)];
        [goodbtn setImage:[UIImage imageNamed:@"icon_for_good.png"] forState:UIControlStateNormal];
        [goodbtn setImageEdgeInsets:UIEdgeInsetsMake(0, .5, 0, 0)];
        [goodbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
        [goodbtn setTitle:@"0" forState:UIControlStateNormal];
        [goodbtn.titleLabel setFont:[UIFont fontWithName:kFont size:14]];
        [goodbtn.titleLabel setTextAlignment:UITextAlignmentRight];
        [goodbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [goodbtn setTag:FGOOD];
        [self addSubview:goodbtn];
        
        badbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [badbtn setFrame:CGRectMake(90,txtContent.frame.size.height-30,70,32)];
        [badbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
        [badbtn setImageEdgeInsets:UIEdgeInsetsMake(0, .5, 0, 0)];
        [badbtn setImage:[UIImage imageNamed:@"icon_for_bad.png"] forState:UIControlStateNormal];
        [badbtn setTitle:@"0" forState:UIControlStateNormal];
        [badbtn.titleLabel setFont:[UIFont fontWithName:kFont size:14]];
        [badbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [badbtn setTag:FBAD];
        [self addSubview:badbtn];
        
        commentsbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commentsbtn setFrame:CGRectMake(170,txtContent.frame.size.height-30,70,32)];


        [commentsbtn setImage:[UIImage imageNamed:@"icon_for_comment.png"] forState:UIControlStateNormal];

        [commentsbtn setImageEdgeInsets:UIEdgeInsetsMake(0, .5, 0, 0)];
        [commentsbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
        [commentsbtn.titleLabel setFont:[UIFont fontWithName:kFont size:14]];
        [commentsbtn setTitle:@"0" forState:UIControlStateNormal];
        [commentsbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       
        [commentsbtn setTag:FCOMMITE];
        [self addSubview:commentsbtn];
     
        saveImage = [UIImage imageNamed:@"button_save.png"];
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setFrame:CGRectMake(260,txtContent.frame.size.height-30,saveImage.size.width,saveImage.size.height)];
        [_saveBtn setImage:saveImage forState:UIControlStateNormal];
        [_saveBtn setTag:FSave];
        [self addSubview:_saveBtn];
    }
    return self;
}


-(void) resizeTheHeight:(int)type
{
    CGFloat contentWidth;
    if (type != kTypeHistory) {
        contentWidth = 280;  
    }else{
        contentWidth = 250;
    }

 
    UIFont *font = [UIFont fontWithName:kFont size:14];
    
    CGSize size = CGSizeMake(0, 0);
    if (type == kTypeMain || type == kTypeHistory)
    {
        size = [txtContent.text sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:UILineBreakModeTailTruncation];
    }else if (type == kTypeContent)
    {
        size = [txtContent.text sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, (txtContent.text.length * 14 * 0.05 + 1 ) * 14) lineBreakMode:UILineBreakModeTailTruncation];
    }
    
    
    [txtContent setFrame:CGRectMake(20, 10, contentWidth, size.height+60)];
    
    if (imgUrl!=nil&&![imgUrl isEqualToString:@""]) {
       [imgPhoto setFrame:CGRectMake(30, size.height+70, 72, 72)];
       [centerimageView setFrame:CGRectMake(0, 0, 320, size.height+200)];
       [imgPhoto setImageURL:[NSURL URLWithString:imgUrl]];
       [self imageButtonLoadedImage:imgPhoto];
    }
    else
    {
        [imgPhoto cancelImageLoad];
        [imgPhoto setFrame:CGRectMake(120, size.height, 0, 0)];
        [centerimageView setFrame:CGRectMake(0, 0, 320, size.height+120)];
    }
    
    [footView setFrame:CGRectMake(0, centerimageView.frame.size.height, 320, 15)];
    [goodbtn setFrame:CGRectMake(10,centerimageView.frame.size.height-28,70,32)];
    [badbtn setFrame:CGRectMake(90,centerimageView.frame.size.height-28,70,32)];
    [commentsbtn setFrame:CGRectMake(170,centerimageView.frame.size.height-28,70,32)];
    [_saveBtn setFrame:CGRectMake(260, centerimageView.frame.size.height-28, saveImage.size.width,saveImage.size.height)];
    [txtTag setFrame:CGRectMake(40,centerimageView.frame.size.height-50,200, 30)];
    [TagPhoto setFrame:CGRectMake(15,centerimageView.frame.size.height-50,tagImage.size.width, tagImage.size.height)];

    
}


-(void) btnClicked:(id)sender
{
    UIButton *btn =(UIButton *) sender;
    switch (btn.tag) {
        case FImage:
        {
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            //    _photoview = [[PhotoViewer alloc]initWithNibName:@"PhotoViewer" bundle:nil];
            //    _photoview.imgUrl = self.imgMidUrl;
            //    DLog(@"self.imgMidUrl:%@",self.imgMidUrl);
            //    _photoview.placeholderImage = [[self.imgPhoto imageView] image];
            //    [[delegate navController] presentModalViewController:_photoview animated:YES];
            
            
            MyPhoto *photo = [[MyPhoto alloc] initWithImageURL:[NSURL URLWithString:self.imgMidUrl] name:txtContent.text];
           
            MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:[NSArray arrayWithObjects:photo, nil]];
            
            EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
            

            [[delegate navController] presentModalViewController:photoController animated:YES];
            
            
        }break;

        default:
        {
            NSAssert(nil, @"button tag error");
        }break;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    [imgPhoto setFrame:rect];
   
}

- (void)imageButtonFailedToLoadImage:(EGOImageButton*)imageButton error:(NSError*)error;
{
    [imageButton cancelImageLoad];
    //NSLog(@"Failed to load %@", imgUrl);
}

- (void)dealloc
{
    _photoview = nil;
//    NSLog(@"dealloc ContentCell");
}



@end
