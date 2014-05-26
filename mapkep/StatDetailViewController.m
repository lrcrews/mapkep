//
//  StatDetailViewController.m
//  mapkep
//
//  Created by L Ryan Crews on 4/20/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import "StatDetailViewController.h"

#import "Constants.h"
#import "Mapkep.h"
#import "MapkepOccurencesTableViewController.h"
#import "NSString+utils.h"
#import "Occurance.h"



// TODO:
//  need to break out each view into a custom view to allow for
//  easy adding / removing of stats views from the community.
//  Along with any performance requirements they must also be
//  implemented in such a way that they have a title label
//  called "titleLabel" so that a single call below may set the
//  color of that label to the MapKep color (to help the user
//  remember which detail section they're in).
//
//  and you know, actually externalize your own shit down there.


// TODO:
//  with the above done, insert a seperator between each stat
//  view.  a 10px tall section, with a 2px tall 'black' separator.



//  Tag values for elements in the storyboard
//
static int tag_day      = 1337;
static int tag_month    = 1338;
static int tag_year     = 1339;
static int tag_z_legend = 2337;
static int tag_z_title  = 2338;
static int tag_z2_title = 2339;


@interface StatDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSDateFormatter * dateFormatter;
@property (nonatomic, strong) NSDateFormatter * dateAndTimeFormatter;
@property (nonatomic, strong) IBOutlet UILabel * daysWithOccurencesInLast30;
@property (nonatomic, strong) IBOutlet UICollectionView * historyCollectionView;
@property (nonatomic, strong) IBOutlet UILabel * lastLastTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel * lastTimeLabel;
@property (nonatomic, strong) IBOutlet UIScrollView * mainScrollView;
@property (nonatomic, strong) NSMutableDictionary * occurencesByDay;
@property (nonatomic, strong) NSMutableArray * occurencesByDayKeys;

@end


@implementation StatDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ((UILabel *)[self.view viewWithTag:tag_z_title]).textColor = [self.primaryMapkep.hexColorCode toUIColor];
    ((UILabel *)[self.view viewWithTag:tag_z2_title]).textColor = [self.primaryMapkep.hexColorCode toUIColor];
    [self.view viewWithTag:tag_z_legend].backgroundColor = [self.primaryMapkep.hexColorCode toUIColor];
    
    [self createOccurencesByDayHash];
    
    self.daysWithOccurencesInLast30.text = [self daysWithOccurenceInPreviousX:30];
    self.lastTimeLabel.text = [self theLastTime];
    self.lastLastTimeLabel.text = [self theLastLastTime];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.historyCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.occurencesByDayKeys.count - 1
                                                                           inSection:0]
                                       atScrollPosition:UICollectionViewScrollPositionLeft
                                               animated:YES];
}


//  "Create it when you need it!"  ~ Lazy Initialization
//
//  This is a pattern where the creation (and in this case
//  a configuration) isn't done until it is needed.  After
//  the first call '_dateFormatter', the wonderful instance
//  variable of our property dateFormatter, will be created,
//  then every subsequent call will simply return what was
//  made in that first call.
//
- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter == nil)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterShortStyle];
    }
    
    return _dateFormatter;
}


- (NSDateFormatter *)dateAndTimeFormatter
{
    if (_dateAndTimeFormatter == nil)
    {
        _dateAndTimeFormatter = [[NSDateFormatter alloc] init];
        [_dateAndTimeFormatter setDateFormat:@"MMM d, yyyy - h:mm a"];
    }
    
    return _dateAndTimeFormatter;
}


#pragma mark -
#pragma mark Right at the Barn

- (void)createOccurencesByDayHash
{
    // This will track how many occurences
    // occured in each hour of a day.
    //
    NSArray * occurencesByHours = @[ @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0,
                                     @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0];
    
    // This primes our sets
    //
    self.occurencesByDay = [@{} mutableCopy];
    self.occurencesByDayKeys = [@[] mutableCopy];
    
    for (Occurance * occurence in self.primaryMapkep.has_many_occurances)
    {
        // Stringify Date as it will be a key
        // in our hash.
        //
        NSString * date_as_string = [self.dateFormatter stringFromDate:occurence.createdAt];
        
        // Add the base data for the date if needed.
        //
        if (self.occurencesByDay[date_as_string] == nil)
        {
            self.occurencesByDay[date_as_string] = [occurencesByHours mutableCopy];
            [self.occurencesByDayKeys addObject:date_as_string];
        }
        
        // Determine the hour so...
        //
        NSCalendar * calendar = [NSCalendar currentCalendar];
        NSDateComponents * components = [calendar components:NSHourCalendarUnit
                                                    fromDate:occurence.createdAt];
        NSInteger hour = [components hour];
        
        // ...we may increment that value.
        //
        [self incrementOccurenceCountInArray:self.occurencesByDay[date_as_string]
                                     atIndex:hour];
    }
}


- (void)incrementOccurenceCountInArray:(NSMutableArray *)occurenceHours
                               atIndex:(NSInteger)index
{
    int currentCount = [(NSNumber *)occurenceHours[ index ] intValue];
    currentCount++;
    occurenceHours[ index ] = [NSNumber numberWithInt:currentCount];
}


#pragma mark -
#pragma mark And A Big Red Button

//  This relies on self.occurencesByDay existing
//  (so, you know, don't call it before that's built)
//
- (NSString *)daysWithOccurenceInPreviousX:(NSInteger)days
{
    BOOL dailyActivity = NO;
    
    NSDate * currentDate = [NSDate date];
    NSDateComponents * dateComponents = [[NSDateComponents alloc] init];
    
    // We're going to say 7 days in a row out of the
    // last 8 (counting today, but not requiring it)
    // or 25 days total out of the last 30 is a daily
    // habbit.
    //
    NSInteger days_with_occurence_count = 0;
    for (int i = 0; i < days; i++)
    {
        // Update the date component's day offset
        //
        [dateComponents setDay:-i];
        
        // Make our test date so we can make a key
        //
        NSDate * testDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                                          toDate:currentDate
                                                                         options:0];
        NSString * testKey = [self.dateFormatter stringFromDate:testDate];
        
        // Increment our count (if we should)
        //
        if (self.occurencesByDay[ testKey ] != nil)
        {
            days_with_occurence_count++;
        }
        
        // See if it passes our critia
        //
        if ( (i == 6 || i == 7) && days_with_occurence_count == 7)  dailyActivity = YES;
        if (days_with_occurence_count >= 25)                        dailyActivity = YES;
    }
    
    // Let's write something
    //
    //  It's a daily thing
    //
    if (dailyActivity) return [NSString stringWithFormat:@"You've tapped this %ld different days over the previous %ld days, it's looking like a daily thing.", (long)days_with_occurence_count, (long)days];
    
    //  It's a 'not a daily thing' thing
    //
    return [NSString stringWithFormat:@"You tapped this little button %ld different days in the last %ld day.", (long)days_with_occurence_count, (long)days];
}


- (NSString *)theLastTime
{
    if (self.primaryMapkep.has_many_occurances.count > 0)
    {
        Occurance * lastOccurence = self.primaryMapkep.has_many_occurances.lastObject;
        return [NSString stringWithFormat:@"The last time you tapped this button was %@", [self.dateAndTimeFormatter stringFromDate:lastOccurence.createdAt]];
    }
    else
    {
        return @"You've never tapped this button.";
    }
}


- (NSString *)theLastLastTime
{
    NSInteger occurenceCount = self.primaryMapkep.has_many_occurances.count;
    
    if (occurenceCount > 1)
    {
        Occurance * lastLastOccurence = self.primaryMapkep.has_many_occurances[ occurenceCount - 2 ];
        return [NSString stringWithFormat:@"The last time you tapped this, before the last time you tapped this, was %@", [self.dateAndTimeFormatter stringFromDate:lastLastOccurence.createdAt]];
    }
    else if (occurenceCount == 1)
    {
        return @"You've only tapped this button once.";
    }
    else
    {
        return @"";
    }
}


#pragma mark -
#pragma mark You Can't Touch This

//  See AddMapkepViewControllers's "cancel" if you're
//  wondering why I'm doing this instead of using a segue.
//
- (IBAction)stats:(id)sender
{
    // 88mph
    //
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark UICollectionView Datasource

// 1
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.occurencesByDay.count;
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
    // HistoryCell is the name set on the prototype cell in the storyboard.
    //
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryCell"
                                                                            forIndexPath:indexPath];
    
    
    // Get the occurences out of their Russian Nesting Doll.
    //
    NSArray * occurencesByHour = self.occurencesByDay[ self.occurencesByDayKeys[ indexPath.row ] ];
    
    
    // Paint the town.
    //
    //      we start the tags at 100 instead of 0 to avoid the
    //      issue that arises due to UIView tags defaulting to
    //      0.  (viewWithTag:0 returns unwanted uiviews).
    //
    NSInteger tagOfView = 100;
    for (NSNumber * occurences in occurencesByHour)
    {
        // Get the count
        int count = [occurences intValue];
        // Get the UIView
        UIView * hourCell = [cell viewWithTag:tagOfView];
        // Set the background color
        switch (count) {
            case 0:
                hourCell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 1:
                hourCell.backgroundColor = [self.primaryMapkep.hexColorCode toUIColor];
                break;
                
            case 2:
                hourCell.backgroundColor = [UIColor lightGrayColor];
                break;
                
            case 3:
                hourCell.backgroundColor = [UIColor darkGrayColor];
                break;
                
            default:
                hourCell.backgroundColor = [UIColor blackColor];
                break;
        }
        // Up the tagOfView value
        tagOfView++;
    }
    
    
    // Make sure the day/month/year labels are correct
    //
    NSDate * date = [self.dateFormatter dateFromString:self.occurencesByDayKeys[ indexPath.row ]];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * components = [calendar components:( NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit )
                                                fromDate:date];
    //  day
    UILabel * dayLabel = (UILabel *)[cell viewWithTag:tag_day];
    dayLabel.text = [NSString stringWithFormat:@"%ld", (long)components.day];
    //  month
    UILabel * monthLabel = (UILabel *)[cell viewWithTag:tag_month];
    monthLabel.text = [NSString stringWithFormat:@"%ld", (long)components.month];
    //  year
    UILabel * yearLabel = (UILabel *)[cell viewWithTag:tag_year];
    yearLabel.text = [NSString stringWithFormat:@"%ld", (long)components.year];
    
    
    // Always groups of five.
    //
    return cell;
}


#pragma mark - 
#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    //  So we just set up the identifier in the storyboard
    //
    //  ahhh.... I just copy pasted this from somewhere else
    //  read this note while highlighting it to replace it,
    //  and realized 'hah, I need to do that'.
    //
    if ([segue.identifier isEqualToString:k_segue_to_history_table])
    {
        //  I aim to misbehave
        //
        MapkepOccurencesTableViewController * controller = (MapkepOccurencesTableViewController *)segue.destinationViewController;
        controller.occurences = [self.primaryMapkep.has_many_occurances array];
    }
}


@end
