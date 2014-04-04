//
//  UIColorPickerView.m
//  mapkep
//
//  4
//  Welcome to a picker that will consist of buttons!
//
//  They're... big?  The buttons.  They're probably big.
//  All I really know is their measurement:
//
//      BUTTON_WIDTH x BUTTON_HEIGHT
//
//  ...everytime I write something like that I question
//  if I did it in the correct order.
//
//  Created by L Ryan Crews on 1/19/14.
//                              ^
//                              |_that's my mom's birthday.  Hi Mom!
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import "UIColorPickerView.h"

#import "Constants.h"
#import "MapkepButton.h"
#import "NSString+utils.h"
#import "UIColor+utils.h"


#pragma mark -
#pragma mark constants

//  I just played around in the story board for a minute to get the dimensions
//  of something that feels good (or at least good enough for v1).
//
#define DEFAULT_HEIGHT              210.0f
#define DEFAULT_WIDTH               320.0f
#define DEFAULT_BUTTON_STARTING_X   20.0f
#define DEFAULT_BUTTON_STARTING_Y   5.0f

#define BUTTON_GUTTER               20.0f

//  Well that's a lot of colors.  Surely I spent hours debating the perfect chioces.
//  Surely I researched what colors are statistically favored.
//
//  Software engineers, like you and I, are artists.  Our art is in the simplicity
//  of our code, in the magic we create, in the reuse of our older pieces of art,
//  and in finding the most efficient ways to be lazy.  And we are damn good.  At
//  times our laziness births awesome code on it's own, like the string to ASSCII
//  text tool I used for The Tick! reference earlier, and other times we simply
//  try to think of the best way to tackle the tedious task that taunts us.  That's
//  the case here.  I just typed "[UIColor ]", then pressed 'esc', slected the
//  next color... several times.  Why overthink such a decision?  Yet many tend to.
//  It has halted great projects of my friends, myself, and possibly even you.  Look
//  at a task like this and just chant in your head a growing corus of "mvp, mvp, MVP!".
//  Just be lazy, be lazy well, and be happy with what you create.  Art.
//
//  tldr; No, no I did not.
//
//
//  We meet again DEFAULT_COLORS.  After writing the above much has happened.  It's
//  important to remember that form follows function.  It's also important to actually
//  follow your successfull function with form.  With that in mind I now have a color
//  scheme for the base app, black(ish) and white(ish), colors that should allow for
//  any other color to pop up and say "hey, I'm the focus here, press me!".  You hear
//  voices from your UI too... right?  Regardless, the next question is how to decide
//  on button colors that go well together, and for that I will apply the cunning use
//  of flags.
//
//  Old empires may have used flags to conquer far away lands, I will use them becuase
//  I know people put a lot of thought into the colors in them.  Why should I spend
//  time debating color theory when I can just use the wonderful work of those who
//  know more than me?  Eventually I'll likely have one of my designer friends give
//  this app a once over, but until then... flags.
//
//  To Wikipedia!
//
//#define DEFAULT_UICOLORS @[ [@"AF001D" toUIColor], [@"012498" toUIColor], [@"FCC915" toUIColor], [@"DF5E07" toUIColor], [@"278301" toUIColor], [@"FB0006" toUIColor], [@"FEF70B" toUIColor], [@"379DD6" toUIColor], [@"26A503" toUIColor], [@"000000" toUIColor], [@"FEA820" toUIColor], [@"0300A0" toUIColor] ]

//  But then I thought, "shit."  There was more: "I like the normal colors better."
//  Soooo, ya, I'm using this again, but without the duplicate colors.
//  (always fun when you catch yourself spending time on some non-MVP aspect)
#define DEFAULT_UICOLORS @[ [UIColor blueColor], [UIColor brownColor], [UIColor cyanColor], [UIColor greenColor], [@"696969" toUIColor], [UIColor magentaColor], [UIColor orangeColor], [UIColor purpleColor], [UIColor redColor], [UIColor yellowColor], [@"012498" toUIColor], [@"000000" toUIColor] ]


//  TODO: v2.x?, when varying stat pages require a display in a smaller
//          size use these.  You have the sketch somewhere.  Well I do.
//
#define BUTTON_HIEGHT_NORML 55.0f
#define BUTTON_WIDTH_NORML  55.0f
#define BUTTON_HIEGHT_SMALL 40.0f
#define BUTTON_WIDTH_SMALL  40.0f
#define BUTTON_HIEGHT_TINY  20.0f
#define BUTTON_WIDTH_TINY   20.0f


@implementation UIColorPickerView
{
    CGFloat currentX_, currentY_;
}


#pragma mark -
#pragma mark inits

//  You may have noticed by now that I do some things simply
//  because I find them more astecally pleasing (like those two
//  lines up there that could be "#pragma mark - inits").
//
//  Of course we want to keep things DRY (Don't Repeat Yourself),
//  but I find many go a little overboard with this philosphy blah blah blhah

//  Interesting method name, eh?  I don't actually expect anyone else to work
//  on this project... ever, yet I still find naming things in a way that invokes
//  one's inner Sherlock is a good idea as it helps you remember decisions you
//  made when you come back to look at your code in the future.
//
//  So my dear Watson, what would you deduce about the UI component this init
//  creates?
//
//  Just a float value for the y point, so I would assume the component takes
//  up the entire width of the screen
//
//  Go on.
//
//  ...     I dunno.   ...  Fuck you.
//
- (id)initDefaultUIColorPickerAtYPoint:(CGFloat)y;
{
    return [self initWithFrame:CGRectMake(0.0f, y, DEFAULT_WIDTH, DEFAULT_HEIGHT)
                  withUIColors:DEFAULT_UICOLORS
               withButtonWidth:BUTTON_WIDTH_NORML
               andButtonHeight:BUTTON_HIEGHT_NORML];
}


//  Hmm, that note up there may be edited out later.  But I
//  hope not.  It's always important to remember that Watson
//  avoids saying that despite everything.  I mean really,
//  I certainly would have cursed out Sherlock by now.  Maybe
//  I'm just a bad person...  Hmm.
//
- (id)initWithFrame:(CGRect)frame
       withUIColors:(NSArray *)uicolors
    withButtonWidth:(CGFloat)buttonWidth
    andButtonHeight:(CGFloat)buttonHeight;
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        //  Let's get our x and y values ready for the buttons
        currentX_ = [self defaultVersion] ? DEFAULT_BUTTON_STARTING_X : 8.0f;
        currentY_ = [self defaultVersion] ? DEFAULT_BUTTON_STARTING_Y : 8.0f;
        
        //  In V1x I might add a scroll view and a page control to allow for more
        //  than 14 colors.  But for now...
        
        //  Let's add some UI to this UI
        for (UIColor * color in uicolors)
        {
            MapkepButton * button = [[MapkepButton alloc] initWithFrame:CGRectMake(currentX_, currentY_, buttonWidth, buttonHeight)
                                                                  color:color];
            
            //  What we want to do and when we want to do it.
            [button addTarget:self
                       action:@selector(colorChosen:)
             forControlEvents:UIControlEventTouchUpInside];
            
            //  We definitely want to see it, right?
            [self addSubview:button];
            
            //  Top to bottom, lbah blah hiaku, blah blah, future scrolling
            //  therefore set up for that logically now.  plus it looks cooler.
            currentY_ += buttonHeight + BUTTON_GUTTER;
            if (currentY_ >= frame.size.height)
            {
                currentY_ = [self defaultVersion] ? DEFAULT_BUTTON_STARTING_Y : 8.0f;
                currentX_ += buttonWidth + BUTTON_GUTTER;
            }
        }
    }
    
    return self;
}

#pragma mark -
#pragma mark Action Jackson

- (IBAction)colorChosen:(id)sender
{
    //  Let's get the button's color
    //
    UIColor * chosenColor = [(UIButton *)sender backgroundColor];
    
    //  This log statement and simple code saved me (possibly) hours.
    //
    //  The app was working great, I had several buttons in there and
    //  functioning, well, functioning as much as I expected them to at
    //  this point.  Then I added a black colored button.  Crashed.  Fine.
    //  Fair.  Let me add a safety check to handle that (in this case a
    //  check in 'toUIColor').  But why did it crash?  The immediate
    //  answer is given by the console, it crashed becuase 'toUIColor'
    //  was trying to get character at index 0 to an empty string.  So then,
    //  why was the input string empty?  It shouldn't be, it should have
    //  saved the hex version of the UIColor set to the button's background
    //  color.  This means the issue should be on the saving side of things,
    //  the side of things where a UIColor is translated to a hex value,
    //  the side of things where something got lost in translation (and sadly
    //  ScarJo isn't here to help).
    //
    //  Thanks to the simplicity of the code there's only one place to look,
    //  'toHexValue' in UIColor+utils.  This method, though slightly edited
    //  by me for formatting and clearer comments, is from stackoverflow.
    //  A place where the upvoted answers are almost always well written and
    //  explained.  Part of that explanition for this method is that it only
    //  works for RGB colors, which are UIColors whose number of color
    //  components is four (the extra is alpha, so really they're RGBA colors).
    //  This log statement's chosenColor.description shows only two color
    //  components and even states it's in the "UIDeviceWhiteColorSpace".
    //
    //  The bug is now obvious.  So what's the solution?  Easy.  I chant "MVP"
    //  in my head and make an executive decision, 'eff all grayscale colors.
    //  I just won't have any in this app for now (and possibly not ever) becuase
    //  it's just not worth it.
    //
    //  Happiness.  Victory.  I'm off to press the green button.
    //
    DebugLog(@"\"%@\" chosen, hex value is \"%@\".", chosenColor.description, chosenColor.toHexValue);
    
    //  Let's tell anybody who may care about this wonderful happening
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_ColorChosen
                                                        object:chosenColor];
}


#pragma mark -
#pragma mark Helper McHelperson

- (BOOL)defaultVersion
{
    return self.frame.size.height == DEFAULT_HEIGHT
        && self.frame.size.width == DEFAULT_WIDTH;
}


@end


//  IT'S THAT TIME AGAIN.
//  (time to spin the wheel of morality?)
//  TIME TO SPIN THE WHEEL OF MORALITY!
//  (ya, that's what I said.)
//  WHAT?  NO, I MEAN, FOOTER LINKS!!
//
//
//  You can generate words such as "SPOON!!!!" in one of many different
//  ASCII styles too:
//      http://www.network-science.de/ascii/
//
//
//  --------------------------------------------------------------------
//  Ah MVP.  Minimal Viable Product.  One of the many buzz words around
//  the start-up world, but an important one.  Once you truly imbrace it,
//  like the team at 37signals, it's a magical thing.  They wrote a great
//  book that really focuses a light on the topic that I suggest everyone
//  reads, and it's free!
//      http://gettingreal.37signals.com
//
//  (you can buy it too, which I did, in a physical format, if you like
//  that sort of thing... or just want to support a fellow group of software
//  engineers who are doing good things in our world)
//
//  For those who won't read that I'll simply state it this way:  When you
//  think your app needs to allow for sending data in an email, it doesn't.
//  When you think that a user who uses your app needs to be able to share
//  what they're doing on facebook and twitter for it to be valueable, it doesn't.
//  When you think that feature 'foo' and feature 'bar' are both needed in
//  your first release, they aren't.  Find that core thing you think your app,
//  site, system, whatever does, and just do it.  And then, just do it.
//
//
//  --------------------------------------------------------------------
//  Flags.  Eddie Izzard in his stand-up special 'Dressed To Kill' explained
//  the cunning use of flags.  The English would just sail around the world
//  planting flags in the ground.  "I claim this land for England", then
//  *plod*, a flag has been planted, meanwhile a crowd has gathered, "You
//  can't claim us, this is India, there's a half a billion of us living
//  here".  "Well, do you have a flag?".  "What?  A flag?  No, what, no, we
//  we don't need a flag, we live here!".  "Too bad, no flag no country,
//  those are the rules!"
//
//  Ok, I'm going to stop paraphrasing that joke now, you should watch it
//  though, stands up to time well, not something a lot of stand-up acts
//  can claim.
//
//
//  --------------------------------------------------------------------
//  Simple.  "Thanks to the simplicity of the code".  Not, "thanks to the
//  easyness of this project".  Simple and easy are often interchanged, but
//  they really shouldn't be, especially not when talking about code.  Simple
//  code is code that does not rely on knowledge that isn't actually needed
//  for it's task.  It has nothing to do with how involved you're code base
//  is.  It shouldn't matter if your project is hard or easy, it should be
//  simple either way.
//
//  Semantics, right?  I'm not so sure.  Check out this fantastic video of
//  Closure's author, , talking at a conference.  It is by far the best
//  description of the differences between simple, easy, complex, and hard
//  there is, and it'll make you slightly better at being an awesome software
//  engineer.
//      http://www.infoq.com/presentations/Simple-Made-Easy
//
