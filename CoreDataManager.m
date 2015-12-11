//
//  CoreDataManage.m
//  oil
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 Spoot Studio. All rights reserved.
//

#import "CoreDataManager.h"
#import <CoreData/CoreData.h>
@implementation CoreDataManager

-(NSManagedObjectContext *)context
{
    if(!_context)
    {
        NSManagedObjectModel *model=[NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc=[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSString *docs=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSURL *url=[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"Oils.data"]];
        
        NSError *err=nil;
        
        NSPersistentStore *store=[psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&err];
        if (store==nil) {
            [NSException raise:@"添加数据库错误" format:@"%@",[err localizedDescription]];
        }
        
        NSManagedObjectContext *context=[[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        context.persistentStoreCoordinator=psc;
        
        _context=context;
    }
    return _context;
}

+(CoreDataManager *)ShareCoreDataManager
{
    static CoreDataManager *_share=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share=[[CoreDataManager alloc]init];
    });
    return _share;
}
@end
