//
//  EditMapkepViewController.m
//  mapkep
//
//  Created by L Ryan Crews on 12/1/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import "EditMapkepViewController.h"

#import "AppDelegate.h"
#import "Constants.h"
#import "Mapkep.h"
#import "NSString+FontAwesome.h"


@interface EditMapkepViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) IBOutlet UILabel * currentIcon;
@property (nonatomic, strong) IBOutlet UITextField * nameTextField;
@property (nonatomic, strong) IBOutlet UIButton * saveButton;

@property (nonatomic) int32_t chosenIconIntCode;

@end


@implementation EditMapkepViewController


#pragma mark -
#pragma mark View Lifecycle Hooks

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.nameTextField addTarget:self
                           action:@selector(textFieldFinished:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    // Set the font for the current icon
    
    self.currentIcon.font = FA_ICONS_FONT_TINY_SIZE;
    if (self.mapkep.faUInt == 0) self.mapkep.faUInt = [Mapkep defaultFAUInt];
    self.currentIcon.text = [NSString awesomeIcon:self.mapkep.faUInt];
    
    self.chosenIconIntCode = self.mapkep.faUInt;
    
    
    // Set the text feild text to the name
    
    self.nameTextField.text = self.mapkep.name;
    
    
    // Make the save button pretty
    
    self.saveButton.titleLabel.font = FA_ICONS_FONT_HALF_SIZE;
    [self.saveButton setTitle:[NSString awesomeIcon:FaCheck]
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

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)saveMapkep:(id)sender
{
    self.mapkep.name = self.nameTextField.text;
    self.mapkep.faUInt = self.chosenIconIntCode;
    self.mapkep.hexColorCode = [Mapkep defaultColorAsHexString];
    
    DebugLog(@"Updating mapkep with name \"%@\", color \"%@\", and icon code \"%lx\"", self.mapkep.name, self.mapkep.hexColorCode, (unsigned long)self.mapkep.faUInt);
    
    // save it
    
    NSError * error;
    if (![self.mapkep save:error])
    {
        AlwaysLog(@"Danger Will Robinson, mapkep creation failed.");
    }
    
    // disappear
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
}


- (IBAction)updateCurrentIcon:(id)sender
{
    self.chosenIconIntCode = [FA_ICON_HEX_VALUES[ [(UIButton *)sender tag] ] intValue];
    
    self.currentIcon.text = [NSString awesomeIcon:(int)self.chosenIconIntCode];
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
