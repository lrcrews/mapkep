//
//  AboutViewController.m
//  mapkep
//
//  Created by L Ryan Crews on 11/30/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import "AboutViewController.h"

#import "Constants.h"
#import "NSString+FontAwesome.h"


//  I love girls, girls, girls, girls
//  Girls I do adore
//
//  Yo put your number on this paper cause I would love to date ya
//  Holla at you when I come of tour
//

@interface AboutViewController ()

@property (nonatomic, strong) IBOutlet UIButton * blogButton;
@property (nonatomic, strong) IBOutlet UIButton * codeButton;

@end


//  I got this Spanish chica, she don't like me to roam
//  So she call me "cabron" plus "maricon"
//

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Said she likes to cook rice so she likes me home
    // I'm like, "Un momento, mami, slow up your tempo"
    
    UIFont * fa_font = FA_ICONS_FONT_HALF_SIZE;
    
    // I got this black chick, she don't know how to act
    // Always talking out her neck, making her fingers snap
    
    self.blogButton.titleLabel.font = fa_font;
    
    [self.blogButton setTitle:[NSString awesomeIcon:FaGlobe]
                     forState:UIControlStateNormal];
    
    // She like: "Listen, Jigga Man, I don't care if you rap
    // You better R-E-S-P-E-C-T me"
    
    self.codeButton.titleLabel.font = fa_font;
    
    [self.codeButton setTitle:[NSString awesomeIcon:FaGithub]
                     forState:UIControlStateNormal];
}


#pragma mark -
#pragma mark I got this French chick that love to French kiss

//  She thinks she's Bo Derek, wear her hair in a twist
//  "Ma cherie amour, tu es belle"
//  Merci, you're fine as fuck but you giving me hell
//

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//  I got this Indian squaw, the day that I met her
//  Asked her what tribe she with: red dot or feather
//

- (IBAction)navigateToBlog:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ryancrews.com"]];
}


//  She said: "all you need to know is I'm not a ho
//  And to get with me you better be Chief Lots-a-Dough"
//

- (IBAction)navigateToCode:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://github.com/lrcrews/mapkep"]];
}


//  Now that's Spanish chick, French chick, Indian and black
//  That's fried chicken, curry chicken.. damn I'm getting fat
//  Arroz con pollo, French fries and crepe
//  An appetite for destruction but I scrape the plate
//


@end


//  Real recognize real... footer links.
//
//
//  Hopefully if Jay-Z ever sees this he appreciates my desire
//  to show that code is like any art, fucking awesome.
//
//  This song is "Girls, girls, girls"
//  http://genius.com/Jay-z-girls-girls-girls-lyrics
//
//  This album is one of the best albums, I like it (The Blueprint)
//  as much as I like The New Danger, or Yoshimi Battles the Pink
//  Robots, or Narrow Stairs, or Are You Experienced, or... you
//  get the point.
//
//
//  Footer links for the footer link?!?!?
//              soooo...
//                  Ground Links?
//
//  http://en.wikipedia.org/wiki/The_Blueprint
//  http://en.wikipedia.org/wiki/The_New_Danger
//  http://en.wikipedia.org/wiki/Yoshimi_Battles_the_Pink_Robots
//  http://en.wikipedia.org/wiki/Narrow_Stairs
//  http://en.wikipedia.org/wiki/Are_You_Experienced
//
