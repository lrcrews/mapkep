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


@interface StatsOverviewViewController () <UITableViewDelegate>

@property (nonatomic, strong) NSDate * lastDataLoad;
@property (nonatomic, strong) NSArray * mapkepObjects;
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
        
        [self setMapkepObjects:[Mapkep allWithManagedObjectContext:context]];
        
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
	
    Mapkep * mapkep = (Mapkep *)self.mapkepObjects[indexPath.row];
    
    
    //  These tags are set up in the storyboard, and, although
    //  we can't reference the contants in the storyboard, the
    //  Constants file is where these exist just in case we add
    //  features in the future that also require unique tags we
    //  may quickly see the tags already in use.
    
    
    //  The (Color) Header
    //
    [[cell viewWithTag:tag_MapKepColor] setBackgroundColor:[mapkep.hexColorCode toUIColor]];
    
    
    //  The Name
    //
    UILabel * nameLabel = (UILabel *)[cell viewWithTag:tag_MapKepTitle];
    [nameLabel setText:[mapkep name]];
    
    
    
    //  The Total
    //
    NSString * total = (mapkep.has_many_occurances != nil) ?
                            [NSString stringWithFormat:@"%lu", (unsigned long)mapkep.has_many_occurances.count] :
                            @"0";
    [(UILabel *)[cell viewWithTag:tag_TotalCount] setText:total];
    
    
    //  The Last Occurence
    //
    Occurance * lastOccurence = (mapkep.has_many_occurances != nil) ?
                                    mapkep.has_many_occurances.lastObject :
                                    nil;
    NSString * occurenceText = (lastOccurence != nil) ? [lastOccurence relativeTimeSinceLastOccerence] : @"never";
    [(UILabel *)[cell viewWithTag:tag_LastOccurence] setText:occurenceText];
    
    
    
    return cell;
}


@end
