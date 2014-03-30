//
//  UIColor+utils.m
//  mapkep
//
//  Created by L Ryan Crews on 2/15/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import "UIColor+utils.h"

@implementation UIColor (utils)


//  Another gem from the wonderful world of StackOverflow.
//  I edited it from a class method to an instance method as
//  that use case makes more sense to me, and went a little
//  'bonzai' on it to prune it down to what I personally think
//  reads easier.
//
- (NSString *)toHexValue;
{
    //  Per Apple's CGColor Reference "The size of the array is one more
    //  than the number of components of the color space for the color.",
    //  hence the '4' for an RGB color.
    //
    if (CGColorGetNumberOfComponents(self.CGColor) == 4)
    {
        const CGFloat * components = CGColorGetComponents(self.CGColor);
        
        //  This is the opposite of what's occuring in NSString+utils's
        //  toUIColor method.
        //
        CGFloat red = roundf(components[0] * 255.0);
        CGFloat green = roundf(components[1] * 255.0);
        CGFloat blue = roundf(components[2] * 255.0);
        
        //  Convert with %02x (use 02 to always get two chars).
        //  A good tip from Luc Wollants on StackOverflow.
        //
        return [[NSString alloc]initWithFormat:@"%02x%02x%02x", (int)red, (int)green, (int)blue];
    }
    
    return @"";
}


@end
