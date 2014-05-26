//
//  StatsOverviewViewController.m
//  mapkep
//
//  Created by L Ryan Crews on 3/11/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import "StatsOverviewViewController.h"

#import "AppDelegate.h"
#import "Constants.h"
#import "Mapkep.h"
#import "NSString+utils.h"
#import "Occurance.h"
#import "StatDetailViewController.h"


//  I read this on the Internet, it must be true.
//
#define RADIAN_VALUE_FOR_45_DEGREES (0.785398163f)

//  Tag values for elements in the storyboard
//
static int tag_DisclosureArrow = 1342;
static int tag_LastOccurence   = 1337;
static int tag_MapKepColorH    = 1338;
static int tag_MapKepColorH2   = 1343;
static int tag_MapKepColorV    = 1341;
static int tag_MapKepTitle     = 1339;
static int tag_TotalCount      = 1340;


@interface StatsOverviewViewController () <UITableViewDelegate>

@property (nonatomic, strong) NSDate * lastDataLoad;
@property (nonatomic, strong) NSMutableArray * mapkepObjects;
@property (nonatomic, strong) IBOutlet UITableView * mapkepTable;

@end


@implementation StatsOverviewViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUI)
                                                 name:kNotification_MapkepContextUpdated
                                               object:nil];
}


//  Taking a page from UITableViewController's book
//  and un-highlighting the selected row here.
//
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapkepTable deselectRowAtIndexPath:[self.mapkepTable indexPathForSelectedRow]
                                    animated:YES];
}


- (void)viewWillUnload:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //  The New Danger
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
#pragma mark Edgar Wright off of Ant Man?!?!?!!

- (void)refreshUI
{
    [self.mapkepTable reloadData];
}


#pragma mark -
#pragma mark Brent Spiner

//  I find myself opening the app when it's already
//  on the stats page and wishing the 'last occurence'
//  times were accurate.  So now they shall be damnit.
//
//  By the way...
//
//  The app is live now!  Hooray app!
//
//  Hey look, there's beer!  Hooray beer!
//
- (void)loadData
{
    if (self.lastDataLoad == nil
     || [self.lastDataLoad timeIntervalSinceNow] < -300.0f)
    {
        AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext * context = [appDelegate managedObjectContext];
        
        [self setMapkepObjects:[[Mapkep allWithManagedObjectContext:context] mutableCopy]];
        
        self.lastDataLoad = [[NSDate alloc] init];
        
        [self.mapkepTable reloadData];
    }
}


#pragma mark -
#pragma mark (IB)Action Jackson

//  See AddMapkepViewControllers's "cancel" if you're
//  wondering why I'm doing this instead of using a segue.
//
- (IBAction)home:(id)sender
{
    // Let us leave this place.
    //
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 
#pragma mark UITableView Stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return [self.mapkepObjects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  This needs to match the string in the prototype cell's
    //  reuse identifier in our story board or else... it won't work.
    //
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MapKepStatCell"];
	cell.tag = indexPath.row;
    
    
    Mapkep * mapkep = (Mapkep *)self.mapkepObjects[indexPath.row];
    
    
    //  These tags are set up in the storyboard, and, although
    //  we can't reference the contants in the storyboard, the
    //  Constants file is where these exist just in case we add
    //  features in the future that also require unique tags we
    //  may quickly see the tags already in use.
    
    
    //  The (Color) Header/Side/Footer
    //
    [[cell viewWithTag:tag_MapKepColorH] setBackgroundColor:[mapkep.hexColorCode toUIColor]];
    [[cell viewWithTag:tag_MapKepColorH2] setBackgroundColor:[mapkep.hexColorCode toUIColor]];
    [[cell viewWithTag:tag_MapKepColorV] setBackgroundColor:[mapkep.hexColorCode toUIColor]];
    
    
    //  The Name
    //
    UILabel * nameLabel = (UILabel *)[cell viewWithTag:tag_MapKepTitle];
    [nameLabel setText:[mapkep name]];
    
    
    //  The Last Occurence
    //
    Occurance * lastOccurence = (mapkep.has_many_occurances != nil) ?
    mapkep.has_many_occurances.lastObject :
    nil;
    NSString * occurenceText = (lastOccurence != nil) ? [lastOccurence relativeTimeSinceLastOccerence] : @"never";
    [(UILabel *)[cell viewWithTag:tag_LastOccurence] setText:occurenceText];
    
    
    
    //  The Total
    //
    NSString * total = (mapkep.has_many_occurances != nil) ?
                            [NSString stringWithFormat:@"%lu", (unsigned long)mapkep.has_many_occurances.count] :
                            @"0";
    [(UILabel *)[cell viewWithTag:tag_TotalCount] setText:total];
    
    
    //  The Disclosure Arrow
    //
    if ([cell viewWithTag:tag_DisclosureArrow] == nil)
    {
        UIView * disclosureArrow = [[UIView alloc] initWithFrame:CGRectMake(291.0f, 48.0f, 10.0f, 10.0f)];
        disclosureArrow.tag = tag_DisclosureArrow;
        disclosureArrow.backgroundColor = [UIColor whiteColor];
        disclosureArrow.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIAN_VALUE_FOR_45_DEGREES);
        [cell addSubview:disclosureArrow];
    }
    
    
    
    return cell;
}


//  You mean to tell me it's this easy to delete something?
//  Shut the front door!
//
-  (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Mapkep * mapkep = (Mapkep *)self.mapkepObjects[indexPath.row];
        NSError * error;
        if (![mapkep deleteSelf:error])
        {
            AlwaysLog(@"I'm a mog, half man, half dog.  I'm my own best friend!");
        }
        
        [self.mapkepObjects removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark -
#pragma mark Daniel Tosh

//  Seriously, he has really good segues.
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    //  So we just set up the identifier in the storyboard
    //
    if ([segue.identifier isEqualToString:kSegue_ToMapkepDetail])
    {
        //  If we're seguing b/c of it we then get the controller
        //  it's going to and set the Mapkep it needs to display
        //  the data.
        //
        StatDetailViewController * controller = (StatDetailViewController *)segue.destinationViewController;
        controller.primaryMapkep = (Mapkep *)self.mapkepObjects[ [(UIView *)sender tag] ];
    }
}


@end
