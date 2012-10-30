//
//  SqliteUtil.h
//  NetDemo
//
//  Created by xyxd mac on 12-8-17.
//
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>
@class QiuShi;

@interface SqliteUtil : NSObject
{
    
    
    
}

+ (void)initDb;
+ (void)saveDb:(QiuShi*)qs;
+ (NSMutableArray*)queryDbAll;//查询所有数据
+ (NSString*)processString:(NSString*)str;

+ (BOOL)delAll;//删除所有数据（删除表）
+ (BOOL)delNoSave;//删除未收藏的
+ (NSMutableArray*)queryDbIsSave;//查询收藏的
+ (BOOL) updateDataIsFavourite:(NSString *)qiushiid isFavourite:(NSString*)isSave;//更新收藏的 状态
+ (void)saveDbWithArray:(NSMutableArray*)qsArray;
+ (int)queryTopId;
+ (BOOL)autoDelNoSave;
+ (NSMutableArray*)queryDbTop;//查询最新的100条
+ (BOOL) deleteData:(NSString*)qiushiid;
+ (NSMutableDictionary*)queryDbGroupByData;
+ (NSMutableArray*)queryDbByDate:(NSString *)date;
+ (BOOL)delCacheByDate:(NSString*)date;//删除某一天的
+ (void)saveCommentWithArray:(NSMutableArray*)commentArray;//保存评论
+ (NSMutableArray*)queryCommentsById:(NSString*)qiushiId;
+ (NSMutableArray*)queryComments;
+ (BOOL)delCacheCommentsByDate:(NSString*)date;
+ (BOOL)delCacheCommentsByQiushiid:(NSString*)mid;
+ (BOOL)delAllComments;
@end
