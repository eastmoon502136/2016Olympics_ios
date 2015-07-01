//
//  DBHelper.h
//  PersistenceLayer
//
//  Created by 陈建能 on 15/6/27.
//  Copyright (c) 2015年 ChenJianneng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DBHelper : NSObject
{
    sqlite3 *db;
}

+ (NSString *)applicationDocumentsDirectoryFile :(NSString *)fileName;

-(void)initDB;

-(int)dbVersionNubmer;

@end
