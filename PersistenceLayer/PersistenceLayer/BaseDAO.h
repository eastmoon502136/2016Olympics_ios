//
//  BaseDAO.h
//  PersistenceLayer
//
//  Created by 陈建能 on 15/6/25.
//  Copyright (c) 2015年 ChenJianneng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "DBHelper.h"

@interface BaseDAO : NSObject
{
    sqlite3 *db;
}

@property(nonatomic, strong) NSString* dbFilePath;

-(BOOL)openDB;

@end
