//
//  EventsDAO.m
//  PersistenceLayer
//
//  Created by 陈建能 on 15/7/1.
//  Copyright (c) 2015年 ChenJianneng. All rights reserved.
//

#import "EventsDAO.h"

@implementation EventsDAO

static EventsDAO *sharedManager = nil;

+ (EventsDAO*)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        sharedManager = [[super alloc] init];
        
    });
    return sharedManager;
}

-(int) create:(Events*)model {
    if([self openDB]) {
        NSString *sqlStr = @"INSERT INTO EVENTS (EventName,EventIcon,KeyInfo,BasicsInfo,OlympicInfo) VALUES (?,?,?,?,?)";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [model.EventName   UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [model.EventIcon   UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 3, [model.KeyInfo     UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 4, [model.BasicsInfo  UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 5, [model.OlympicInfo UTF8String], -1, NULL);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"插入数据失败.");
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return 0;
}

-(int) remove:(Events*)model {
    if ([self openDB]) {
        NSString *sqlScheduleStr = [[NSString alloc] initWithFormat:@"DELETE from Schedule where EventID=%i", model.EventID];
        
        char *err;
        
        sqlite3_exec(db, "BEGIN IMMEDIATE TRANSACTION", NULL, NULL, &err);
        if(sqlite3_exec(db, [sqlScheduleStr UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            sqlite3_exec(db, "ROLLBACK TRANSACTION", NULL, NULL, NULL);
            NSAssert(NO, @"删除数据库失败。");
        }
        
        NSString *sqlEventsStr = [[NSString alloc] initWithFormat:@"DELETE from Events where EventID = %i;", model.EventID];
        if (sqlite3_exec(db, [sqlEventsStr UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            sqlite3_exec(db, "ROLLBACK TRANSACTION", NULL, NULL, &err);
            NSAssert(NO, @"删除数据失败.");
        }
        sqlite3_exec(db, "COMMIT TRANSACTION", NULL, NULL, &err);
        sqlite3_close(db);
    }
    return 0;
}

-(int) modify:(Events*)model {
    if ([self openDB]) {
        
        NSString *sqlStr = @"UPDATE Events set EventName=?, EventIcon=?,KeyInfo=?,BasicsInfo=?,OlympicInfo=? where EventID =?";
        
        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            //绑定参数开始
            sqlite3_bind_text(statement, 1, [model.EventName UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [model.EventIcon UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 3, [model.KeyInfo UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 4, [model.BasicsInfo UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 5, [model.OlympicInfo UTF8String], -1, NULL);
            sqlite3_bind_int(statement, 6, model.EventID);
            
            //执行
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"修改数据失败。");
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return 0;
}

-(NSMutableArray*) findAll {
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    
    if ([self openDB]) {
        
        NSString *qsql = @"SELECT EventName, EventIcon,KeyInfo,BasicsInfo,OlympicInfo,EventID FROM Events";
        
        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            //执行
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                Events* events = [[Events alloc] init];
                
                char *cEventName = (char *) sqlite3_column_text(statement, 0);
                events.EventName = [[NSString alloc] initWithUTF8String: cEventName];
                
                char *cEventIcon = (char *) sqlite3_column_text(statement, 1);
                events.EventIcon = [[NSString alloc] initWithUTF8String: cEventIcon];
                
                char *cKeyInfo = (char *) sqlite3_column_text(statement, 2);
                events.KeyInfo = [[NSString alloc] initWithUTF8String: cKeyInfo];
                
                char *cBasicsInfo = (char *) sqlite3_column_text(statement, 3);
                events.BasicsInfo = [[NSString alloc] initWithUTF8String: cBasicsInfo];
                
                char *cOlympicInfo = (char *) sqlite3_column_text(statement, 4);
                events.OlympicInfo = [[NSString alloc] initWithUTF8String: cOlympicInfo];
                
                events.EventID = sqlite3_column_int(statement, 5);
                
                [listData addObject:events];
                
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
        
    }
    return listData;

}

-(Events*) findById:(Events*)model {
    
    if ([self openDB]) {
        
        NSString *qsql = @"SELECT EventName, EventIcon,KeyInfo,BasicsInfo,OlympicInfo,EventID FROM Events  where EventID =?";
        
        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            //绑定参数开始
            sqlite3_bind_int(statement, 1, model.EventID);
            
            //执行
            if (sqlite3_step(statement) == SQLITE_ROW) {
                
                Events* events = [[Events alloc] init];
                
                char *cEventName = (char *) sqlite3_column_text(statement, 0);
                events.EventName = [[NSString alloc] initWithUTF8String: cEventName];
                
                char *cEventIcon = (char *) sqlite3_column_text(statement, 1);
                events.EventIcon = [[NSString alloc] initWithUTF8String: cEventIcon];
                
                char *cKeyInfo = (char *) sqlite3_column_text(statement, 2);
                events.KeyInfo = [[NSString alloc] initWithUTF8String: cKeyInfo];
                
                char *cBasicsInfo = (char *) sqlite3_column_text(statement, 3);
                events.BasicsInfo = [[NSString alloc] initWithUTF8String: cBasicsInfo];
                
                char *cOlympicInfo = (char *) sqlite3_column_text(statement, 4);
                events.OlympicInfo = [[NSString alloc] initWithUTF8String: cOlympicInfo];
                
                events.EventID = sqlite3_column_int(statement, 5);
                
                sqlite3_finalize(statement);
                sqlite3_close(db);
                return events;
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
        
    }
    return nil;
}

@end
