//
//  Mapkep.m
//  mapkep
//
//  Created by L Ryan Crews on 2/8/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import "Mapkep.h"

#import "AppDelegate.h"
#import "Constants.h"
#import "NSString+FontAwesome.h"
#import "Occurance.h"


@implementation Mapkep


@dynamic faUInt;
@dynamic hexColorCode;
@dynamic name;
@dynamic ordinal;
@dynamic has_many_occurances;


- (NSOrderedSet *)occurances;
{
    return self.has_many_occurances != nil ? self.has_many_occurances : [NSOrderedSet new];
}


- (NSArray *)occurancesForDate:(NSDate *)date;
{
    // set up the two dates we need to bound our occurances
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDateComponents * components = [calendar components:( NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit )
                                                fromDate:date];
    
    // first the begining of the day
    
    [components setMinute:0];
    [components setHour:0];
    NSDate * date_begining_of_day = [calendar dateFromComponents:components];
    
    // then the end of the day
    
    [components setMinute:59];
    [components setHour:23];
    NSDate * date_end_of_day = [calendar dateFromComponents:components];
    
    // get the context and entity description
    
    NSManagedObjectContext * context = [self managedObjectContext];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:kKey_OccurenceEntityName
                                               inManagedObjectContext:context];
    
    // build the predicates and the fetch request
    
    NSPredicate * lowerBound = [NSPredicate predicateWithFormat:@"createdAt > %@", date_begining_of_day];
    NSPredicate * upperBound = [NSPredicate predicateWithFormat:@"createdAt < %@", date_end_of_day];
    
    // TODO: question, how do I limit this query to just this mapkep's
    //       children? (keeping in mind there's no mapkep_id on Occurence)
    //
    //       until then, this, but it's not completely accurate
    
    NSPredicate * myFaUInt = [NSPredicate predicateWithFormat:@"belongs_to_mapkep.faUInt = %d", self.faUInt];
    
    NSPredicate * myName = [NSPredicate predicateWithFormat:@"belongs_to_mapkep.name = %@", self.name];
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[lowerBound, upperBound, myFaUInt, myName]]];
    
    // execute it
    
    NSError * error;
    return [context executeFetchRequest:fetchRequest
                                  error:&error];
}


#pragma mark -
#pragma mark DB Stuff

- (BOOL)save:(NSError *)error;
{
    // default to a circle if no icon value is present
    if (self.faUInt == 0)
    {
        self.faUInt = FaCircle;
    }
    
    // get the context and save it
    NSManagedObjectContext * context = [self managedObjectContext];
    if (![context save:&error])
    {
        AlwaysLog(@"Save failed: %@", [error localizedDescription]);
        return false;
    }
    
    // let others know (hey, look!  it's the observer pattern!)
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_MapkepContextUpdated
                                                        object:nil];
    
    return true;
}


- (BOOL)deleteSelf:(NSError *)error;
{
    NSManagedObjectContext * context = [self managedObjectContext];
    [context deleteObject:self];
    if (![context save:&error])
    {
        AlwaysLog(@"Delete failed: %@", [error localizedDescription]);
        return false;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_MapkepContextUpdated
                                                        object:nil];
    
    return true;
}


#pragma mark -
#pragma mark Probably Statistics

- (Occurance *)firstOccurence;
{
    return self.occurances.firstObject != nil ? self.occurances.firstObject : [Occurance emptyOccurance];
}


- (Occurance *)lastOccurence;
{
    return self.occurances.lastObject != nil ? self.occurances.lastObject : [Occurance emptyOccurance];
}


- (Occurance *)recentOccurenceWithOffset:(NSInteger)offset;
{
    NSInteger desired_index = self.totalOccurences - offset - 1;
    
    if (desired_index >= 0)
    {
        return self.occurances[desired_index];
    }
    else
    {
        return [Occurance emptyOccurance];
    }
}


- (int)totalOccurences;
{
    return (int)self.occurances.count;
}


#pragma mark -
#pragma mark Classy Shit

+ (NSArray *)allWithManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:kKey_MapkepEntityName
                                               inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError * error;
    return [context executeFetchRequest:fetchRequest
                                  error:&error];
}


+ (NSString *)defaultColorAsHexString;
{
    return @"#118AD0";
}


+ (int)defaultFAUInt;
{
    return FaCircle;
}


@end
