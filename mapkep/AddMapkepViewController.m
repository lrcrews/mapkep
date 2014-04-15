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
#import "UIColorPickerView.h"
#import "UIColor+utils.h"


@interface AddMapkepViewController ()

@property (nonatomic, strong) UIColorPickerView * uicolorPickerView;

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
    
    self.uicolorPickerView = [[UIColorPickerView alloc] initDefaultUIColorPickerAtYPoint:120.0f];
    [self.view addSubview:self.uicolorPickerView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(colorSelected:)
                                                 name:kNotification_ColorChosen
                                               object:nil];
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
    
    //  ...create a new instance of our object that knows how
    //  to save itself so we can...
    //
    Mapkep * newMapkep = [NSEntityDescription insertNewObjectForEntityForName:kKey_MapkepEntityName
                                                       inManagedObjectContext:context];
    newMapkep.name = self.nameTextField.text;
    newMapkep.hexColorCode = [self.addButton.backgroundColor toHexValue];
    
    DebugLog(@"Adding mapkep with name \"%@\" and color \"%@\"", newMapkep.name, newMapkep.hexColorCode);
    
    //  ...you know... save it.  Then we can...
    //
    NSError * error;
    if (![newMapkep save:error])
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
    //  give it a theme... Lucifer.  First, from Neil Gaiman's
    //  Sandman world we have "Lucifer", written by Mike Carey
    //  it is a fantastic read with great art (from various artists).
    //  Then There's "I, Lucifer" from Glen Duncan.  A proper book.
    //  It tells the tale of the tailed fallen angel as he posses
    //  a writer... Glen Duncan.  Fun.
    
    
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
- (IBAction)cancel:(id)sender
{
    // Let us leave this place.
    //
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)colorSelected:(NSNotification *)notification
{
    UIColor * chosenColor = [notification object];
    self.addButton.backgroundColor = chosenColor;
}

- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
}


@end
