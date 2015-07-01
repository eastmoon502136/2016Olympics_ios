//
//  Schedule.h
//  PersistenceLayer
//
//  Created by 陈建能 on 15/6/24.
//  Copyright (c) 2015年 ChenJianneng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Events.h"

//比赛日程实体表
@interface Schedule : NSObject

//标号
@property(nonatomic, assign) NSUInteger ScheduleID;
//比赛日期
@property(nonatomic, strong) NSString*  GameDate;
//比赛时间
@property(nonatomic, strong) NSString*  GameTime;
//比赛描述
@property(nonatomic, strong) NSString*  GameInfo;
//比赛项目
@property(nonatomic, strong) Events*    Event;

@end
