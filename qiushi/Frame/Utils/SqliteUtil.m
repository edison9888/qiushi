//
//  SqliteUtil.m
//  NetDemo
//
//  Created by xyxd mac on 12-8-17.
//
//
//目前sqlite3版本能识别外键，但不支持 级联删除

#import "SqliteUtil.h"

#import "QiuShi.h"
#import "Comments.h"
#import <Parse/Parse.h>


@implementation SqliteUtil

static sqlite3 *qiushiDB;
static NSString *databasePath;
static NSArray *dirPaths;

#define kVersion    1210301457
#define kTableQiushis   @"QIUSHIS"
#define kTableComments  @"QIUSHICOMMENTS"


+(void) initDb
{
    
    /*根据路径创建数据库并创建一个表contact(id nametext addresstext phonetext)*/
    
    NSString *docsDir;
    
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //"/var/mobile/Applications/BA5FF18A-440B-4C0E-ABEB-977E9F1B79CA/Documents"
    docsDir = [dirPaths objectAtIndex:0];
    ///var/mobile/Applications/BA5FF18A-440B-4C0E-ABEB-977E9F1B79CA/Documents
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"qiushis.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath:databasePath] == NO)
    {
        
    }else
    {
        
        DLog(@"数据库已存在");
    }
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &qiushiDB)==SQLITE_OK)
    {
        char *errMsg;
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        int version = [[ud objectForKey:@"mSqlVersion"] intValue];
        if (kVersion > version) {
            
           
            
            const char *sql_stmt = "DROP  TABLE  IF  EXISTS  QIUSHIS";
            
            if (sqlite3_exec(qiushiDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
            {
                
                DLog(@"删除qiushi表失败,%s",sqlite3_errmsg(qiushiDB));
                
            }
            
            const char *sql_stmt1 = "DROP  TABLE  IF  EXISTS  QIUSHIComments";
            
            if (sqlite3_exec(qiushiDB, sql_stmt1, NULL, NULL, &errMsg)!=SQLITE_OK)
            {
                
                DLog(@"创建comment表失败,%s",sqlite3_errmsg(qiushiDB));
                
            }
            
           

        }
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS QIUSHIS(ID INTEGER PRIMARY KEY AUTOINCREMENT, QIUSHIID TEXT unique,IMAGEURL TEXT,IMAGEMIDURL TEXT,TAG TEXT, CONTENT TEXT,COMMENTSCOUNT TEXT,UPCOUNT TEXT,DOWNCOUNT TEXT,ANCHOR TEXT,FBTIME TEXT,isSave text)";
        
        if (sqlite3_exec(qiushiDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
        {
            
            DLog(@"创建主表失败,%s",sqlite3_errmsg(qiushiDB));
            
        }
        
        const char *sql_stmt1 = "CREATE TABLE IF NOT EXISTS QIUSHIComments(ID INTEGER PRIMARY KEY AUTOINCREMENT, QIUSHIID TEXT,commentId text unique,floor text,content text,anchor text,createTime text, FOREIGN KEY (QIUSHIID) REFERENCES QIUSHIS (QIUSHIID) on delete cascade) ";//外键约束无效
        
        if (sqlite3_exec(qiushiDB, sql_stmt1, NULL, NULL, &errMsg)!=SQLITE_OK)
        {
            
            DLog(@"创建评论表失败,%s",sqlite3_errmsg(qiushiDB));
            
        }
        
        
        [ud setObject:[NSNumber numberWithInt:kVersion]  forKey:@"mSqlVersion"];
    }
    else
    {
        
        
        DLog(@"创建/打开数据库失败,%s",sqlite3_errmsg(qiushiDB));
    }
    
}

+ (void)saveDb:(QiuShi*)qs
{
    
    sqlite3_stmt *statement;
    
    
    //    NSLog(@"%@",databasePath);
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &qiushiDB)==SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO QIUSHIS (qiushiid,imageurl,imagemidurl,tag,content,commentscount,upcount,downcount,anchor,fbtime,isSave) VALUES( \"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",'no')",qs.qiushiID,qs.imageURL,qs.imageMidURL,qs.tag,qs.content,[NSString stringWithFormat:@"%d",qs.commentsCount],[NSString stringWithFormat:@"%d",qs.upCount],[NSString stringWithFormat:@"%d",qs.downCount],qs.anchor,qs.fbTime];
        
        NSLog(@"fbTime:%@",qs.fbTime);
        
        
        //        DLog(@"%@",insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(qiushiDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement)==SQLITE_DONE) {
            
            //            DLog(@"已存储到数据库");
            
        }
        else
        {
            DLog(@"保存失败:%s",sqlite3_errmsg(qiushiDB));
            
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(qiushiDB);
    }
}

+ (void)saveDbWithArray:(NSMutableArray*)qsArray
{
    
    sqlite3_stmt *statement;
    
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &qiushiDB)==SQLITE_OK) {
        for (int i = 0; i < qsArray.count; i++) {
            QiuShi *qs = [qsArray objectAtIndex:i];
            
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO QIUSHIS (qiushiid,imageurl,imagemidurl,tag,content,commentscount,upcount,downcount,anchor,fbtime,isSave) VALUES( \"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",'no')",qs.qiushiID,qs.imageURL,qs.imageMidURL,qs.tag,qs.content,[NSString stringWithFormat:@"%d",qs.commentsCount],[NSString stringWithFormat:@"%d",qs.upCount],[NSString stringWithFormat:@"%d",qs.downCount],qs.anchor,qs.fbTime];
            
            
            //        DLog(@"%@",insertSQL);
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(qiushiDB, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement)==SQLITE_DONE) {
                
                DLog(@"已存储到数据库");
                
                
                
                
//                PFObject *qsObject = [PFObject objectWithClassName:@"QIUSHI"];
//                [qsObject setObject:qs.qiushiID forKey:@"qiushiid"];
//                [qsObject setObject:[NSString stringWithFormat:@"%@",qs.imageURL] forKey:@"imageurl"];
//                [qsObject setObject:[NSString stringWithFormat:@"%@",qs.imageMidURL] forKey:@"imagemidurl"];
//                [qsObject setObject:[NSString stringWithFormat:@"%@",qs.tag] forKey:@"tag"];
//                [qsObject setObject:[NSString stringWithFormat:@"%@",qs.content] forKey:@"content"];
//                [qsObject setObject:[NSString stringWithFormat:@"%d",qs.commentsCount] forKey:@"commentscount"];
//                [qsObject setObject:[NSString stringWithFormat:@"%d",qs.upCount] forKey:@"upcount"];
//                [qsObject setObject:[NSString stringWithFormat:@"%d",qs.downCount] forKey:@"downcount"];
//                [qsObject setObject:[NSString stringWithFormat:@"%@",qs.anchor] forKey:@"anchor"];
//                [qsObject setObject:[NSString stringWithFormat:@"%@",qs.fbTime] forKey:@"fbtime"];
//
//                [qsObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                    if (succeeded) {
//                        
//                        NSLog(@"QIUSHI save success");
//                    } else {
//                        NSLog(@"QIUSHI save  fail");
//                    }
//                    
//                }];
                

                
                
                
                
            }
            else
            {
                DLog(@"保存失败:%s",sqlite3_errmsg(qiushiDB));
                //
                
            }
            //这个过程销毁前面被sqlite3_prepare创建的准备语句，每个准备语句都必须使用这个函数去销毁以防止内存泄露。
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(qiushiDB);
    }
}

#pragma mark - 查询 所有 qiushi
+ (NSMutableArray*)queryDbAll
{
    
    
    
    NSMutableArray *selectArray = [[NSMutableArray alloc]init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT  * from QIUSHIS order by id desc"];
        
        
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(qiushiDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                
                NSLog(@"已查到结果");
                
                
                QiuShi *qs;
                do {
                    qs = [[QiuShi alloc]init];
                    qs.qiushiID = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 1)]];
                    
                    qs.imageURL = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 2)]];
                    qs.imageMidURL = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 3)]];
                    qs.tag = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 4)]];
                    qs.content = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 5)]];
                    qs.commentsCount = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 6)] intValue];
                    qs.upCount = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 7)] intValue];
                    qs.downCount = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 8)] intValue];
                    qs.anchor = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 9)]];
                    qs.fbTime = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 10)]];
                    
                    [selectArray addObject:qs];
                } while (sqlite3_step(statement) == SQLITE_ROW);
                
                
            }
            else {
                
                DLog(@"查询出错:%s",sqlite3_errmsg(qiushiDB));
                
                
                
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(qiushiDB);
    }
    
    if (selectArray.count > 0) {
        
        return selectArray;
    }
    return nil;
}

#pragma mark - 查询 最新100条 qiushi
+ (NSMutableArray*)queryDbTop//查询最新的100条
{
    
    
    
    NSMutableArray *selectArray = [[NSMutableArray alloc]init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT  * from QIUSHIS order by id desc limit 100 OFFSET 0"];
        
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(qiushiDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                
                NSLog(@"已查到结果");
                
                
                QiuShi *qs;
                do {
                    qs = [[QiuShi alloc]init];
                    qs.qiushiID = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 1)]];
                    qs.imageURL = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 2)]];
                    qs.imageMidURL = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 3)]];
                    qs.tag = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 4)]];
                    qs.content = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 5)]];
                    qs.commentsCount = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 6)] intValue];
                    qs.upCount = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 7)] intValue];
                    qs.downCount = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 8)] intValue];
                    qs.anchor = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 9)]];
                    qs.fbTime = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 10)]];
                    
                    [selectArray addObject:qs];
                } while (sqlite3_step(statement) == SQLITE_ROW);
                
                
            }
            else {
                
                
                DLog(@"查询出错:%s",sqlite3_errmsg(qiushiDB));
                
                
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(qiushiDB);
    }
    
    if (selectArray.count > 0) {
        
        
        return selectArray;
    }
    return nil;
}


+ (NSString*)processString:(NSString*)str
{
    if (str == nil || [str isEqualToString:@""] || [str isEqualToString:@"(null)"]) {
        return @"";
    }else{
        return str;
    }
}





+ (BOOL) deleteData:(NSString*)qiushiid
{
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *deleteSqlStr = [NSString stringWithFormat:@"delete from QIUSHIS where QIUSHIID='%@'",qiushiid];
        
        
        
        
        const char *deleteSql  = [deleteSqlStr UTF8String];
        int deleteSqlOk = sqlite3_prepare_v2(qiushiDB, deleteSql, -1, &statement, nil);
        if (deleteSqlOk != SQLITE_OK) {
            
            NSLog(@"Error:%s",sqlite3_errmsg(qiushiDB));
            
            
            //            printf("---------- delete sql is error!-------------\r\n");
            sqlite3_close(qiushiDB);
            return NO;
        }
        
        sqlite3_bind_text(statement, 1, [qiushiid UTF8String], -1, SQLITE_TRANSIENT);
        
        int execDeleteSqlOk = sqlite3_step(statement);
        sqlite3_finalize(statement);
        
        if (execDeleteSqlOk == SQLITE_ERROR) {
            sqlite3_close(qiushiDB);
            return NO;
        }
        
    }
    //    printf("----------delete data t_Infor Database is OK!-------------\r\n");
    sqlite3_close(qiushiDB);
    return YES;
}


+ (BOOL)delAll
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *deleteSqlStr = [NSString stringWithFormat:@"drop table qiushis"];
        
        
        
        
        const char *deleteSql  = [deleteSqlStr UTF8String];
        int deleteSqlOk = sqlite3_prepare_v2(qiushiDB, deleteSql, -1, &statement, nil);
        if (deleteSqlOk != SQLITE_OK) {
            
            
            
            DLog(@"删除出错:%s",sqlite3_errmsg(qiushiDB));
            
            
            sqlite3_close(qiushiDB);
            return NO;
        }
        
        
        int execDeleteSqlOk = sqlite3_step(statement);
        sqlite3_finalize(statement);
        
        if (execDeleteSqlOk == SQLITE_ERROR) {
            sqlite3_close(qiushiDB);
            return NO;
        }
        
    }
    DLog(@"删除成功");
    
    sqlite3_close(qiushiDB);
    return YES;
    
}

+ (BOOL)delNoSave
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *deleteSqlStr = [NSString stringWithFormat:@"delete from QIUSHIS where issave='no'"];
        
        const char *deleteSql  = [deleteSqlStr UTF8String];
        int deleteSqlOk = sqlite3_prepare_v2(qiushiDB, deleteSql, -1, &statement, nil);
        if (deleteSqlOk != SQLITE_OK) {
            
            
            DLog(@"删除出错:%s",sqlite3_errmsg(qiushiDB));
            
            
            sqlite3_close(qiushiDB);
            return NO;
        }
        
        
        int execDeleteSqlOk = sqlite3_step(statement);
        sqlite3_finalize(statement);
        
        if (execDeleteSqlOk == SQLITE_ERROR) {
            sqlite3_close(qiushiDB);
            return NO;
        }
        
    }
    DLog(@"删除成功");
    
    sqlite3_close(qiushiDB);
    return YES;
    
}


+ (NSMutableArray*)queryDbIsSave
{
    
    
    NSMutableArray *selectArray = [[NSMutableArray alloc]init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT  * from QIUSHIS where issave='yes' order by upcount desc"];
        //本打算按 upcount 降序排序，但是string类型，所以 是 乱序了，
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(qiushiDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                
                NSLog(@"已查到结果");
                
                
                QiuShi *qs;
                do {
                    qs = [[QiuShi alloc]init];
                    qs.qiushiID = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 1)]];
                    qs.imageURL = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 2)]];
                    qs.imageMidURL = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 3)]];
                    qs.tag = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 4)]];
                    qs.content = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 5)]];
                    qs.commentsCount = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 6)] intValue];
                    qs.upCount = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 7)] intValue];
                    qs.downCount = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 8)] intValue];
                    qs.anchor = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 9)]];
                    qs.fbTime = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 10)]];
                    
                    
                    [selectArray addObject:qs];
                    
                } while (sqlite3_step(statement) == SQLITE_ROW);
                
            }else {
                
                DLog(@"查询出错:%s",sqlite3_errmsg(qiushiDB));
                
                
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(qiushiDB);
    }
    
    if (selectArray.count > 0) {
        
        
        DLog(@"查到%d条数据",selectArray.count);
        
        
        return selectArray;
    }
    return nil;
}


+ (BOOL)queryDbById:(NSString*)qiushiid
{
    BOOL isExist = NO;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT  * from QIUSHIS where QIUSHIID='%@'",qiushiid];
        
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(qiushiDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                
                DLog(@"已查到结果");
                
                isExist = YES;
                
            }
            else {
                DLog(@"查询出错:%s",sqlite3_errmsg(qiushiDB));
                
                isExist = NO;
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(qiushiDB);
    }
    
    
    return isExist;
}

+ (int)queryTopId
{
    
    int id_i = 0;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT  id from QIUSHIS limit 1 offset 10"];
        
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(qiushiDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                id_i = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)] intValue];
                DLog(@"已查到结果,%d",id_i);
                
            }
            else {
                DLog(@"查询出错:%s",sqlite3_errmsg(qiushiDB));
                
                
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(qiushiDB);
    }
    
    
    return id_i;
}



+ (BOOL)autoDelNoSave
{
    int topId = [self queryTopId];
    if (topId <= 0) {
        return NO;
    }
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *deleteSqlStr = [NSString stringWithFormat:@"delete from QIUSHIS where issave='no' and id<%d",topId];
        
        const char *deleteSql  = [deleteSqlStr UTF8String];
        int deleteSqlOk = sqlite3_prepare_v2(qiushiDB, deleteSql, -1, &statement, nil);
        if (deleteSqlOk != SQLITE_OK) {
            
            
            DLog(@"删除出错:%s",sqlite3_errmsg(qiushiDB));
            
            
            sqlite3_close(qiushiDB);
            return NO;
        }
        
        
        int execDeleteSqlOk = sqlite3_step(statement);
        sqlite3_finalize(statement);
        
        if (execDeleteSqlOk == SQLITE_ERROR) {
            sqlite3_close(qiushiDB);
            return NO;
        }
        
    }
    
    DLog(@"自动删除成功");
    sqlite3_close(qiushiDB);
    return YES;
    
}


//===========update data=================
+ (BOOL) updateDataIsFavourite:(NSString *)qiushiid isFavourite:(NSString*)isSave
{
    
    BOOL updateOK = NO;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *updateSqlStr = [NSString stringWithFormat:@"UPDATE qiushis SET issave=? WHERE qiushiid=='%@'",qiushiid];
        
        
        const char *query_stmt = [updateSqlStr UTF8String];
        if (sqlite3_prepare_v2(qiushiDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_text(statement, 1, [isSave UTF8String], -1, SQLITE_TRANSIENT);
            
            
            int execUpdateSqlOk = sqlite3_step(statement);
            sqlite3_finalize(statement);
            
            if (execUpdateSqlOk == SQLITE_ERROR) {
                DLog(@"更新出错:%s",sqlite3_errmsg(qiushiDB));
                sqlite3_close(qiushiDB);
                updateOK = NO;
            }else{
                DLog(@"已更新");
                updateOK = YES;
            }
            
            
        }else{
            updateOK = NO;
            DLog(@"更新出错:%s",sqlite3_errmsg(qiushiDB));
        }
        
        sqlite3_close(qiushiDB);
    }
    
    return updateOK;
    
    
}


#pragma mark - 获取缓存 1/2:获取缓存列表
+ (NSMutableArray*)queryDbGroupByData
{
    
    NSMutableArray *temArray = [[NSMutableArray alloc]init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT  FBTime,count(id) from QIUSHIS group by FBTIME order by FBTime desc"];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(qiushiDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                
                do {
                    NSString *mKey = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 0)]];
                    char *field1 = (char *)sqlite3_column_text(statement, 1);
                    int mValue = field1 ? [[[NSString alloc] initWithUTF8String:field1] intValue] : 0;
                    
                    NSMutableDictionary *temDic = [[NSMutableDictionary alloc]init];
                    [temDic setObject:[NSNumber numberWithInt:mValue] forKey:mKey];
                    [temArray addObject:temDic];
                } while (sqlite3_step(statement) == SQLITE_ROW);
                
                
            }else
            {
                
                DLog(@"查询出错:%s",sqlite3_errmsg(qiushiDB));
                
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(qiushiDB);
    }
    
    if (temArray.count > 0) {
        
        return temArray;
    }
    return nil;
}


#pragma mark - 获取缓存 2/2:获取某一天的缓存
+ (NSMutableArray*)queryDbByDate:(NSString *)date
{
    
    NSMutableArray *selectArray = [[NSMutableArray alloc]init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT  * from QIUSHIS where fbtime ='%@' order by id desc",date];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(qiushiDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSLog(@"已查到结果");
                
                QiuShi *qs;
                do {
                    qs = [[QiuShi alloc]init];
                    qs.qiushiID = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 1)]];
                    
                    qs.imageURL = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 2)]];
                    qs.imageMidURL = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 3)]];
                    qs.tag = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 4)]];
                    qs.content = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 5)]];
                    qs.commentsCount = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 6)] intValue];
                    qs.upCount = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 7)] intValue];
                    qs.downCount = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 8)] intValue];
                    qs.anchor = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 9)]];
                    qs.fbTime = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 10)]];
                    
                    [selectArray addObject:qs];
                } while (sqlite3_step(statement) == SQLITE_ROW);
                
                
            }else
            {
                
                DLog(@"查询出错:%s",sqlite3_errmsg(qiushiDB));
                
                
                
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(qiushiDB);
    }
    
    if (selectArray.count > 0) {
        
        return selectArray;
    }
    return nil;
}

+ (BOOL)delCacheByDate:(NSString*)date
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *deleteSqlStr = [NSString stringWithFormat:@"delete from QIUSHIS where issave='no' and fbtime = '%@'",date];
        
        const char *deleteSql  = [deleteSqlStr UTF8String];
        int deleteSqlOk = sqlite3_prepare_v2(qiushiDB, deleteSql, -1, &statement, nil);
        if (deleteSqlOk != SQLITE_OK) {
            
            
            DLog(@"删除出错:%s",sqlite3_errmsg(qiushiDB));
            
            
            sqlite3_close(qiushiDB);
            return NO;
        }
        
        
        int execDeleteSqlOk = sqlite3_step(statement);
        sqlite3_finalize(statement);
        
        if (execDeleteSqlOk == SQLITE_ERROR) {
            sqlite3_close(qiushiDB);
            return NO;
        }
        
    }
    DLog(@"删除成功");
    
    sqlite3_close(qiushiDB);
    return YES;
    
}


+ (void)saveCommentWithArray:(NSMutableArray*)commentArray
{
    
    sqlite3_stmt *statement;
    
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &qiushiDB)==SQLITE_OK) {
        for (int i = 0; i < commentArray.count; i++) {
            Comments *comment = [commentArray objectAtIndex:i];
            
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO QIUSHIComments (QIUSHIID,commentid,floor,content,anchor,createTime) VALUES( \"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",
                                   comment.qsId,
                                   comment.commentsID,
                                   [NSString stringWithFormat:@"%d",comment.floor],
                                   comment.content,
                                   comment.anchor,
                                   comment.createTime];
            
            
            //        DLog(@"%@",insertSQL);
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(qiushiDB, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement)==SQLITE_DONE) {
                
                DLog(@"comments已存储到数据库");
                
            }
            else
            {
                DLog(@"comments保存失败:%s",sqlite3_errmsg(qiushiDB));
                
            }
            //这个过程销毁前面被sqlite3_prepare创建的准备语句，每个准备语句都必须使用这个函数去销毁以防止内存泄露。
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(qiushiDB);
    }
}


+ (NSMutableArray*)queryCommentsById:(NSString*)qiushiId
{
    
    NSMutableArray *selectArray = [[NSMutableArray alloc]init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT  * from QIUSHIComments where QIUSHIID = '%@'",qiushiId];
        
        DLog(@"%@",querySQL);
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(qiushiDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                
                NSLog(@"已查到结果");
                Comments *comment;
                do {
                    comment = [[Comments alloc]init];
                    comment.commentsID = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 2)]];
                    comment.floor = [[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 3)] intValue];
                    comment.content = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 4)]];
                    comment.anchor = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 5)]];
                    
                    [selectArray addObject:comment];
                } while (sqlite3_step(statement) == SQLITE_ROW);
                
                
            }
            else {
                
                
                DLog(@"查询出错:%s",sqlite3_errmsg(qiushiDB));
                
                
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(qiushiDB);
    }
    
    if (selectArray.count > 0) {
        
        DLog(@"comment:%d条",selectArray.count);
        
        return selectArray;
    }
    return nil;
}

+ (NSMutableArray*)queryComments
{
    
    NSMutableArray *selectArray = [[NSMutableArray alloc]init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT  * from QIUSHIComments"];
        
        DLog(@"%@",querySQL);
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(qiushiDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                
                NSLog(@"已查到结果");
                Comments *comment;
                do {
                    comment = [[Comments alloc]init];
                    comment.commentsID = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 2)]];
                    comment.floor = [[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 3)] intValue];
                    comment.content = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 4)]];
                    comment.anchor = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 5)]];
                    
                    [selectArray addObject:comment];
                } while (sqlite3_step(statement) == SQLITE_ROW);
                
                
            }
            else {
                
                
                DLog(@"查询出错:%s",sqlite3_errmsg(qiushiDB));
                
                
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(qiushiDB);
    }
    
    if (selectArray.count > 0) {
        
        DLog(@"comment:%d条",selectArray.count);
        
        return selectArray;
    }
    return nil;
}

#pragma mark - 删除 某一天的 评论
+ (BOOL)delCacheCommentsByDate:(NSString*)date
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *deleteSqlStr = [NSString stringWithFormat:@"delete from QIUSHIComments where createTime = '%@'",date];
        
        const char *deleteSql  = [deleteSqlStr UTF8String];
        int deleteSqlOk = sqlite3_prepare_v2(qiushiDB, deleteSql, -1, &statement, nil);
        if (deleteSqlOk != SQLITE_OK) {
            
            
            DLog(@"删除出错:%s",sqlite3_errmsg(qiushiDB));
            
            
            sqlite3_close(qiushiDB);
            return NO;
        }
        
        
        int execDeleteSqlOk = sqlite3_step(statement);
        sqlite3_finalize(statement);
        
        if (execDeleteSqlOk == SQLITE_ERROR) {
            sqlite3_close(qiushiDB);
            return NO;
        }
        
    }
    DLog(@"删除成功");
    
    sqlite3_close(qiushiDB);
    return YES;
    
}


#pragma mark - 删除 某一qiushi的 评论
+ (BOOL)delCacheCommentsByQiushiid:(NSString*)mid
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *deleteSqlStr = [NSString stringWithFormat:@"delete from QIUSHIComments where QIUSHIID = '%@'",mid];
        
        const char *deleteSql  = [deleteSqlStr UTF8String];
        int deleteSqlOk = sqlite3_prepare_v2(qiushiDB, deleteSql, -1, &statement, nil);
        if (deleteSqlOk != SQLITE_OK) {
            
            
            DLog(@"删除出错:%s",sqlite3_errmsg(qiushiDB));
            
            
            sqlite3_close(qiushiDB);
            return NO;
        }
        
        
        int execDeleteSqlOk = sqlite3_step(statement);
        sqlite3_finalize(statement);
        
        if (execDeleteSqlOk == SQLITE_ERROR) {
            sqlite3_close(qiushiDB);
            return NO;
        }
        
    }
    DLog(@"删除成功");
    
    sqlite3_close(qiushiDB);
    return YES;
    
}

#pragma mark - 删除 所有 评论
+ (BOOL)delAllComments
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *deleteSqlStr = [NSString stringWithFormat:@"delete from %@",kTableComments];
        
        const char *deleteSql  = [deleteSqlStr UTF8String];
        int deleteSqlOk = sqlite3_prepare_v2(qiushiDB, deleteSql, -1, &statement, nil);
        if (deleteSqlOk != SQLITE_OK) {
            
            
            DLog(@"删除出错:%s",sqlite3_errmsg(qiushiDB));
            
            
            sqlite3_close(qiushiDB);
            return NO;
        }
        
        
        int execDeleteSqlOk = sqlite3_step(statement);
        sqlite3_finalize(statement);
        
        if (execDeleteSqlOk == SQLITE_ERROR) {
            sqlite3_close(qiushiDB);
            return NO;
        }
        
    }
    DLog(@"删除成功");
    
    sqlite3_close(qiushiDB);
    return YES;
    
}

@end


//iphone  sqlite3 数据的增添，删除，查找，修改
//
//
//
//希望对大家有用，学习了就帮我顶顶啊
//比较充忙没有对每行代码写注释
////  Created by hhy on 12-4-18.
////  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
////
//
//
//
//
//#import "hhySqlite.h"
//
//
//@implementation hhySqlite
//
//
//@synthesize hhySqlite;
//
//
////=========database file path==================
//- (NSString *)DatabaseFilePath{
//
//    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"hhyDB.sql"];
//
//    //    NSBundle *boudle = [NSBundle mainBundle];
//    //    NSString *databasePath = [boudle pathForResource:@"hhyDB" ofType:@"sql"];
//
//
//    return databasePath;
//}
//
//
////=========open database========================
//- (BOOL) openDatabase{
//    NSString *DBPath = [self DatabaseFilePath];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL isFile = [fileManager fileExistsAtPath:DBPath];
//    //the databse is existed=======
//    if (isFile) {
//        printf("----------the databse is existed!-------------\r\n");
//        if (sqlite3_open([DBPath UTF8String], & hhySqlite) != SQLITE_OK) {
//            sqlite3_close(hhySqlite);
//            printf("----------the databse is open fail!-------------\r\n");
//            return NO;
//        }
//        else{
//            printf("----------the databse is open OK!-------------\r\n");
//            return YES;
//
//
//        }
//    }
//    //the database is not exited====
//    else{
//        printf("----------the databse is not existed!-------------\r\n");
//
//
//        if (sqlite3_open([DBPath UTF8String], &hhySqlite) == SQLITE_OK) {
//            printf("----------the databse is open OK!-------------\r\n");
//            return YES;
//        }
//        else{
//            printf("----------the databse is open fail!-------------\r\n");
//            sqlite3_close(hhySqlite);
//            return NO;
//        }
//    }
//    return NO;
//}
//
//
////========create tables=================
//- (BOOL) createTable:(sqlite3 *)nationalDB{
//    char *Infor_sql = "CREATE TABLE IF NOT EXISTS t_Infor(ID INTEGER PRIMARY KEY AUTOINCREMENT,UUIDName text,UUID text,deviceName text, peripheralInfo text)";
//
//    sqlite3_stmt *statement;
//    NSInteger SqlOK = sqlite3_prepare_v2(hhySqlite, Infor_sql, -1, &statement, nil);
//
//    if (SqlOK != SQLITE_OK) {
//        printf("----------create table sql is error!-------------\r\n");
//        return NO;
//    }
//
//    int sqlCorrect = sqlite3_step(statement);
//    sqlite3_finalize(statement);
//
//    if (sqlCorrect != SQLITE_DONE) {
//        printf("----------failed to create table!-------------\r\n");
//        return NO;
//    }
//    printf("----------create table t_Infor is OK!-------------\r\n");
//    return YES;
//}
//
//
////=========insert some data=============
//- (BOOL) insertData:(NSString *)tableName UUIDName:(NSString *)uuidName UUID:(NSString *)uuid DeviceName:(NSString *)deviceName PeripheralInfo:(NSString *)peripheralInfo {
//    if ([self openDatabase]) {
//
//        sqlite3_stmt *statement;
//        NSString *insertSqlStr = [NSString stringWithFormat:@"INSERT INTO '%@'(UUIDName,UUID,deviceName,peripheralInfo) VALUES (?,?,?,?)",tableName];
//        c*****t char *insertSql = [insertSqlStr UTF8String];
//        int insertSqlOK = sqlite3_prepare_v2(hhySqlite, insertSql, -1, &statement, nil);
//        if (insertSqlOK != SQLITE_OK) {
//            printf("---------- insert sql is error!-------------\r\n");
//            sqlite3_close(hhySqlite);
//            return NO;
//        }
//
//        sqlite3_bind_text(statement, 1, [uuidName       UTF8String], -1, nil);
//        sqlite3_bind_text(statement, 2, [uuid           UTF8String], -1, nil);
//        sqlite3_bind_text(statement, 3, [deviceName     UTF8String], -1, nil);
//        sqlite3_bind_text(statement, 4, [peripheralInfo UTF8String], -1, nil);
//
//        int execInsertSqlOK = sqlite3_step(statement);
//        sqlite3_finalize(statement);
//
//        if (execInsertSqlOK ==SQLITE_ERROR) {
//            printf("----------failed to insert data into t_Infor Database!-------------\r\n");
//            sqlite3_close(hhySqlite);
//            return  NO;
//        }
//    }
//    printf("----------insert data into t_Infor Database is OK!-------------\r\n");
//    sqlite3_close(hhySqlite);
//    return YES;
//}
//
//
////===========update data=================
//- (BOOL) updateData:(NSString *)tableName UUIDName:(NSString *)uuidName UUID:(NSString *)uuid DeviceName:(NSString *)deviceName PeripheralInfo:(NSString *)peripheralInfo {
//
//
//    if ([self openDatabase]) {
//        sqlite3_stmt *statement = nil;
//        NSString *updateSqlStr = [NSString stringWithFormat:@"UPDATE '%@' SET uuidName=?,deviceName=?,peripheralInfo=? WHERE uuid=='%@'",tableName,uuid];
//        c*****t char *updateSql  = [updateSqlStr UTF8String];
//        int updateSqlOK = sqlite3_prepare_v2(hhySqlite, updateSql, -1, &statement, nil);
//
//        if (updateSqlOK != SQLITE_OK) {
//            printf("---------- update sql is error!-------------\r\n");
//            sqlite3_close(hhySqlite);
//            return NO;
//        }
//
//        sqlite3_bind_text(statement, 1, [uuidName       UTF8String], -1, SQLITE_TRANSIENT);
//        sqlite3_bind_text(statement, 2, [deviceName     UTF8String], -1, SQLITE_TRANSIENT);
//        sqlite3_bind_text(statement, 3, [peripheralInfo UTF8String], -1, SQLITE_TRANSIENT);
//
//        int execUpdateSqlOk = sqlite3_step(statement);
//        sqlite3_finalize(statement);
//
//        if (execUpdateSqlOk == SQLITE_ERROR) {
//            sqlite3_close(hhySqlite);
//            return NO;
//        }
//
//    }
//    printf("----------update data  t_Infor Database is OK!-------------\r\n");
//    sqlite3_close(hhySqlite);
//    return YES;
//}
//
//
////===========delete data=================
//- (BOOL) deleteData:(NSString *)tableName UUID:(NSString *)uuid{
//    if ([self openDatabase]) {
//        sqlite3_stmt *statement = nil;
//        NSString *deleteSqlStr = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE  uuid=?",tableName];
//        c*****t char *deleteSql  = [deleteSqlStr UTF8String];
//
//        int deleteSqlOk = sqlite3_prepare_v2(hhySqlite, deleteSql, -1, &statement, nil);
//        if (deleteSqlOk != SQLITE_OK) {
//            printf("---------- delete sql is error!-------------\r\n");
//            sqlite3_close(hhySqlite);
//            return NO;
//        }
//
//        sqlite3_bind_text(statement, 1, [uuid UTF8String], -1, SQLITE_TRANSIENT);
//
//        int execDeleteSqlOk = sqlite3_step(statement);
//        sqlite3_finalize(statement);
//
//        if (execDeleteSqlOk == SQLITE_ERROR) {
//            sqlite3_close(hhySqlite);
//            return NO;
//        }
//
//    }
//    printf("----------delete data t_Infor Database is OK!-------------\r\n");
//    sqlite3_close(hhySqlite);
//    return YES;
//
//
//}
//
//
////===========select uuid=================
//- (NSString *)selectUUIDData:(NSString *)tableName{
//    return nil;
//}
//
//
////===========select data==================
//- (NSMutableArray *)selectAllData:(NSString *)tableName{
//    NSMutableArray *selectArray    = [NSMutableArray arrayWithCapacity:10];
//    NSMutableDictionary *selectDic = [[NSMutableDictionary alloc] init];
//
//
//    NSString *selectSqlStr = [NSString stringWithFormat:@"SELECT * from '%@'",tableName];
//
//    if ([self openDatabase]) {
//
//        sqlite3_stmt *statement = nil;
//        c*****t char *selectSql = [selectSqlStr UTF8String];
//        if (sqlite3_prepare_v2(hhySqlite, selectSql, -1, &statement, nil) != SQLITE_OK) {
//            printf("----------select selectAllData sql is error!-------------\r\n");
//            return NO;
//        }
//        else{
//            while (sqlite3_step(statement) == SQLITE_ROW) {
//                char *str_uuidName       = (char *)sqlite3_column_text(statement, 1);
//                char *str_uuid           = (char *)sqlite3_column_text(statement, 2);
//                char *str_deviceName     = (char *)sqlite3_column_text(statement, 3);
//                char *str_peripheralInfo = (char *)sqlite3_column_text(statement, 4);
//
//                NSString *uuidNameStr       = [[NSString alloc] initWithUTF8String: str_uuidName];
//                NSString *uuidStr           = [[NSString alloc] initWithUTF8String: str_uuid];
//                NSString *deviceNameStr     = [[NSString alloc] initWithUTF8String: str_deviceName];
//                NSString *peripheralInfoStr = [[NSString alloc] initWithUTF8String: str_peripheralInfo];
//
//                [selectDic setObject:uuidNameStr       forKey:@"uuidName"];
//                [selectDic setObject:uuidStr           forKey:@"uuid"];
//                [selectDic setObject:deviceNameStr     forKey:@"deviceName"];
//                [selectDic setObject:peripheralInfoStr forKey:@"peripheralInfo"];
//
//                [selectArray addObject:selectDic];
//
//                NSLog(@"------------uuidNameStr = %@",uuidNameStr);
//                NSLog(@"----------------uuidStr = %@",uuidStr);
//                NSLog(@"----------deviceNameStr = %@",deviceNameStr);
//                NSLog(@"------peripheralInfoStr = %@",peripheralInfoStr);
//                printf("\r\n");
//            }
//        }
//        sqlite3_finalize(statement);
//        sqlite3_close(hhySqlite);
//    }
//    return [selectArray retain];
//}
//
//
//@end
//
//






