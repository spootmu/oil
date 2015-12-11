//
//  OilData+CoreDataProperties.h
//  oil
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 Spoot Studio. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "OilData.h"

NS_ASSUME_NONNULL_BEGIN

@interface OilData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *datetime;
@property (nullable, nonatomic, retain) NSNumber *km;
@property (nullable, nonatomic, retain) NSNumber *l;

@end

NS_ASSUME_NONNULL_END
