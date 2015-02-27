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

@property (nonatomic, strong) NSArray * mapkepObjects;

@property (nonatomic, strong) IBOutlet UICollectionView * mapkepCollectionView;

@property (nonatomic, strong) IBOutlet UILabel * mapkepLabel;
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
                                                 name:NOTIFICATION_MAPKEP_CONTEXT_UPDATED
                                               object:nil];
    
    // Set up the non-mapkep buttons
    
    UIFont * faFont = FA_ICONS_FONT_THIRD_SIZE;
    
    UIButton * addButton = (UIButton *)[self.view viewWithTag:tag_add];
    UIButton * gitAndStuffButton = (UIButton *)[self.view viewWithTag:tag_git];
    UIButton * statsButton = (UIButton *)[self.view viewWithTag:tag_stats];
    
    // TODO: should really break out the bottom nav into
    // a reusable view that takes in three uibutton references
    
    // the left button (remove mapkep)
    
    gitAndStuffButton.titleLabel.font = faFont;
    
    [gitAndStuffButton setTitle:[NSString awesomeIcon:FaQuestion]
                       forState:UIControlStateNormal];
    
    CALayer * gitAndStuffLayer = [gitAndStuffButton layer];
    gitAndStuffLayer.borderWidth = 1.0f;
    gitAndStuffLayer.borderColor = [COLOR_1 toUIColor].CGColor;
    
    // the middle button (add mapkep)
    
    addButton.titleLabel.font = faFont;
    
    [addButton setTitle:[NSString awesomeIcon:FaPlus]
               forState:UIControlStateNormal];
    
    CALayer * addLayer = [addButton layer];
    addLayer.borderWidth = 1.0f;
    addLayer.borderColor = [COLOR_1 toUIColor].CGColor;
    
    // the right button (occurence stats)
    
    statsButton.titleLabel.font = faFont;
    
    [statsButton setTitle:[NSString awesomeIcon:FaBarChartO]
                 forState:UIControlStateNormal];
    
    CALayer * statsLayer = [statsButton layer];
    statsLayer.borderWidth = 1.0f;
    statsLayer.borderColor = [COLOR_1 toUIColor].CGColor;
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
    
    // ...add the relationship to the tapped Mapkep
    // and then...
    //
    // (in my opinion this reads better than the helper
    //  method coredata provides 'add<child>Object:' on
    //  the parent).
    
    Mapkep * tappedMapkep = self.mapkepObjects[ [sender tag] ];
    newOccurance.belongs_to_mapkep = tappedMapkep;
    
    DebugLog(@"Adding occurence to mapkep with name \"%@\" and color \"%@\"", tappedMapkep.name, tappedMapkep.hexColorCode);
    
    // ...you know... save it.  Then we can...
    
    NSError * error;
    if (![newOccurance save:error])
    {
        AlwaysLog(@"Danger Will Robinson, occrence creation failed.");
    }
    
    // ...let the user know the button led to magic, hooray!
    
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

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.mapkepObjects.count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // "MapkepButtonCell" is the name set on the prototype cell in the storyboard.
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MapkepButtonCell"
                                                                            forIndexPath:indexPath];
    
    // Get the two subview we need from the cell
    
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
    
    // Get the backing object for this UI
    
    Mapkep * mapkep = (Mapkep *)self.mapkepObjects[indexPath.row];
    
    // Get the two things together
    
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
    
    // GTFO, cell
    
    return cell;
}


#pragma mark -
#pragma mark Button Tap Animation

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
        @"east of west",
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
        @"ruby",
        @"rust",
        @"saga",
        @"sandman",
        @"sherlock",
        @"swift",
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
