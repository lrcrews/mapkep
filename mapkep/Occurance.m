//
//  Occurance.m
//  mapkep
//
//  Created by L Ryan Crews on 2/8/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import "Occurance.h"

#import "Constants.h"


@implementation Occurance

@dynamic createdAt;
@dynamic belongs_to_mapkep;


#pragma mark -
#pragma mark DB Stuff

- (BOOL)save:(NSError *)error;
{
    NSManagedObjectContext * context = [self managedObjectContext];
    if (![context save:&error])
    {
        AlwaysLog(@"Save failed: %@", [error localizedDescription]);
        return false;
    }
    
    return true;
}


@end
