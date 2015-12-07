//
//  Occurance.h
//  mapkep
//
//
//  Hmmm, I typoed that.  There's no "a" in Occurence.
//  Let's pretend I did it for trademark reasons... yes,
//  that's why I did that.
//
//  Would it be silly to wish Xcode did spell check when
//  creating files?  You know, just a "hey, did you mean
//  blah?".  Not auto-correct mind you, just a friendly
//  little sentence near the input.  I digress.
//
//
//  Created by L Ryan Crews on 2/8/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class Mapkep;


@interface Occurance : NSManagedObject


@property (nonatomic, retain) NSDate * createdAt;

@property (nonatomic, retain) Mapkep * belongs_to_mapkep;


- (BOOL)save:(NSError *)error;
- (BOOL)deleteSelf:(NSError *)error;

- (NSString *)relativeTimeSinceLastOccerence;

+ (Occurance *)emptyOccurance;


@end
