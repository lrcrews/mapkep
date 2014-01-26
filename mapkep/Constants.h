//
//  Constants.h
//  mapkep
//
//  7
//
//  Created by L Ryan Crews on 1/19/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import <Foundation/Foundation.h>


// ENVIRONMENT


// LOGGING MACROS

#ifdef DEBUG
#   define DebugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DebugLog(...)
#endif


#define AlwaysLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


// DEVICE MACROS


// NOTIFICATIONS


// JSON & DICTIONARY KEYS


// COLOR CODES

#define BACKGROUND_MAIN         (@"#F0FFF0")
#define BACKGROUND_SECONDARY    (@"#F5FFFA")


@interface Constants : NSObject
@end
