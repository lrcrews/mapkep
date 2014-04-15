//
//  Mapkep.h
//  mapkep
//
//  Created by L Ryan Crews on 2/8/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class Occurance;


@interface Mapkep : NSManagedObject

@property (nonatomic, retain) NSString * hexColorCode;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * ordinal;
@property (nonatomic, retain) NSOrderedSet * has_many_occurances;


- (BOOL)save:(NSError *)error;
- (BOOL)deleteSelf:(NSError *)error;

+ (NSArray *)allWithManagedObjectContext:(NSManagedObjectContext *)context;


@end


@interface Mapkep (CoreDataGeneratedAccessors)

-           (void)insertObject:(Occurance *)value
  inHas_many_occurancesAtIndex:(NSUInteger)idx;

- (void)removeObjectFromHas_many_occurancesAtIndex:(NSUInteger)idx;

- (void)insertHas_many_occurances:(NSArray *)value
                        atIndexes:(NSIndexSet *)indexes;

- (void)removeHas_many_occurancesAtIndexes:(NSIndexSet *)indexes;

- (void)replaceObjectInHas_many_occurancesAtIndex:(NSUInteger)idx
                                       withObject:(Occurance *)value;

- (void)replaceHas_many_occurancesAtIndexes:(NSIndexSet *)indexes
                    withHas_many_occurances:(NSArray *)values;

- (void)addHas_many_occurancesObject:(Occurance *)value;

- (void)removeHas_many_occurancesObject:(Occurance *)value;

- (void)addHas_many_occurances:(NSOrderedSet *)values;

- (void)removeHas_many_occurances:(NSOrderedSet *)values;

@end
