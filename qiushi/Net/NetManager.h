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
    
}RequestTypeTag;

@protocol RefreshDateNetDelegate <NSObject>

-(void)refreshDate1:(NSMutableDictionary*)dic data2:(NSMutableArray*)array withType:(int)type;

@end

@interface NetManager : NSObject
{
    ASIHTTPRequest *_httpRequest;
    ASIFormDataRequest *_formRequest;
    id <RefreshDateNetDelegate> _delegate;
}

@property (nonatomic, retain) ASIHTTPRequest *httpRequest;
@property (nonatomic, retain) ASIFormDataRequest *formRequest;
@property (nonatomic, retain) id <RefreshDateNetDelegate> delegate;

- (void) requestWithURL:(NSString*)urlString withType:(RequestTypeTag)type withDictionary:(NSDictionary*)dic;
+(NetManager *) SharedNetManager;
@end
