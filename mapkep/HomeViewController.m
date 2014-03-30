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
#import "MapkepButton.h"
#import "NSString+utils.h"
#import "Occurance.h"


@interface HomeViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray * mapkepObjects;

@end


@implementation HomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = [appDelegate managedObjectContext];
    
    [self setMapkepObjects:[Mapkep allWithManagedObjectContext:context]];
}


- (IBAction)buttonPressed:(id)sender
{
    NSLog(@"sender tag %ld", (long)[sender tag]);
    //  Let's grab our coredata context so we can...
    //
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = [appDelegate managedObjectContext];
    
    //  ...create a new instance of our event's occurance
    //  that knows how to save itself so we can...
    //
    Occurance * newOccurance = [NSEntityDescription insertNewObjectForEntityForName:kKey_OccurenceEntityName
                                                             inManagedObjectContext:context];
    newOccurance.createdAt = [NSDate date];
    
    //  ...add the relationship to the tapped Mapkep
    //  and then...
    //
    //  (in my opinion this reads better than the helper
    //  method coredata provides 'add<child>Object:' on
    //  the parent).
    //
    Mapkep * tappedMapkep = self.mapkepObjects[[sender tag]];
    newOccurance.belongs_to_mapkep = tappedMapkep;
    
    DebugLog(@"Adding occurence to mapkep with name \"%@\" and color \"%@\"", tappedMapkep.name, tappedMapkep.hexColorCode);
    
    //  ...you know... save it.  Then we can...
    //
    NSError * error;
    if (![newOccurance save:error])
    {
        AlwaysLog(@"Danger Will Robinson, occrence creation failed.");
    }
    
    //  ...let the user know the button led to magic, hooray!
    //
    [self displaySuccessMessageWithColor:[tappedMapkep.hexColorCode toUIColor]];
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
    //
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MapkepButtonCell" forIndexPath:indexPath];
    
    Mapkep * mapkep = (Mapkep *)self.mapkepObjects[indexPath.row];
    
    DebugLog(@"mapkep occurences: %lu", (unsigned long)mapkep.has_many_occurances.count);
    
    MapkepButton * button = [[MapkepButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, BUTTON_WIDTH, BUTTON_HEIGHT)
                                                          color:[mapkep.hexColorCode toUIColor]];
    
    //  What we want to do and when we want to do it.
    //
    [button addTarget:self
               action:@selector(buttonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    
    //  How we know which mapkep to add an event to.
    //
    button.tag = indexPath.row;
    
    //  Seeing it is always nice.
    //
    [cell addSubview:button];
    
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
//  directed one extremely well]) with a looser action thats funny
//  style, like a Kiss Kiss Bang Bang, for Hawkeye (as currently
//  written by Mark Waid).  Are you imagining it?  Now add bacon.
//  That's how good it culd be, better than ballons, kittens, babies,
//  and others.
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
- (void)displaySuccessMessageWithColor:(UIColor *)tappedColor
{
    [UIView animateWithDuration:1.0
                          delay:0
                        options:( UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseOut )
                     animations:^{
                         self.mapkepLabel.alpha = 0.0f;
                         self.successLabel.textColor = tappedColor;
                         self.successLabel.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         // Reset it
                         self.mapkepLabel.alpha = 1.0f;
                         self.successLabel.alpha = 0.0f;
                         self.successLabel.textColor = [FONT_MAIN toUIColor];
                     }];
}


@end
