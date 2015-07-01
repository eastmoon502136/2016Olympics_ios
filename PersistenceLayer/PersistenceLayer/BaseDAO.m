//
//  BaseDAO.m
//  PersistenceLayer
//
//  Created by 陈建能 on 15/6/25.
//  Copyright (c) 2015年 ChenJianneng. All rights reserved.
//

#import "BaseDAO.h"

@implementation BaseDAO

-(id)init {
    self = [super init];
    if (self) {
        self.dbFilePath = [DBHelper applicationDocumentsDirectoryFile:DB_FILE_NAME];
        DBHelper *dbhelper = [DBHelper new];
        [dbhelper initDB];
    }
    return self;
}

-(BOOL)openDB {
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败.");
        return false;
    }
    return true;
}

@end
