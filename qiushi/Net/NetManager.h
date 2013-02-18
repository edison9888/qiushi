//
//  NetManager.h
//  qiushi
//
//  Created by xyxd mac on 12-12-24.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ASIFormDataRequest;
@class ASIHTTPRequest;

typedef enum _RequestTypeTag
{
    kRequestTypeGetQiushi = 1001,
    kRequestTypeGetComment,
    kRequestTypeGetQsParse,
    kRequestTypeLogin,
    kRequestTypeCreate,//发布糗事
    
}RequestTypeTag;

@protocol RefreshDateNetDelegate <NSObject>

-(void)refreshDate1:(NSMutableDictionary*)dic data2:(NSMutableArray*)array withType:(int)type isOk:(BOOL)isOk;

@end

@interface NetManager : NSObject
{
    ASIHTTPRequest *_httpRequest;
    ASIFormDataRequest *_formRequest;
//    id <RefreshDateNetDelegate> _delegate;
}

@property (nonatomic, retain) ASIHTTPRequest *httpRequest;
@property (nonatomic, retain) ASIFormDataRequest *formRequest;
//@property (nonatomic, retain) id <RefreshDateNetDelegate> delegate;

- (void) requestWithURL:(NSString*)urlString
               withType:(RequestTypeTag)type
         withDictionary:(NSMutableDictionary*)dic
           withDelegate:(id <RefreshDateNetDelegate>)delegate;

+(NetManager *) SharedNetManager;
@end


/** 
 http://m2.qiushibaike.com/article/create
 {"content":"fdfhffhh","anonymous":true,"allow_comment":1}

 
 
 
 
 
 
 */
