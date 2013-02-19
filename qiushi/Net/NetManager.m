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


- (void) requestWithURL:(NSString*)urlString withType:(RequestTypeTag)type withDictionary:(NSMutableDictionary*)dic withDelegate:(id<RefreshDateNetDelegate>)delegate
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
        [self.httpRequest setNumberOfTimesToRetryOnTimeout:2];
        NSMutableDictionary *userInfo = [NSMutableDictionary new];
        [userInfo setObject:delegate forKey:@"delegate"];
        _httpRequest.userInfo = userInfo;
        [self.httpRequest startAsynchronous];
         
   
        
        
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
        [self.httpRequest setNumberOfTimesToRetryOnTimeout:2];
        NSMutableDictionary *userInfo = [NSMutableDictionary new];
        [userInfo setObject:delegate forKey:@"delegate"];
        _httpRequest.userInfo = userInfo;
        [self.httpRequest startAsynchronous];
    }else if (type == kRequestTypeLogin)
    {
        urlString = @"http://m2.qiushibaike.com/user/signin";
        _formRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
        [_formRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        [_formRequest addRequestHeader:@"Accept" value:@"application/json"];
        [self.formRequest setTag:type];
        [self.formRequest setDelegate:self];
        [self.formRequest setNumberOfTimesToRetryOnTimeout:2];
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:delegate forKey:@"delegate"];
        _formRequest.userInfo = userInfo;
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"version"] isEqualToString:@">=5"] ) {
            NSError* error;
            [self.formRequest appendPostData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error]];
        }else {
            [self.formRequest appendPostData:[[dic JSONFragment] dataUsingEncoding: NSUTF8StringEncoding]];
        }
        
        [self.formRequest startAsynchronous];
    }else if (type == kRequestTypeCreate)
    {
        urlString = @"http://m2.qiushibaike.com/article/create";
        _formRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
        [_formRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        [_formRequest addRequestHeader:@"Accept" value:@"application/json"];
        [self.formRequest setTag:type];
        [self.formRequest setDelegate:self];
        [self.formRequest setNumberOfTimesToRetryOnTimeout:2];
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:delegate forKey:@"delegate"];
        _formRequest.userInfo = userInfo;
        
//        {"content":"fdfhffhh","anonymous":true,"allow_comment":1}
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"version"] isEqualToString:@">=5"] ) {
            NSError* error;
            [self.formRequest appendPostData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error]];
        }else {
            [self.formRequest appendPostData:[[dic JSONFragment] dataUsingEncoding: NSUTF8StringEncoding]];
        }
        
        [self.formRequest startAsynchronous];
    }

    

    
    DLog(@"%@",urlString);
    
    
}





- (void)requestFinished:(ASIHTTPRequest *)request
{

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
        
        [[request.userInfo objectForKey:@"delegate"] refreshDate1:resultDic data2:nil withType:[request tag] isOk:YES];
    }else if (request.tag == kRequestTypeLogin)//登录
    {

        NSString *err_msg = [resultDic objectForKey:@"err_msg"];
        if (err_msg == nil) {
            [[request.userInfo objectForKey:@"delegate"] refreshDate1:resultDic data2:nil withType:[request tag] isOk:YES];
        }else {
            [[request.userInfo objectForKey:@"delegate"] refreshDate1:resultDic data2:nil withType:[request tag] isOk:NO];
        }
    
    }
    
}


- (void) requestFailed:(ASIHTTPRequest *)request
{
    DLog(@"RequestFail,%d",request.tag);

  
//    if (request.tag == kRequestTypeGetQiushi
//        || request.tag == kRequestTypeGetComment)
//    {
        [[request.userInfo objectForKey:@"delegate"] refreshDate1:nil data2:nil withType:[request tag] isOk:NO];
//    }





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
