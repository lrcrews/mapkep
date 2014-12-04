//
//  Mapkep.m
//  mapkep
//
//  Created by L Ryan Crews on 2/8/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import "Mapkep.h"

#import "Constants.h"
#import "NSString+FontAwesome.h"
#import "Occurance.h"


@implementation Mapkep


@dynamic faUInt;
@dynamic hexColorCode;
@dynamic name;
@dynamic ordinal;
@dynamic has_many_occurances;


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
