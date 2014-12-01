//
//  AddMapkepViewController.m
//  mapkep
//
//  Created by L Ryan Crews on 2/15/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import "AddMapkepViewController.h"

#import "AppDelegate.h"
#import "Constants.h"
#import "Mapkep.h"
#import "NSString+FontAwesome.h"
#import "NSString+utils.h"
#import "UIColor+utils.h"


#define FA_BASE_HEX 0xf000


//  The Doctor is in
@interface AddMapkepViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) IBOutlet UIButton * addButton;
@property (nonatomic, strong) IBOutlet UIView * addStepTwoContainer;
@property (nonatomic, strong) IBOutlet UIButton * cancelButton;
@property (nonatomic, strong) IBOutlet UILabel * chosenIcon;
@property (nonatomic, strong) IBOutlet UICollectionView * mapkepCollectionView;
@property (nonatomic, strong) IBOutlet UITextField * nameTextField;

@property (nonatomic) int32_t chosenIconIntCode;

@end


@implementation AddMapkepViewController


#pragma mark -
#pragma mark Viewing

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.nameTextField addTarget:self
                           action:@selector(textFieldFinished:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    // Set the font for the chosen icon
    
    self.chosenIcon.font = FA_ICONS_FONT;
    self.chosenIcon.text = [NSString awesomeIcon:FaCircle];
    
    
    // Set up the non-mapkep button(s)
    
    UIFont * fa_font = FA_ICONS_FONT_HALF_SIZE;
    
    // The "cancel" button (visible in step two overlay)
    
    self.cancelButton.titleLabel.font = fa_font;
    
    [self.cancelButton setTitle:[NSString awesomeIcon:FaTimesCircle]
                       forState:UIControlStateNormal];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //  Mos Def
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
#pragma mark Reacting

- (IBAction)addMapkep:(id)sender
{
    //  Let's grab our coredata context so we can...
    //
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = [appDelegate managedObjectContext];
    
    //  ...create the instance of our object that knows how
    //  to save itself so we can...
    //
    Mapkep * mapkep = [NSEntityDescription insertNewObjectForEntityForName:kKey_MapkepEntityName
                                                    inManagedObjectContext:context];

    mapkep.name = self.nameTextField.text;
    mapkep.faUInt = self.chosenIconIntCode;
    mapkep.hexColorCode = [Mapkep defaultColorAsHexString];
    
    DebugLog(@"Adding/Updating mapkep with name \"%@\", color \"%@\", and icon code \"%lx\"", mapkep.name, mapkep.hexColorCode, (unsigned long)mapkep.faUInt);
    
    //  ...you know... save it.  Then we can...
    //
    NSError * error;
    if (![mapkep save:error])
    {
        AlwaysLog(@"Danger Will Robinson, mapkep creation failed.");
    }
    
    //  ... tell others what we saw here today, which
    //  means all that's left is to...
    //
    //  It's been removed??!?  Why Lisa, Why?
    //
    //  Well, because it was silly.  This controller should
    //  not be the one responsible for sending the notification
    //  for updating the core data context, the model should.
    //
    //  I see why it didn't occur to me when all I had was the
    //  ability to add a Mapkep object; I just had one notification,
    //  "kNotification_MapkepAdded".  This is where I added it,
    //  so this is where I put that.  It worked, I moved on.
    //
    //  And that's all well in good.  Goal defined, goal achieved,
    //  continue towards the MVP.  But this brings up a good
    //  practice that so many avoid; the refactor.
    //
    //  Refactoring is just looking at an existing pattern in
    //  your code and realizing that it can be improved in some
    //  way towards some end.  In this case, proper separation
    //  of concerns will prevent the need for additional code
    //  later.
    //
    //  First, my naming was odd.  "kNotification_MapkepAdded"
    //  would imply I now need a "Deleted" (the functionality
    //  I'm adding right now) and may latter need an "Edited".
    //  Why do I need those?  So UI will update of course.  Wait.
    //  If my current (and foreseeable future) use is just to
    //  refresh UI why have three notification names.  Hence,
    //  "kNotification_MapkepContextUpdated" now exists.
    //
    //  Secondly, its location (previously here) is wrong.  You
    //  might think there's some rather deep theoretical reason
    //  for this, and there surely is, but the best reason I
    //  can think of is a simple one: if the Model (Mapkep) sends
    //  the notification, then I don't ever have to write that
    //  line of code again.  If I create some new flow that creates
    //  a Mapkep object, it will automatically post the notification.
    //  I don't have to think about it anymore.  Beauty.
    //
    //  Thirdly, well, there is no thirdly, secondly really does
    //  the trick, but you read a lot, so you earned a reward.
    //  Recomendations for reading!  That's cool... right?  Let's
    //  give it a theme... Lucifer.
    //
    //  First, from Neil Gaiman's Sandman world we have "Lucifer",
    //  written by Mike Carey it is a fantastic read with great
    //  art (from various artists). Then There's "I, Lucifer" by
    //  Glen Duncan.  A proper book.  It tells the tale of the
    //  tailed fallen angel as he posses a writer... Glen Duncan.  Fun!
    
    
    //  ...transition away.  Hooray!
    //
    [self dismissViewControllerAnimated:YES completion:nil];
}


//  Remember, don't use a segue to get back to your previous
//  controller, that's not what they do.  They go forward.
//  They only go forward.  If you were to segue "back" you
//  would actually be creating a new instance of that controller
//  that's now sitting on top of this one AND the one you
//  wanted to go back to.  There's potential galore for bugs
//  with that happening.
//
- (IBAction)back:(id)sender
{
    // Let us leave this place.
    //
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)cancel:(id)sender
{
    self.chosenIconIntCode = 0;
    
    [UIView animateWithDuration:1.0
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.addStepTwoContainer.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         self.addStepTwoContainer.hidden = true;
                         self.chosenIcon.text = [NSString awesomeIcon:FaCircle];
                     }];
}


- (IBAction)showStepTwo:(id)sender
{
    self.chosenIconIntCode = [FA_ICON_HEX_VALUES[ [(UIButton *)sender tag] ] intValue];
    
    self.chosenIcon.font = FA_ICONS_FONT;
    self.chosenIcon.text = [NSString awesomeIcon:(int)self.chosenIconIntCode];
    
    self.addStepTwoContainer.hidden = false;
    
    [UIView animateWithDuration:1.0
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.addStepTwoContainer.alpha = 1.0f;
                     }
                     completion:nil];
}


- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
}


#pragma mark -
#pragma mark UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return FA_ICON_HEX_VALUES.count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //  mapkepAddCell is the name set on the prototype cell in the storyboard.
    //
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mapkepAddCell"
                                                                            forIndexPath:indexPath];
    
    
    //  add our indexPath.row value to 0xf000
    //  ...damn, they're not sequential, there's too many holes to do this =(
    //  instead I've defined an array constant in Contansts named FA_ICON_HEX_VALUES
    //
    //FaIcon faHexValue = FA_BASE_HEX + (int)indexPath.row;
    
    
    //  Get the subview we need from the cell
    //
    UIButton * button = nil;
    
    for (UIView * view in cell.contentView.subviews)
    {
        if ([view isKindOfClass:UIButton.class])
        {
            button = (UIButton *)view;
        }
    }
    
    
    //  Set the hex code needed to display the icon
    //
    [button setTag:indexPath.row];
    
    button.titleLabel.font = FA_ICONS_FONT;
    
    [button setTitle:[NSString awesomeIcon:[FA_ICON_HEX_VALUES[indexPath.row] intValue]]
            forState:UIControlStateNormal];
    
    
    //  Give the people what they want
    //
    //return bacon;  // no... not that.
    return cell;
}


@end
