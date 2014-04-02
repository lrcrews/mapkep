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
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_MapkepAdded
                                                        object:nil];
    
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
