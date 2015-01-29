//
//  Sqlite3DataPersistence.m
//  MJ
//
//  Created by harry on 15/1/10.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "Sqlite3DataPersistence.h"
#import "Macro.h"
#import "dictionaryManager.h"
#import <sqlite3.h>

//static  NSString* databasePath = nil;

@implementation Sqlite3DataPersistence

+(NSString*)getDatabasePath
{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    NSString* databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: DIC_DB_NAME]];
    return databasePath;
}

+(void)insertObj:(id<SQLPROTOCOL>)obj ToTable:(NSString*)tableName
{
    if (obj == nil)
    {
        return;
    }
    NSString *insertSQL = [obj insertString];
    if (insertSQL == nil || insertSQL.length == 0)
    {
        return;
    }
    
    
    sqlite3_stmt *statement;
    
    
    const char *dbpath = [[self getDatabasePath] UTF8String];
    
    sqlite3 *sqlDB = nil;
    
    if (sqlite3_open(dbpath, &sqlDB)==SQLITE_OK)
    {
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(sqlDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement)==SQLITE_DONE)
        {
             //NSLog(@"insert table ok");
        }
        else
        {
            //NSLog(@"insert table fail");
        }
        sqlite3_finalize(statement);
        sqlite3_close(sqlDB);
    }
}


+(NSArray*)seachRecordWithCondition:(NSString*)cond
{
    const char *dbpath = [[self getDatabasePath] UTF8String];
    NSMutableArray*arr = [[NSMutableArray alloc] init];

    sqlite3_stmt *statement;
    
    sqlite3 *sqlDB = nil;
    if (sqlite3_open(dbpath, &sqlDB) == SQLITE_OK)
    {
        NSString *querySQL = [DicItem searchString];
        querySQL = [querySQL stringByAppendingString:@" "];
        querySQL = [querySQL stringByAppendingString:cond];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(sqlDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *dict_label = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];

                
                NSString *dict_label_type = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                NSString *dict_sort = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                NSString *dict_value = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];

                DicItem* item = [[DicItem alloc] init];
                item.dict_label = dict_label;
                item.dict_label_type = dict_label_type;
                item.dict_sort = dict_sort;
                item.dict_value = dict_value;
                if ([item isKindOfClass:[DicItem class]])
                {
                    //NSLog(@"asdsa%@ %@",item.dict_label,item.dict_sort);
                }
                else
                {
                    //fNSLog(@"asdsa2");
                }
                [arr addObject:item];
            }
            
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(sqlDB);
    }
    return arr;
}
+(void)deleteTable:(NSString*)tabName
{
    //const char *dbpath = [[self getDatabasePath] UTF8String];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    sqlite3 *sqlDB = nil;
    
    if ([filemgr fileExistsAtPath:[self getDatabasePath]] == YES)
    {
        const char *dbpath = [[self getDatabasePath] UTF8String];
        if (sqlite3_open(dbpath, &sqlDB)==SQLITE_OK)
        {
            char *errMsg;
            
            NSString*dropSql = [NSString stringWithFormat:@"DROP TABLE %@",DIC_TABLE_NAME];
            const char *sql_stmt = [dropSql UTF8String];
            if (sqlite3_exec(sqlDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
            {
                //NSLog(@"drop table fail");
            }
            else
            {
                 //NSLog(@"drop table success");
            }
            
            sqlite3_close(sqlDB);
        }
        else
        {
            
        }
    }
}

+(void)createTable:(NSString*)tabName
{

    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    sqlite3 *sqlDB = nil;
    

    {
        const char *dbpath = [[self getDatabasePath] UTF8String];
        if (sqlite3_open(dbpath, &sqlDB)==SQLITE_OK)
        {
            char *errMsg;
            
            const char *sql_stmt = "CREATE TABLE dictable ( id INTEGER PRIMARY KEY AUTOINCREMENT,dict_label varchar(255),dict_label_type varchar(255),dict_sort varchar(255),dict_value varchar(255))";
            if (sqlite3_exec(sqlDB, sql_stmt, NULL, NULL, &errMsg)==SQLITE_OK)
            {
                //NSLog(@"create table success");
            }
            
            sqlite3_close(sqlDB);
        }
        else
        {
            
        }
    }
}
@end
