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
#import "NSString+FontAwesome.h"
#import "NSString+utils.h"
#import "Occurance.h"
#import "StatDetailViewController.h"


//  Tags for the three elements on the prototype cell
//  in the storyboard.
//

static int tag_icon         = 1337;
static int tag_icon_name    = 1338;
static int tag_last_tap     = 1339;
static int tag_total_taps   = 1340;


//  "Hah, I am so oaklandish"
//      ~ Me, quoting that line from that Kayne West song...
//        though I don't think it was Mr. West who said that.
//        <internetting...>  It was:
//  http://genius.com/1365236/Kanye-west-so-appalled/Hah-i-am-so-outrageous
//
//  (I'm hitting the hell out of the [no longer] green button
//  today... I have to decide what icon to use... hmm.)
//

@interface StatsOverviewViewController () <UITableViewDelegate>

@property (nonatomic, strong) NSDate * lastDataLoad;
@property (nonatomic, strong) NSMutableArray * mapkepObjects;
@property (nonatomic, strong) IBOutlet UITableView * mapkepTable;
@property BOOL sortIsRecentlyTapped;
@property (nonatomic, strong) IBOutlet UIButton * sortMostTappedButton;
@property (nonatomic, strong) IBOutlet UIButton * sortRecentlyTappedButton;

@end


@implementation StatsOverviewViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sortIsRecentlyTapped = YES;
	
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUI)
                                                 name:kNotification_MapkepContextUpdated
                                               object:nil];
    
    
    // Underline the text for the sort not currently
    // active (which is the 'most' text as we default
    //  to 'recent')
    
    [self underlineButtonLabel:self.sortMostTappedButton];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //  Taking a page from UITableViewController's book
    //  and un-highlighting the selected row here
    
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


- (void)removeUnderlineFromButton:(UIButton *)button
{
    NSMutableAttributedString * attr_text = [button.titleLabel.attributedText mutableCopy];
    
    [attr_text removeAttribute:NSUnderlineStyleAttributeName
                         range:NSMakeRange(0, [button.titleLabel.text length])];
    
    [button setAttributedTitle:attr_text
                      forState:UIControlStateNormal];
}


- (void)underlineButtonLabel:(UIButton *)button
{
    NSMutableAttributedString * attr_text = [[NSMutableAttributedString alloc] initWithString:button.titleLabel.text];
    
    [attr_text addAttribute:NSUnderlineStyleAttributeName
                      value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                      range:NSMakeRange(0, [attr_text length])];
    
    // I heart internet.  The color was changing when I underlined
    // my text, luckily a quick search yeilded an answer that lead
    // to the addAttribute below:
    // http://stackoverflow.com/a/15930032/686871
    
    [attr_text addAttribute:NSForegroundColorAttributeName
                      value:[COLOR_1 toUIColor]
                      range:NSMakeRange(0, [attr_text length])];
    
    [button setAttributedTitle:attr_text
                      forState:UIControlStateNormal];
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
        if (self.sortIsRecentlyTapped)
        {
            [self sortByRecentlyTapped];
        }
        else
        {
            [self sortByMostTapped];
        }
        
        self.lastDataLoad = [[NSDate alloc] init];
        
        [self.mapkepTable reloadData];
    }
}


- (void)sortByMostTapped
{
    self.mapkepObjects = [[self.mapkepObjects sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
    {
        NSUInteger record_count_for_a = ([(Mapkep *)a has_many_occurances] != nil) ?
                                            [(Mapkep *)a has_many_occurances].count :
                                            0;
        NSUInteger record_count_for_b = ([(Mapkep *)b has_many_occurances] != nil) ?
                                            [(Mapkep *)b has_many_occurances].count :
                                            0;
        
        // compare them
        
        if (record_count_for_a > record_count_for_b) return NSOrderedAscending;
        if (record_count_for_a < record_count_for_b) return NSOrderedDescending;
        return NSOrderedSame;
    }] mutableCopy];
}


- (void)sortByRecentlyTapped
{
    self.mapkepObjects = [[self.mapkepObjects sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
    {
        NSDate * date_for_a = ([(Mapkep *)a has_many_occurances] != nil) ?
                                [(Occurance *)[[(Mapkep *)a has_many_occurances] lastObject] createdAt] :
                                nil;
        NSDate * date_for_b = ([(Mapkep *)b has_many_occurances] != nil) ?
                                [(Occurance *)[[(Mapkep *)b has_many_occurances] lastObject] createdAt] :
                                nil;
        
        // compare them
        
        if (date_for_a == nil) return NSOrderedDescending;
        if (date_for_b == nil) return NSOrderedAscending;
        return [date_for_b compare:date_for_a];
    }] mutableCopy];
}


#pragma mark -
#pragma mark (IB)Action Jackson

//  See AddMapkepViewControllers's "cancel" if you're
//  wondering why I'm doing this instead of using a segue.
//
- (IBAction)back:(id)sender
{
    // Let us leave this place.
    //
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)sortByMostTapped:(id)sender
{
    if (self.sortIsRecentlyTapped)
    {
        self.sortIsRecentlyTapped = NO;
        [self removeUnderlineFromButton:self.sortMostTappedButton];
        [self underlineButtonLabel:self.sortRecentlyTappedButton];
        [self sortByMostTapped];
        [self.mapkepTable reloadData];
    }
}


- (IBAction)sortByRecentlyTapped:(id)sender
{
    if (!self.sortIsRecentlyTapped)
    {
        self.sortIsRecentlyTapped = YES;
        [self removeUnderlineFromButton:self.sortRecentlyTappedButton];
        [self underlineButtonLabel:self.sortMostTappedButton];
        [self sortByRecentlyTapped];
        [self.mapkepTable reloadData];
    }
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
    
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MapKepStatCell"];
	cell.tag = indexPath.row;
    
    
    //  The Backing Data
    
    Mapkep * mapkep = (Mapkep *)self.mapkepObjects[indexPath.row];
    
    
    //  The Icon
    
    UILabel * iconLabel = (UILabel *)[cell viewWithTag:tag_icon];
    iconLabel.font = FA_ICONS_FONT_HALF_SIZE;
    if (mapkep.faUInt == 0) mapkep.faUInt = [Mapkep defaultFAUInt];
    iconLabel.text = [NSString awesomeIcon:(int)mapkep.faUInt];
    iconLabel.textColor = [mapkep.hexColorCode toUIColor];
    
    
    //  The Name
    
    UILabel * nameLabel = (UILabel *)[cell viewWithTag:tag_icon_name];
    if (mapkep.name != nil && ![mapkep.name isEqual: @""])
    {
        [nameLabel setText:[NSString stringWithFormat:@"\"%@\"", mapkep.name]];
    }
    else
    {
        [nameLabel setText:@""];
    }
    
    
    //  The Last Occurence
    
    Occurance * lastOccurence = (mapkep.has_many_occurances != nil) ?
    mapkep.has_many_occurances.lastObject :
    nil;
    NSString * occurenceText = (lastOccurence != nil) ? [lastOccurence relativeTimeSinceLastOccerence] : @"never";
    [(UILabel *)[cell viewWithTag:tag_last_tap] setText:occurenceText];
    
    
    //  The Total
    
    NSString * total = (mapkep.has_many_occurances != nil) ?
                            [NSString stringWithFormat:@"%lu", (unsigned long)mapkep.has_many_occurances.count] :
                            @"0";
    [(UILabel *)[cell viewWithTag:tag_total_taps] setText:total];
    
    
    // The Return
    
    return cell;
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
