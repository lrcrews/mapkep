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

#define COLOR_1 (@"#118BD0")
#define COLOR_2 (@"#FFFFFF")


// KEYS (COREDATA, JSON, & DICTIONARY)
//
//      i refuse to use capital letters, periods, and oxford commas?

#define kKey_MapkepEntityName (@"Mapkep")
//
//  This constant name is the only place I spell "Occurence"
//  correctly (for now).
//
#define kKey_OccurenceEntityName (@"Occurance")
//
//  You know, I really do like underscores better
//  than camelcase.  You can read it so much quicker.
//  I might go through and update all my stuff.  Plus,
//  if I do all these macros and variable names with
//  underscores and leave methods as camelcaes (as is
//  the objective c convention) I'll be able to add
//  more meaning to the already verbose code since the
//  different styles will immediately point out everything
//  as either a method or a variable.  Well maybe not
//  cases where it could be a variable or method, but
//  it's only one word.  There's a chance I shouldn't be
//  coding right now...
//
//  Hey!  This!  It's the name to use for any segue
//  going to the detail page of a Mapkep so we can hook
//  into the detail controller with prepare for segue
//  and set the Mapkep it's going to be detailing.
//
#define kSegue_ToMapkepDetail       (@"segue_to_mapkep_detail")
#define k_segue_to_edit_page        (@"segue_to_edit")
#define k_segue_to_history_table    (@"segue_to_history_table")



// LOGGING MACROS

#ifdef DEBUG
#   define DebugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DebugLog(...)
#endif


#define AlwaysLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


// NOTIFICATIONS

#define kNotification_MapkepContextUpdated  (@"notification_mapkepContextUpdated")


// FONTAWESOME ARRAY OF enum VALUES
// sigh...

#define FA_ICON_HEX_VALUES @[ @0xf000, @0xf001, @0xf002, @0xf003, @0xf004, @0xf005, @0xf006, @0xf007, @0xf008, @0xf009, @0xf00a, @0xf00b, @0xf00c, @0xf00d, @0xf00e, @0xf010, @0xf011, @0xf012, @0xf013, @0xf014, @0xf015, @0xf016, @0xf017, @0xf018, @0xf019, @0xf01a, @0xf01b, @0xf01c, @0xf01d, @0xf01e, @0xf021, @0xf022, @0xf023, @0xf024, @0xf025, @0xf026, @0xf027, @0xf028, @0xf029, @0xf02a, @0xf02b, @0xf02c, @0xf02d, @0xf02e, @0xf02f, @0xf030, @0xf031, @0xf032, @0xf033, @0xf034, @0xf035, @0xf036, @0xf037, @0xf038, @0xf039, @0xf03a, @0xf03b, @0xf03c, @0xf03d, @0xf03e, @0xf040, @0xf041, @0xf042, @0xf043, @0xf044, @0xf045, @0xf046, @0xf047, @0xf048, @0xf049, @0xf04a, @0xf04b, @0xf04c, @0xf04d, @0xf04e, @0xf050, @0xf051, @0xf052, @0xf053, @0xf054, @0xf055, @0xf056, @0xf057, @0xf058, @0xf059, @0xf05a, @0xf05b, @0xf05c, @0xf05d, @0xf05e, @0xf060, @0xf061, @0xf062, @0xf063, @0xf064, @0xf065, @0xf066, @0xf067, @0xf068, @0xf069, @0xf06a, @0xf06b, @0xf06c, @0xf06d, @0xf06e, @0xf070, @0xf071, @0xf072, @0xf073, @0xf074, @0xf075, @0xf076, @0xf077, @0xf078, @0xf079, @0xf07a, @0xf07b, @0xf07c, @0xf07d, @0xf07e, @0xf080, @0xf081, @0xf082, @0xf083, @0xf084, @0xf085, @0xf086, @0xf087, @0xf088, @0xf089, @0xf08a, @0xf08b, @0xf08c, @0xf08d, @0xf08e, @0xf090, @0xf091, @0xf092, @0xf093, @0xf094, @0xf095, @0xf096, @0xf097, @0xf098, @0xf099, @0xf09a, @0xf09b, @0xf09c, @0xf09d, @0xf09e, @0xf0a0, @0xf0a1, @0xf0f3, @0xf0a3, @0xf0a4, @0xf0a5, @0xf0a6, @0xf0a7, @0xf0a8, @0xf0a9, @0xf0aa, @0xf0ab, @0xf0ac, @0xf0ad, @0xf0ae, @0xf0b0, @0xf0b1, @0xf0b2, @0xf0c0, @0xf0c1, @0xf0c2, @0xf0c3, @0xf0c4, @0xf0c5, @0xf0c6, @0xf0c7, @0xf0c8, @0xf0c9, @0xf0ca, @0xf0cb, @0xf0cc, @0xf0cd, @0xf0ce, @0xf0d0, @0xf0d1, @0xf0d2, @0xf0d3, @0xf0d4, @0xf0d5, @0xf0d6, @0xf0d7, @0xf0d8, @0xf0d9, @0xf0da, @0xf0db, @0xf0dc, @0xf0dd, @0xf0de, @0xf0e0, @0xf0e1, @0xf0e2, @0xf0e3, @0xf0e4, @0xf0e5, @0xf0e6, @0xf0e7, @0xf0e8, @0xf0e9, @0xf0ea, @0xf0eb, @0xf0ec, @0xf0ed, @0xf0ee, @0xf0f0, @0xf0f1, @0xf0f2, @0xf0a2, @0xf0f4, @0xf0f5, @0xf0f6, @0xf0f7, @0xf0f8, @0xf0f9, @0xf0fa, @0xf0fb, @0xf0fc, @0xf0fd, @0xf0fe, @0xf100, @0xf101, @0xf102, @0xf103, @0xf104, @0xf105, @0xf106, @0xf107, @0xf108, @0xf109, @0xf10a, @0xf10b, @0xf10c, @0xf10d, @0xf10e, @0xf110, @0xf111, @0xf112, @0xf113, @0xf114, @0xf115, @0xf118, @0xf119, @0xf11a, @0xf11b, @0xf11c, @0xf11d, @0xf11e, @0xf120, @0xf121, @0xf122, @0xf122, @0xf123, @0xf124, @0xf125, @0xf126, @0xf127, @0xf128, @0xf129, @0xf12a, @0xf12b, @0xf12c, @0xf12d, @0xf12e, @0xf130, @0xf131, @0xf132, @0xf133, @0xf134, @0xf135, @0xf136, @0xf137, @0xf138, @0xf139, @0xf13a, @0xf13b, @0xf13c, @0xf13d, @0xf13e, @0xf140, @0xf141, @0xf142, @0xf143, @0xf144, @0xf145, @0xf146, @0xf147, @0xf148, @0xf149, @0xf14a, @0xf14b, @0xf14c, @0xf14d, @0xf14e, @0xf150, @0xf151, @0xf152, @0xf153, @0xf154, @0xf155, @0xf156, @0xf157, @0xf158, @0xf159, @0xf15a, @0xf15b, @0xf15c, @0xf15d, @0xf15e, @0xf160, @0xf161, @0xf162, @0xf163, @0xf164, @0xf165, @0xf166, @0xf167, @0xf168, @0xf169, @0xf16a, @0xf16b, @0xf16c, @0xf16d, @0xf16e, @0xf170, @0xf171, @0xf172, @0xf173, @0xf174, @0xf175, @0xf176, @0xf177, @0xf178, @0xf179, @0xf17a, @0xf17b, @0xf17c, @0xf17d, @0xf17e, @0xf180, @0xf181, @0xf182, @0xf183, @0xf184, @0xf185, @0xf186, @0xf187, @0xf188, @0xf189, @0xf18a, @0xf18b, @0xf18c, @0xf18d, @0xf18e, @0xf190, @0xf191, @0xf192, @0xf193, @0xf194, @0xf195, @0xf196 ]


// FONTAWESOME FONT HELPER

#define FA_ICONS_FONT               [UIFont fontWithName:@"FontAwesome" size:100.0f]
#define FA_ICONS_FONT_HALF_SIZE     [UIFont fontWithName:@"FontAwesome" size:50.0f]
#define FA_ICONS_FONT_THIRD_SIZE    [UIFont fontWithName:@"FontAwesome" size:36.0f]
#define FA_ICONS_FONT_TINY_SIZE     [UIFont fontWithName:@"FontAwesome" size:18.0f]


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
