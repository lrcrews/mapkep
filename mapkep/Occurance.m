//
//  Occurance.m
//  mapkep
//
//  Created by L Ryan Crews on 2/8/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import "Occurance.h"

#import "AppDelegate.h"
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


- (BOOL)deleteSelf:(NSError *)error;
{
    NSManagedObjectContext * context = [self managedObjectContext];
    [context deleteObject:self];
    if (![context save:&error])
    {
        AlwaysLog(@"Delete failed: %@", [error localizedDescription]);
        return false;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MAPKEP_CONTEXT_UPDATED
                                                        object:nil];
    
    return true;
}

#pragma mark -
#pragma mark Time Helpers

//  Builds a more human readable representation of the
//  created at time for display throughout the app.
//
- (NSString *)relativeTimeSinceLastOccerence;
{
    if (self.createdAt == nil)
    {
        // What the hell am I looking at? When does this happen in the movie?
        
        return @"never";
    }
    else
    {
        // Now. You're looking at now, sir.
        // Everything that happens now, is happening now.
        
        NSDate * now = [[NSDate alloc] init];
        
        // What happened to then?
        
        NSTimeInterval secondsBetween   = [now timeIntervalSinceDate:self.createdAt];
        CGFloat minutesBetween          = secondsBetween / 60.0f;
        CGFloat hoursBetween            = minutesBetween / 60.0f;
        CGFloat daysBetween             = hoursBetween / 24.0f;
        CGFloat weeksBetween            = daysBetween / 7.0f;
        CGFloat monthsBetween           = weeksBetween / 4.3f;      // eh, close enough
        CGFloat yearsBetween            = monthsBetween / 12.1f;    // ditto
        
        //  We passed then.
        
        if (yearsBetween > 2)   return @"long, long ago";
        if (yearsBetween > 1.1) return @"more than a year ago";
        if (yearsBetween > 0.9) return @"about a year ago";
        
        //  When?
        
        if (monthsBetween > 10)     return @"many, many months";
        if (monthsBetween > 7)      return @"more than half a year ago";
        if (monthsBetween > 5.9)    return @"about half a year ago";
        if (monthsBetween > 3.1)    return @"several months ago";
        if (monthsBetween > 2)      return @"a couple of months ago";
        if (monthsBetween > 0.9)    return @"about a month ago";
        
        //  Just now. We're at now now.
        
        if (weeksBetween > 4)   return @"about a month ago";
        if (weeksBetween > 3)   return @"a few weeks ago";
        if (weeksBetween > 2)   return @"a coulpe of weeks ago";
        if (weeksBetween > 0.9) return @"about a week ago";
        
        //  Go back to then.
        
        if (daysBetween > 6)    return @"almost a week ago";
        if (daysBetween > 4)    return @"several days ago";
        if (daysBetween > 3)    return @"a few days ago";
        if (daysBetween > 2)    return @"a couple of days ago";
        if (daysBetween > 1)    return @"more than a day ago";
        
        //  When?
        
        if (hoursBetween > 20)      return @"about a day ago";
        if (hoursBetween > 13)      return @"many hours ago";
        if (hoursBetween > 11)      return @"about half a day ago";
        if (hoursBetween > 10)      return @"more than ten hours ago";
        if (hoursBetween > 9)       return @"more than nine hours ago";
        if (hoursBetween > 8)       return @"more than eight hours ago";
        if (hoursBetween > 7)       return @"more than seven hours ago";
        if (hoursBetween > 6)       return @"more than six hours ago";
        if (hoursBetween > 5)       return @"more than five hours ago";
        if (hoursBetween > 3)       return @"a few hours ago";
        if (hoursBetween > 2)       return @"a couple of hours ago";
        if (hoursBetween > 1.75)    return @"almost two hours ago";
        if (hoursBetween > 1.5)     return @"more than a hour and a half ago";
        if (hoursBetween > 1.15)    return @"over a hour ago";
        if (hoursBetween > 0.85)    return @"about a hour ago";
        
        //  Now.
        
        if (minutesBetween > 45)    return @"almost a hour ago";
        if (minutesBetween > 35)    return @"over thirty minutes ago";
        if (minutesBetween > 25)    return @"about thirty minutes ago";
        if (minutesBetween > 21)    return @"more than twenty minutes ago";
        if (minutesBetween > 19)    return @"about twenty minutes ago";
        if (minutesBetween > 16)    return @"more then fifteen minutes ago";
        if (minutesBetween > 14)    return @"about fifteen minutes ago";
        if (minutesBetween > 11)    return @"more than ten minutes ago";
        if (minutesBetween > 9)     return @"about ten minutes ago";
        if (minutesBetween > 8)     return @"more than eight minutes ago";
        if (minutesBetween > 7)     return @"more than seven minutes ago";
        if (minutesBetween > 6)     return @"more than six minutes ago";
        if (minutesBetween > 4)     return @"about five minutes ago";
        if (minutesBetween > 2)     return @"a couple of minutes ago";
        if (minutesBetween > 0.85)  return @"about a minute ago";
        
        //  Now?
        
        if (secondsBetween > 45)    return @"almost a minute ago";
        if (secondsBetween > 30)    return @"half a minute ago";
        if (secondsBetween > 10)    return @"just a few seconds ago";
        
        //  Now.
        
        if (secondsBetween > 0) return @"now";
        
        //  I can't.
        
        return @"inconceivable";
    }
}


#pragma mark -
#pragma mark Classing it up a bit

+ (Occurance *)emptyOccurance;
{
    // Let's grab our coredata context so we can...
    
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = [appDelegate managedObjectContext];
    
    // ...create a new instance of our event's occurance
    // that knows how to save itself so we can...
    
    return [NSEntityDescription insertNewObjectForEntityForName:KEY_OCCURENCE_ENTITY_NAME
                                         inManagedObjectContext:context];
}


@end


//  Flip, Flip, Flipadelphia
//      Flip, Flip, Flipadelphia
//    Flip, Flip, Footer Links.
//
//
//  Spaceballs!?!?  Well I feel I must finish it...
//      Dark Helmet: Why?
//      Colonel Sandurz: We missed it.
//      Dark Helmet: When?
//      Colonel Sandurz: Just now.
//      Dark Helmet: When will then be now?
//      Colonel Sandurz: Soon.
//      Dark Helmet: How soon?
//
//
//  --------------------------------------------------------------------
//

