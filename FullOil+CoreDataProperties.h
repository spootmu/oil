//
//  FullOil+CoreDataProperties.h
//  oil
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 Spoot Studio. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FullOil.h"

NS_ASSUME_NONNULL_BEGIN

@interface FullOil (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *datetime;
@property (nullable, nonatomic, retain) NSNumber *total;
@property (nullable, nonatomic, retain) NSOrderedSet<OilData *> *oildata;

@end

@interface FullOil (CoreDataGeneratedAccessors)

- (void)insertObject:(OilData *)value inOildataAtIndex:(NSUInteger)idx;
- (void)removeObjectFromOildataAtIndex:(NSUInteger)idx;
- (void)insertOildata:(NSArray<OilData *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeOildataAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInOildataAtIndex:(NSUInteger)idx withObject:(OilData *)value;
- (void)replaceOildataAtIndexes:(NSIndexSet *)indexes withOildata:(NSArray<OilData *> *)values;
- (void)addOildataObject:(OilData *)value;
- (void)removeOildataObject:(OilData *)value;
- (void)addOildata:(NSOrderedSet<OilData *> *)values;
- (void)removeOildata:(NSOrderedSet<OilData *> *)values;

@end

NS_ASSUME_NONNULL_END
