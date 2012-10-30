//
//  Comments.h
//  NetDemo
//
//  Created by Michael  on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comments : NSObject
{
    //楼层
    int floor;
    //内容
    NSString *content;
    //作者
    NSString *anchor;
    //糗事评论id
    NSString *commentsID;
    //糗事id
    NSString *qsId;
    //db创建日期（为了删除）
    NSString *createTime;
}
@property (nonatomic,assign) int floor;
@property (nonatomic,copy) NSString *commentsID;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *anchor;
@property (nonatomic,copy) NSString *qsId;
@property (nonatomic,copy) NSString *createTime;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
