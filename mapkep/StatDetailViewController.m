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
#import "NSString+utils.h"
#import "Occurance.h"


//  Tag values for elements in the storyboard
//
static int tag_day      = 1337;
static int tag_month    = 1338;
static int tag_year     = 1339;
static int tag_z_legend = 2337;


@interface StatDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSDateFormatter * dateFormatter;
@property (nonatomic, strong) IBOutlet UICollectionView * historyCollectionView;
@property (nonatomic, strong) IBOutlet UIScrollView * mainScrollView;
@property (nonatomic, strong) NSMutableDictionary * occurencesByDay;
@property (nonatomic, strong) NSMutableArray * occurencesByDayKeys;

@end


@implementation StatDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [self.primaryMapkep.hexColorCode toUIColor];
    [self.view viewWithTag:tag_z_legend].backgroundColor = [self.primaryMapkep.hexColorCode toUIColor];
    
    [self createOccurencesByDayHash];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.historyCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.occurencesByDayKeys.count - 1
                                                                           inSection:0]
                                       atScrollPosition:UICollectionViewScrollPositionLeft
                                               animated:YES];
}


- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter == nil)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterShortStyle];
    }
    
    return _dateFormatter;
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
    dayLabel.text = [NSString stringWithFormat:@"%d", components.day];
    //  month
    UILabel * monthLabel = (UILabel *)[cell viewWithTag:tag_month];
    monthLabel.text = [NSString stringWithFormat:@"%d", components.month];
    //  year
    UILabel * yearLabel = (UILabel *)[cell viewWithTag:tag_year];
    yearLabel.text = [NSString stringWithFormat:@"%d", components.year];
    
    
    // Always groups of five.
    //
    return cell;
}


@end
