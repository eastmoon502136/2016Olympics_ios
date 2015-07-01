//
//  EventsDAO.h
//  PersistenceLayer
//
//  Created by 陈建能 on 15/7/1.
//  Copyright (c) 2015年 ChenJianneng. All rights reserved.
//

#import "BaseDAO.h"
#import "Events.h"

@interface EventsDAO : BaseDAO

+ (EventsDAO*)sharedManager;

-(int) create:(Events*)model;

-(int) remove:(Events*)model;

-(int) modify:(Events*)model;

-(NSMutableArray*) findAll;

-(Events*) findById:(Events*)model;

@end
