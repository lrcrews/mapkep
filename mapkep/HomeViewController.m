//
//  HomeViewController.m
//  mapkep
//
//  Created by L Ryan Crews on 1/18/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import "HomeViewController.h"

#import "AppDelegate.h"
#import "Constants.h"
#import "Mapkep.h"
#import "NSString+FontAwesome.h"
#import "NSString+utils.h"
#import "Occurance.h"


//  Tag values for elements in the storyboard
//
static int tag_add      = 1337;
static int tag_git      = 1338;
static int tag_stats    = 1339;


//  Cyborgs can see who they want to see
//
@interface HomeViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) IBOutlet UICollectionView * mapkepCollectionView;
@property (nonatomic, strong) IBOutlet UILabel * mapkepLabel;
@property (nonatomic, strong) NSArray * mapkepObjects;
@property (nonatomic, strong) IBOutlet UILabel * successLabel;

@end


//  It's true
//
@implementation HomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUI)
                                                 name:kNotification_MapkepContextUpdated
                                               object:nil];
    
    // Set up the non-mapkep buttons
    
    UIFont * fa_font = FA_ICONS_FONT_THIRD_SIZE;
    
    UIButton * add_button = (UIButton *)[self.view viewWithTag:tag_add];
    UIButton * git_and_stuff_button = (UIButton *)[self.view viewWithTag:tag_git];
    UIButton * stats_button = (UIButton *)[self.view viewWithTag:tag_stats];
    
    // TODO: should really break out the bottom nav into
    // a reusable view that takes in three uibutton references
    
    // the left button (remove mapkep)
    
    git_and_stuff_button.titleLabel.font = fa_font;
    
    [git_and_stuff_button setTitle:[NSString awesomeIcon:FaQuestion]
                          forState:UIControlStateNormal];
    
    CALayer * git_and_stuff_layer = [git_and_stuff_button layer];
    git_and_stuff_layer.borderWidth = 1.0f;
    git_and_stuff_layer.borderColor = [COLOR_1 toUIColor].CGColor;
    
    // the middle button (add mapkep)
    
    add_button.titleLabel.font = fa_font;
    
    [add_button setTitle:[NSString awesomeIcon:FaPlus]
                forState:UIControlStateNormal];
    
    CALayer * add_layer = [add_button layer];
    add_layer.borderWidth = 1.0f;
    add_layer.borderColor = [COLOR_1 toUIColor].CGColor;
    
    // the right button (occurence stats)
    
    stats_button.titleLabel.font = fa_font;
    
    [stats_button setTitle:[NSString awesomeIcon:FaBarChartO]
                  forState:UIControlStateNormal];
    
    CALayer * stats_layer = [stats_button layer];
    stats_layer.borderWidth = 1.0f;
    stats_layer.borderColor = [COLOR_1 toUIColor].CGColor;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = [appDelegate managedObjectContext];
    
    [self setMapkepObjects:[Mapkep allWithManagedObjectContext:context]];
}


- (void)viewWillUnload:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //  Mos Def
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (IBAction)buttonPressed:(id)sender
{
    Occurance * newOccurance = [Occurance emptyOccurance];
    newOccurance.createdAt = [[NSDate alloc] init];
    
    //  ...add the relationship to the tapped Mapkep
    //  and then...
    //
    //  (in my opinion this reads better than the helper
    //  method coredata provides 'add<child>Object:' on
    //  the parent).
    
    Mapkep * tappedMapkep = self.mapkepObjects[[sender tag]];
    newOccurance.belongs_to_mapkep = tappedMapkep;
    
    DebugLog(@"Adding occurence to mapkep with name \"%@\" and color \"%@\"", tappedMapkep.name, tappedMapkep.hexColorCode);
    
    //  ...you know... save it.  Then we can...
    
    NSError * error;
    if (![newOccurance save:error])
    {
        AlwaysLog(@"Danger Will Robinson, occrence creation failed.");
    }
    
    //  ...let the user know the button led to magic, hooray!
    
    [self displaySuccessMessageWithColor:[tappedMapkep.hexColorCode toUIColor]];
}


#pragma mark -
#pragma mark Twain

- (void)refreshUI
{
    [self.mapkepCollectionView reloadData];
}


#pragma mark - 
#pragma mark UICollectionView Datasource

// 1
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.mapkepObjects.count;
}


// 2
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //  MapkepButtonCell is the name set on the prototype cell in the storyboard.
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MapkepButtonCell" forIndexPath:indexPath];
    
    
    //  Get the two subview we need from the cell
    
    UIButton * button = nil;
    UILabel * label = nil;
    
    for (UIView * view in cell.contentView.subviews)
    {
        if ([view isKindOfClass:UIButton.class])
        {
            button = (UIButton *)view;
        }
        else if ([view isKindOfClass:UILabel.class])
        {
            label = (UILabel *)view;
        }
    }
    
    
    //  Get the backing object for this UI
    
    Mapkep * mapkep = (Mapkep *)self.mapkepObjects[indexPath.row];
    
    
    //  Get the two things together
    
    button.titleLabel.font = FA_ICONS_FONT;
    
    if (mapkep.faUInt == 0) mapkep.faUInt = [Mapkep defaultFAUInt];
    
    [button setTitle:[NSString awesomeIcon:(int)mapkep.faUInt]
            forState:UIControlStateNormal];
    
    [button setTitleColor:[mapkep.hexColorCode toUIColor]
                 forState:UIControlStateNormal];
    
    [button setTag:indexPath.row];
    
    if ([button actionsForTarget:self
                 forControlEvent:UIControlEventTouchUpInside] == nil)
    {
        [button addTarget:self
                   action:@selector(buttonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    
    [label setText:[mapkep name]];
    [label setTextColor:[mapkep.hexColorCode toUIColor]];
    
    
    //  Give the people what they want
    
    return cell;
}


#pragma mark -
#pragma mark Button Tap Animation

//  This particular effect is the simplest one I could think of
//  and is easy to follow.  It Is...
//
//      "CrossFade" - Hero for Hire (assuming the phone bill is paid)
//
//  Quick side note, Netflix recently made an awesome deal with
//  Marvel that involves at least 60 hours of mini-series/movies
//  for characters like Luke Cage, Iron Fist, Daredevil, and others.
//  This is fantastic news, espicailly after the House of Cards
//  recognizition (not to mention badassery), which should lead to
//  good writers, directors, actors, and others.  Imagine that
//  House of Cards talking to the camera style and general direction
//  (from a slue of fantastic directors [I think Contact/Twister lady
//  directed one extremely well]) with a looser action-that's-funny
//  style, like a Kiss Kiss Bang Bang, for Hawkeye (as currently
//  written by Mark Waid).  Are you imagining it?  Now add bacon.
//  That's how good it could be, better than ballons, kittens, babies,
//  and other such examples.
//
//  So, ya, "CrossFade".
//
//  Basically you just have two labels in your storyboard, with one
//  label set to alpha 0 (successLabel in our case), hook them up to
//  properties you defined in the header file of this controller then
//  boom:  Switch their alphas with an auto reverse option, "CrossFade".
//
//  I also include the ease out option to linger a little longer on
//  success label, but that's just a preference I have because I want
//  the user to be able to read what's being shown to them.
//
//  I'm adding a little something to this now that I've used the app
//  for serveral days.  This was just too subtle, I find I really
//  want to know, for certain, that I hit the button.
//
//  So now the label background changes color.  It does this immediately
//  then fades back to the normal label after a second.  Now I know
//  I hit the button for sure.
//
- (void)displaySuccessMessageWithColor:(UIColor *)tappedColor
{
    self.successLabel.backgroundColor = tappedColor;
    self.successLabel.text = [self randomAwesomeThingOneCouldEnjoy];
    
    self.mapkepLabel.alpha = 0.0f;
    self.successLabel.alpha = 1.0f;
    
    [UIView animateWithDuration:1.0
                          delay:1.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         // Reset it
                         self.mapkepLabel.alpha = 1.0f;
                         self.successLabel.alpha = 0.0f;
                     }
                     completion:nil];
}


//  Boredom.  Apparently I have some of that.
//
- (NSString *)randomAwesomeThingOneCouldEnjoy
{
    NSArray * things = @[
        @"archer",
        @"blackalicious - the craft",
        @"breaking bad",
        @"cake",
        @"castle",
        @"chew",
        @"death cab for cutie",
        @"digital fortress",
        @"doctor who",
        @"electric six",
        @"firefly",
        @"galaxy quest",
        @"i, lucifer",
        @"john dies at the end",
        @"kate nash",
        @"lamb",
        @"mos def - the new danger",
        @"psych",
        @"public enemies: dueling writers",
        @"raiders of the lost ark",
        @"runaways",
        @"saga",
        @"sandman",
        @"sherlock",
        @"smoke & mirrors",
        @"the dead weather",
        @"the fifth element",
        @"the features",
        @"the fratellis",
        @"the phenomenauts",
        @"the pragmatic programmer",
        @"top gear",
        @"transmetropolitan",
        @"velvet",
        @"y the last man",
        @"yeah yeah yeahs"
    ];
    
    return things[arc4random_uniform((uint32_t)things.count)];
}


@end
