//
//  MapkepButton.h
//  mapkep
//
//  Created by L Ryan Crews on 2/22/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import <UIKit/UIKit.h>


//  There was a study (well there's a bunch of them) about the 'perfect' size for
//  primary action buttons on mobile devices, afterall, we're not using a mouse or
//  a stylus (and if you are using one of those please stop, you're being silly).
//  While there is no one answer you'll be doing your user's a favor if they're larger.
//  If you can get your smallest diminsion between 40 and 55 you're doing well.
//
#define BUTTON_CORNER_RADIUS    30.0f
#define BUTTON_HEIGHT           75.0f
#define BUTTON_WIDTH            75.0f


@interface MapkepButton : UIButton


- (id)initWithFrame:(CGRect)frame
              color:(UIColor *)color;


@end



//  If you want to win at footer notes you need to take Australasia.
//  Just get all those purples, move everyone to Papua New Guinea, then
//  build, build, build.
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
