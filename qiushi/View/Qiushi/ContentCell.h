//
//  ContentCell.h
//  NetDemo
//
//  Created by Michael on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"



#define kTypeMain   1001
#define kTypeContent 1002
#define kTypeHistory    1003

@interface ContentCell : UITableViewCell
<EGOImageButtonDelegate>
{
//     //糗事图片
//    EGOImageButton *imgPhoto;
//    //糗事图片的小图url
//    NSString *imgUrl;
//    //糗事图片的大图url
//    NSString *imgMidUrl;
//    //糗事标签
//    UILabel *txtTag;
//    //糗事作者
//    UILabel *txtAnchor;
//    
//    //更新时间
//    UILabel *txtTime;
//    
//    //糗事内容
//    UILabel *txtContent;
//    //作者头像
//    UIImageView *headPhoto;
//    //标签图像
//    UIImageView *TagPhoto;
//    //底部花边
//    UIImageView *footView;
//    //顶按钮
//    UIButton *goodbtn;   
//    //踩按钮
//    UIButton *badbtn;   
//    //评论按钮  
//    UIButton *commentsbtn;
//    //收藏按钮
//    UIButton *_saveBtn;
//
//    
//    PhotoViewer *_photoview;
}


@property (weak, nonatomic) IBOutlet EGOImageButton *imgPhoto;

@property (nonatomic,retain) NSString *imgUrl;
@property (nonatomic,retain) NSString *imgMidUrl;

@property (weak, nonatomic) IBOutlet UIImageView *headPhoto;
@property (weak, nonatomic) IBOutlet UILabel *txtTime;
@property (weak, nonatomic) IBOutlet UILabel *txtAnchor;

@property (weak, nonatomic) IBOutlet UIButton *goodbtn;
@property (weak, nonatomic) IBOutlet UIButton *badbtn;
@property (weak, nonatomic) IBOutlet UIButton *commentsbtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *txtContent;
@property (weak, nonatomic) IBOutlet UILabel *txtTag;
@property (weak, nonatomic) IBOutlet UIImageView *imageTag;
@property (weak, nonatomic) IBOutlet UIImageView *imageBg;
@property (weak, nonatomic) IBOutlet UIImageView *imageFoot;


-(void) resizeTheHeight:(int)type;
@end
