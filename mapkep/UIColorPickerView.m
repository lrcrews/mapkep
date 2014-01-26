//
//  UIColorPickerView.m
//  mapkep
//
//  4
//  Welcome to a picker that will consist of 50x50 buttons
//
//  Created by L Ryan Crews on 1/19/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import "UIColorPickerView.h"

#import "NSString+utils.h"

#import "Constants.h"


#pragma mark -
#pragma mark constants

//  I just played around in the story board for a minute to get the dimensions
//  of something that feels good (or at least good enough for v1).
//
#define DEFAULT_HEIGHT              300.0f
#define DEFAULT_WIDTH               320.0f
#define DEFAULT_BUTTON_STARTING_X   20.0f
#define DEFAULT_BUTTON_STARTING_Y   5.0f

//  There was a study (well there's a bunch of them) about the 'perfect' size for
//  primary action buttons on mobile devices, afterall, we're not using a mouse or
//  a stylus (and if you are using one of those please stop, you're being silly).
//  While there is no one answer you'll be doing your user's a favor if they're larger.
//  If you can get your smallest diminsion between 40 and 55 you're doing well.
//
#define BUTTON_HEIGHT           55.0f
#define BUTTON_WIDTH            55.0f
#define BUTTON_GUTTER           20.0f
#define BUTTON_CORNER_RADIUS    20.0f

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
#define DEFAULT_UICOLORS @[ [UIColor blackColor], [UIColor blueColor], [UIColor brownColor], [UIColor cyanColor], [UIColor darkGrayColor], [UIColor grayColor], [UIColor greenColor], [UIColor lightGrayColor], [UIColor magentaColor], [UIColor orangeColor], [UIColor purpleColor], [UIColor redColor], [UIColor whiteColor], [UIColor yellowColor] ]


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
- (id)initDefaultUIColorPickerAtYPoint:(CGFloat)y;
{
    return [self initWithFrame:CGRectMake(0.0f, y, DEFAULT_WIDTH, DEFAULT_HEIGHT)
                  withUIColors:DEFAULT_UICOLORS];
}


- (id)initWithFrame:(CGRect)frame
       withUIColors:(NSArray *)uicolors;
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        //  Let's get our x and y values ready for the buttons
        currentX_ = [self defaultVersion] ? DEFAULT_BUTTON_STARTING_X : 8.0f;
        currentY_ = [self defaultVersion] ? DEFAULT_BUTTON_STARTING_Y : 8.0f;
        
        //  In V1x I might add a scroll view and a page control to allow for more
        //  than 15 colors.  But for now...
        
        //  Let's add some UI to this UI
        NSInteger tag = 0;
        for (UIColor * color in uicolors)
        {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            //  Let's make it pretty
            button.frame = CGRectMake(currentX_, currentY_, BUTTON_WIDTH, BUTTON_HEIGHT);
            button.backgroundColor = color;
            button.layer.cornerRadius = BUTTON_CORNER_RADIUS;
            button.layer.borderColor = UIColor.darkGrayColor.CGColor;
            button.layer.borderWidth = 1.0f;
            
            //  We'll grab the tag in the IBAction so we know which color was chosen.
            button.tag = tag;
            tag++;
            
            //  What we want to do and when we want to do it.
            [button addTarget:self
                       action:@selector(colorChosen:)
             forControlEvents:UIControlEventTouchUpInside];
            
            //  We definitely want to see it, right?
            [self addSubview:button];
            
            //  Top to bottom, lbah blah hiaku, blah blah, future scrolling
            //  therefore set up for that logically now.  plus it looks cooler.
            currentY_ += BUTTON_HEIGHT + BUTTON_GUTTER;
            if (currentY_ >= frame.size.height)
            {
                currentY_ = [self defaultVersion] ? DEFAULT_BUTTON_STARTING_Y : 8.0f;
                currentX_ += BUTTON_WIDTH + BUTTON_GUTTER;
            }
        }
    }
    
    return self;
}

#pragma mark -
#pragma mark Action Jackson

- (IBAction)colorChosen:(id)sender
{
    DebugLog(@"color chosen is at index: %d", [(UIButton *)sender tag]);
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
//  Button sizes.  There's a nice 16px playground in there between 40
//  and 55 (inclusive), so do what feels right.  If you're interested
//  as to why this size range is the sweet spot you should check out
//  Fitt's law:
//      http://en.wikipedia.org/wiki/Fitts%27s_law
//
//  and the ways it's been applied in a three-dimential space:
//      http://stackoverflow.com/questions/2843744/fitts-law-applying-it-to-touch-screens
//
//  or you could ask a UX designer their thoughts, I'm curious as to how
//  many caveats they'll give before the answer.
//
//
//  --------------------------------------------------------------------
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
