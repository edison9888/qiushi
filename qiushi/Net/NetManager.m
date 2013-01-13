//
//  NetManager.m
//  qiushi
//
//  Created by xyxd mac on 12-12-24.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import "NetManager.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "IsNetWorkUtil.h"
#import "MyProgressHud.h"
#import "iToast.h"
#import "JSON.h"

@implementation NetManager

@synthesize httpRequest = _httpRequest;
@synthesize formRequest = _formRequest;


- (void) dealloc
{
    DLog(@"~dealloc NetManager");
    [self.httpRequest clearDelegatesAndCancel];
    [self.formRequest clearDelegatesAndCancel];
    self.httpRequest = nil;
    self.formRequest = nil;
    
  
    
}

// 是否适合用 单例??? 如何使用? 在init方法 初始化 AsiHttpRequest?
static NetManager *_sharedContext = nil;
+ (NetManager *) SharedNetManager
{
    if(!_sharedContext)
    {
        _sharedContext =[[NetManager alloc] init];

    }
    return  _sharedContext;
}

- (id) init
{
    if (self = [super init])
    {
        _sharedContext = self;
    }
    return self;
}


- (void) requestWithURL:(NSString*)urlString withType:(RequestTypeTag)type withDictionary:(NSDictionary*)dic
{
    if (![IsNetWorkUtil isNetWork1])
    {
        return;
    }
    
    
    if (type == kRequestTypeGetQiushi
        || type == kRequestTypeGetComment)
    {
        
        
        _httpRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
        [self.httpRequest setTag:type];
        [self.httpRequest setDelegate:self];
        [self.httpRequest setDidFailSelector:@selector(requestFail:)];
        [self.httpRequest setDidFinishSelector:@selector(requestSuccess:)];
        [self.httpRequest setNumberOfTimesToRetryOnTimeout:2];
        [self.httpRequest startAsynchronous];
         
        //        [self.interviews.view addSubview:[MyProgressHud getInstance]];
        
        
    }else if (type == kRequestTypeGetQsParse)
    {
        urlString = @"https://api.parse.com/1/classes/QIUSHI";
        _httpRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
        [_httpRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        [_httpRequest addRequestHeader:@"Accept" value:@"application/json"];
        [_httpRequest addRequestHeader:@"X-Parse-Application-Id" value:kParseApplicationId];
        [_httpRequest addRequestHeader:@"X-Parse-REST-API-Key" value:kParseREST];
        [self.httpRequest setTag:type];
        [self.httpRequest setDelegate:self];
        [self.httpRequest setDidFailSelector:@selector(requestFail:)];
        [self.httpRequest setDidFinishSelector:@selector(requestSuccess:)];
        [self.httpRequest setNumberOfTimesToRetryOnTimeout:2];
        [self.httpRequest startAsynchronous];
    }
    

    
    DLog(@"%@",urlString);
    
    
}





- (void) requestSuccess:(ASIHTTPRequest *)request
{
    
    DLog(@"RequestSuccess");
    
    [MyProgressHud remove];
    NSString *responseString = [request responseString];
//    DLog(@"%@",responseString);
    
    
    NSMutableDictionary *resultDic;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"version"] isEqualToString:@">=5"] ) {
        resultDic = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUnicodeStringEncoding]
                                                    options:NSJSONReadingMutableLeaves error:nil];
    }else {
        resultDic = [responseString JSONValue];
    }
 
    if (request.tag == kRequestTypeGetQiushi
        || request.tag == kRequestTypeGetComment)
    {
        
        [self.delegate refreshDate1:resultDic data2:nil withType:[request tag]];
    }
    
}


- (void) requestFail:(ASIHTTPRequest *)request
{
    DLog(@"RequestFail");

    [MyProgressHud remove];

    if (request.tag == kRequestTypeGetQiushi
        || request.tag == kRequestTypeGetComment)
    {
        [self.delegate refreshDate1:nil data2:nil withType:[request tag]];
    }





    NSError *error = [request error];


    DLog(@"-------------------------------\n");
    DLog(@"error:%@",error);

    NSString *temp = [NSString stringWithFormat:@"%@",error];
    NSString *jap = @"timed out";
    NSRange foundObj=[temp rangeOfString:jap options:NSCaseInsensitiveSearch];
    if(foundObj.length>0)
    {
        [[iToast makeText:NSLocalizedString(@"网络连接超时,请稍后再试","网络连接超时,请稍后再试")] show];
        return;
    }

#ifdef DEBUG
    NSString *responseString = [request responseString];
    DLog(@"%@\n",responseString);
#endif




}

@end
