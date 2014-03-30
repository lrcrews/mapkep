//
//  NSString+utils.m
//  mapkep
//
//  9
//
//  Created by L Ryan Crews on 1/19/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import "NSString+utils.h"


@implementation NSString (utils)


//  See, it's things like this that make you really appreciate the age we live in,
//  no?  Think about it, the fact that I can google how to do this, find great examples
//  (the first two results being highly voted stackoverflow answers) is amazing.
//  You'll hear people scoff at the future, "Who cares that you can pull your phone out
//  and find out the name of the wrestler who played Mario in some live action Mario Brothers
//  show that noone even knows about?".  Well I do.  I do becuase this is the 'practical'
//  extension of that.  This is the future mother fuckers, appreciate it.
//
//  So... ya, this allows you to do things like:
//
//      [self.fooButton setBackgroundColor:[@"#951717" toUIColor]];
//
//
//  It was 'Captain Lou' by the way.
//
- (UIColor *)toUIColor;
{
    //  Safety first, a lesson from Men Without Hats
    //
    if (self.length == 0) return [UIColor clearColor];
    
    //  The actual greatness
    //
    unsigned int c;
    
    if ([self characterAtIndex:0] == '#')
    {
        [[NSScanner scannerWithString:[self substringFromIndex:1]] scanHexInt:&c];
    }
    else
    {
        [[NSScanner scannerWithString:self] scanHexInt:&c];
    }
    
    
    return [UIColor colorWithRed:((c & 0xff0000) >> 16)/255.0
                           green:((c & 0xff00) >> 8)/255.0
                            blue:(c & 0xff)/255.0
                           alpha:1.0];
}


@end


//  FOOTER LINKS??  OH HELL YEAH!
//
//  Swing your arms from side to side, come on, it's time to go, do the Mario!
//      http://en.wikipedia.org/wiki/The_Super_Mario_Bros._Super_Show!
//
//  The Hall of fame wrestler who I know as 'Mario' (and the fat version
//  of Mario & Lugi's mother):
//      http://en.wikipedia.org/wiki/Lou_Albano
//
//
