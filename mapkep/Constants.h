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


// COLORS

#define BACKGROUND_MAIN         (@"#D3F3FF")
#define BACKGROUND_SECONDARY    (@"#F5FFFA")

// Primary Font Color - Dark Gray
//  My designer friends are always against using
//  pure white or black.  I'm sure there are good
//  reasons for it, but even if there aren't I
//  still follow their advice.  The question then
//  is what almost black color do I use?  In these
//  moments my first thought is always "42", and
//  I'm always surprised how often it works out.
//
#define FONT_MAIN   (@"#424242")


// FONTS

//  In addition to actual constants I typically include
//  style related information in this file as well.  You
//  can almost gaurantee that any engineer taking over a
//  project will open a file named "Constants".  I mean
//  how could you not?  It'd be like Frank Castle ignoring
//  a purse snatcher running by.  Highly unlikely.
//
//  So, with that in mind, we're creating what some may
//  call a style guide in this file.  Not detailed, not all
//  inclusive, just enough to let the people involved know
//  what colors and fonts we're using.

// TODO: define these font families if need arises
//       (currently all fonts are chosen in nib files)


// Primary Font - American Typewriter
//
//      this is the font used for all titles and buttons


// Secondary Font - Helvetica(?)
//
//      this is the font used for sentences and stats



// KEYS (COREDATA, JSON, & DICTIONARY)
//
//      i refuse to use capital letters, periods, and oxford commas?

#define kKey_MapkepEntityName (@"Mapkep")

//  This constant name is the only place I spell "Occurence"
//  correctly (for now).
//
#define kKey_OccurenceEntityName (@"Occurance")



// LOGGING MACROS

#ifdef DEBUG
#   define DebugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DebugLog(...)
#endif


#define AlwaysLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


// NOTIFICATIONS

#define kNotification_ColorChosen   (@"notification_colorChosen")
#define kNotification_MapkepAdded   (@"notification_mapkepAdded")


// VIEW TAGS

//  Even if I only ever reference these once there is
//  benefit in having them defined here.  Namely, it gives
//  us a quick place to see all the tags currently being
//  used and, if we keep this up to date, it tells us
//  the files they're being used in.  So, if we find we're
//  adding new UI that needs a unique tag we can glance here
//  and pick a number accordingly.

#define tag_LastOccurence   (1337)  // StatsOverviewViewController
#define tag_MapKepColor     (1338)  // StatsOverviewViewController
#define tag_MapKepTitle     (1339)  // StatsOverviewViewController
#define tag_TotalCount      (1340)  // StatsOverviewViewController



@interface Constants : NSObject
@end


//
//
//  If it's good enough for life, the universe, and everything, it's
//  good enough for my primary font color.
//  http://en.wikipedia.org/wiki/Phrases_from_The_Hitchhiker's_Guide_to_the_Galaxy
//
//  Frank Castle is
//  http://www.tumblr.com/tagged/frank-castle
//
//  A Style Guide is many things.  I specifically meant a guide
//  to the visual aspects of the app, but it is not uncommon to have
//  guides for coding styles, naming conventions, and so on.  Here's
//  a page from Github's style guide:
//  https://github.com/styleguide/css/11.0
//
//  It's false.  There are not capital letters nor periods, but there
//  is an Oxford comma.  That's the one preceeding the and in a chain.
//  Here's a quick image to help understand why you should use them:
//  http://imgur.com/5LdZT
//
