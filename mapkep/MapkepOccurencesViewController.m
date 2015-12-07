//
//  MapkepOccurencesViewController.m
//  mapkep
//
//  Created by L Ryan Crews on 5/4/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import "MapkepOccurencesViewController.h"

#import "Constants.h"
#import "Mapkep.h"
#import "NSString+FontAwesome.h"
#import "Occurance.h"


//  Tag values for elements in the storyboard
//
static int tag_occurence_time = 1337;


@interface MapkepOccurencesViewController ()<UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton * backButton;
@property (nonatomic, strong) IBOutlet UILabel * iconLabel;
@property (nonatomic, strong) IBOutlet UILabel * nameLabel;

@property (nonatomic, strong) IBOutlet UITableView * tapsTableView;

@end


@implementation MapkepOccurencesViewController


#pragma mark -
#pragma mark Too Legit

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the icon and the name
    
    self.nameLabel.text = self.primaryMapkep.name;
    
    UIFont * faFont = FA_ICONS_FONT_HALF_SIZE;
    
    self.iconLabel.font = faFont;
    if (self.primaryMapkep.faUInt == 0) self.primaryMapkep.faUInt = [Mapkep defaultFAUInt];
    self.iconLabel.text = [NSString awesomeIcon:self.primaryMapkep.faUInt];
    
    // Everybody has a plan
    
    self.backButton.titleLabel.font = faFont;
    
    [self.backButton setTitle:[NSString awesomeIcon:FaTimesCircle]
                     forState:UIControlStateNormal];
    
    // 'till they get punched in the face
    
    self.tapsTableView.layoutMargins = UIEdgeInsetsZero;
}


#pragma mark -
#pragma mark You Can't Touch This

//  See AddMapkepViewControllers's "cancel" if you're
//  wondering why I'm doing this instead of using a segue.
//
- (IBAction)backToStatDetail:(id)sender
{
    // May the 4th be with you
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    // < and also with you >?
}


#pragma mark - 
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.occurences.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OccurenceCell"
                                                             forIndexPath:indexPath];
    
    cell.layoutMargins = UIEdgeInsetsZero;
    
    Occurance * occurence = self.occurences[ indexPath.row ];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d, yyyy - h:mm a"];
    
    UILabel * occurence_time_label = (UILabel *)[cell viewWithTag:tag_occurence_time];
    occurence_time_label.text = [dateFormatter stringFromDate:occurence.createdAt];
    
    return cell;
}


-  (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Occurance * occurence = self.occurences[ indexPath.row ];
        NSError * error;
        if (![occurence deleteSelf:error])
        {
            AlwaysLog(@"Ah yes, looks like you have a bad infestation here.  You'll have drum circles soon.");
            DebugLog(@"error: %@", error);
        }
        
        [self.occurences removeObjectAtIndex:indexPath.row];
        [self.tapsTableView reloadData];
    } 
}


@end
