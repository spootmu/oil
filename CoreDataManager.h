//
//  CoreDataManage.h
//  oil
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 Spoot Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface CoreDataManager : NSObject
@property(nonatomic,strong) NSManagedObjectContext *context;

+(CoreDataManager *)ShareCoreDataManager;
@end
