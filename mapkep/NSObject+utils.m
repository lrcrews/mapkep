//
//  NSObject+utils.m
//  mapkep
//
//  Created by L Ryan Crews on 1/19/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import "NSObject+utils.h"

#import "Constants.h"


@implementation NSObject (utils)


- (void)setMyValuesForKeysWithDictionary:(NSDictionary *)keyedValues;
{
    for (NSString * currentKey in [keyedValues allKeys])
    {
        NSString * setterName = [NSString stringWithFormat:@"set%@%@:", [[currentKey substringToIndex:1] uppercaseString], [currentKey substringFromIndex:1]];
        
        SEL selector = NSSelectorFromString(setterName);
        if ([self respondsToSelector:selector])
        {
            id currentObject = [keyedValues objectForKey:currentKey];
            if (currentObject == [NSNull null])
            {
                currentObject = nil;
            }
            DebugLog("%@ %@", currentKey, currentObject);
            
            [self performSelectorOnMainThread:selector
                                   withObject:currentObject
                                waitUntilDone:YES];
        }
        else
        {
            AlwaysLog(@"object does not respond to setter name %@", setterName);
        }
    }
}


- (id)aquireCustomNibNamed:(NSString *)nibName;
{
    NSArray * mainBundleObjects = [[NSBundle mainBundle] loadNibNamed:nibName
                                                                owner:nil
                                                              options:nil];
    
    for (id currentObject in mainBundleObjects)
    {
        if ([currentObject isKindOfClass:[self class]])
        {
            return currentObject;
        }
    }
    
    AlwaysLog(@"WARNING: Nib acquasition failed, returning nil!");
    return nil;
}


@end
