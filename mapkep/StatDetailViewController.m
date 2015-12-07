//
//  StatDetailViewController.m
//  mapkep
//
//  Created by L Ryan Crews on 4/20/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import "StatDetailViewController.h"

#import "Constants.h"
#import "EditMapkepViewController.h"
#import "Mapkep.h"
#import "MapkepOccurencesViewController.h"
#import "NSString+FontAwesome.h"
#import "NSString+utils.h"
#import "Occurance.h"


#define HISTORY_CELL_BAR_HEIGHT 93.0f
#define HISTORY_CELL_BAR_TAG 1337
#define HISTORY_CELL_DAY_TAG 1338
#define HISTORY_CELL_FILL_TAG 1339


@interface StatDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) int highestOccurenceCountForADay;

@property (nonatomic) NSInteger averageSecondsBetween;
@property (nonatomic) NSInteger secondsSinceTap;
@property (nonatomic) NSInteger tapShouldOccurIn;

@property (nonatomic, strong) NSDateFormatter * dateAndTimeFormatter;
@property (nonatomic, strong) NSDateFormatter * historyCellDayFormatter;
@property (nonatomic, strong) NSDateFormatter * historyMonthYearFormatter;
@property (nonatomic, strong) NSDateFormatter * occurencesKeyDateFormatter;

@property (nonatomic, strong) NSMutableArray * occurencesByDay;

@property (nonatomic, strong) NSTimer * countdownTimer;

@property (nonatomic, strong) IBOutlet UIButton * backButton;
@property (nonatomic, strong) IBOutlet UIButton * cancelDeleteButton;
@property (nonatomic, strong) IBOutlet UIButton * confirmDeleteButton;
@property (nonatomic, strong) IBOutlet UIButton * deleteButton;
@property (nonatomic, strong) IBOutlet UIButton * editButton;
@property (nonatomic, strong) IBOutlet UIButton * viewAllTapsButton;

@property (nonatomic, strong) IBOutlet UICollectionView * historyCollectionView;

@property (nonatomic, strong) IBOutlet UILabel * averagePerDayLabel;
@property (nonatomic, strong) IBOutlet UILabel * averagePerMonthLabel;
@property (nonatomic, strong) IBOutlet UILabel * averagePerWeekLabel;
@property (nonatomic, strong) IBOutlet UILabel * countdownLabel;
@property (nonatomic, strong) IBOutlet UILabel * historyGeneralTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel * historyMaxValueLabel;
@property (nonatomic, strong) IBOutlet UILabel * historyMidValueLabel;
@property (nonatomic, strong) IBOutlet UILabel * iconLabel;
@property (nonatomic, strong) IBOutlet UILabel * iconLabelForDelete;
@property (nonatomic, strong) IBOutlet UILabel * lastThreeTapsOfTotalTapsLabel;
@property (nonatomic, strong) IBOutlet UILabel * nameLabel;
@property (nonatomic, strong) IBOutlet UILabel * recentMostLabel;
@property (nonatomic, strong) IBOutlet UILabel * recentSecondMostLabel;
@property (nonatomic, strong) IBOutlet UILabel * recentThirdMostLabel;

@property (nonatomic, strong) IBOutlet UIScrollView * mainScrollView;

@property (nonatomic, strong) IBOutlet UIView * confirmDeleteContainer;

@end


@implementation StatDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the icon and the name
    
    self.nameLabel.text = self.primaryMapkep.name;
    
    UIFont * faFont = FA_ICONS_FONT_HALF_SIZE;
    
    self.iconLabel.font = faFont;
    if (self.primaryMapkep.faUInt == 0) self.primaryMapkep.faUInt = [Mapkep defaultFAUInt];
    self.iconLabel.text = [NSString awesomeIcon:self.primaryMapkep.faUInt];
    
    
    // Set the data
    [self setData];
    
    
    // Set the delete confirmation version of the icon
    
    UIFont * faFontLarge = FA_ICONS_FONT;
    
    self.iconLabelForDelete.font = faFontLarge;
    self.iconLabelForDelete.text = [NSString awesomeIcon:self.primaryMapkep.faUInt];
    
    // Real artists ship
    
    self.backButton.titleLabel.font = faFont;
    
    [self.backButton setTitle:[NSString awesomeIcon:FaTimesCircle]
                     forState:UIControlStateNormal];
    
    // The "cancel" button (visible in confirm delete overlay)
    
    self.cancelDeleteButton.titleLabel.font = faFont;
    
    [self.cancelDeleteButton setTitle:[NSString awesomeIcon:FaTimesCircle]
                             forState:UIControlStateNormal];
    
    // Border patrol
    
    CALayer * editLayer = [self.editButton layer];
    editLayer.borderWidth = 1.0f;
    editLayer.borderColor = [COLOR_1 toUIColor].CGColor;
    
    CALayer * viewAllLayer = [self.viewAllTapsButton layer];
    viewAllLayer.borderWidth = 1.0f;
    viewAllLayer.borderColor = [COLOR_1 toUIColor].CGColor;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.occurencesByDay.count > 1)
    {
        [self.historyCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.occurencesByDay.count - 1
                                                                               inSection:0]
                                           atScrollPosition:UICollectionViewScrollPositionLeft
                                                   animated:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUI)
                                                 name:NOTIFICATION_MAPKEP_CONTEXT_UPDATED
                                               object:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startCountdown];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self stopCountdown];
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
#pragma mark A Shiny Classic Car

- (void)refreshUI
{
    [self.view setNeedsDisplay];
}


- (void)setData
{
    // Set the three most recent occurences and their header
    
    self.lastThreeTapsOfTotalTapsLabel.text = [NSString stringWithFormat:@"last few taps of your %d total taps", self.primaryMapkep.totalOccurences];
    
    self.recentMostLabel.text = [self.dateAndTimeFormatter stringFromDate:[[self.primaryMapkep recentOccurenceWithOffset:0] createdAt]];
    
    self.recentSecondMostLabel.text = [self.dateAndTimeFormatter stringFromDate:[[self.primaryMapkep recentOccurenceWithOffset:1] createdAt]];
    
    self.recentThirdMostLabel.text = [self.dateAndTimeFormatter stringFromDate:[[self.primaryMapkep recentOccurenceWithOffset:2] createdAt]];
    
    // Set the averages labels
    
    [self setAveragesLabels];
}


//  "Create it when you need it!"  ~ Lazy Initialization
//
//  This is a pattern where the creation (and in this case
//  a configuration) isn't done until it is needed.  After
//  the first call '_historyCellDayFormatter', the wonderful
//  instance variable of our property dateFormatter, will be
//  created, then every subsequent call will simply return
//  what was made in that first call.
//
//  This is true for the folowwing methods, three formatters
//  and a data set.

- (NSDateFormatter *)dateAndTimeFormatter
{
    if (_dateAndTimeFormatter == nil)
    {
        _dateAndTimeFormatter = [[NSDateFormatter alloc] init];
        [_dateAndTimeFormatter setDateFormat:@"MMM d, yyyy - h:mm a"];
    }
    
    return _dateAndTimeFormatter;
}


- (NSDateFormatter *)historyCellDayFormatter
{
    if (_historyCellDayFormatter == nil)
    {
        _historyCellDayFormatter = [[NSDateFormatter alloc] init];
        [_historyCellDayFormatter setDateFormat:@"d"];
    }
    
    return _historyCellDayFormatter;
}


- (NSDateFormatter *)historyMonthYearFormatter
{
    if (_historyMonthYearFormatter == nil)
    {
        _historyMonthYearFormatter = [[NSDateFormatter alloc] init];
        [_historyMonthYearFormatter setDateFormat:@"MMMM | y"];
    }
    
    return _historyMonthYearFormatter;
}


- (NSDateFormatter *)occurencesKeyDateFormatter
{
    if (_occurencesKeyDateFormatter == nil)
    {
        _occurencesKeyDateFormatter = [[NSDateFormatter alloc] init];
        [_occurencesKeyDateFormatter setDateFormat:@"yyyy_MMM_d"];
    }
    
    return _occurencesKeyDateFormatter;
}


- (NSMutableArray *)occurencesByDay
{
    if (_occurencesByDay == nil)
    {
        self.highestOccurenceCountForADay = 2; // defualt to 2 so UI is never too short
        self.occurencesByDay = [@[] mutableCopy];
        
        if (self.primaryMapkep.firstOccurence.createdAt != nil)
        {
            // set up the dates/calendar/components we'll use in our loop
            
            NSDate * today = [[NSDate alloc] init];
            
            NSCalendar * calendar = [NSCalendar currentCalendar];
            
            NSDateComponents * components = [calendar components:( NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear )
                                                        fromDate:self.primaryMapkep.firstOccurence.createdAt];
            [components setMinute:0];
            [components setHour:0];
            
            NSDateComponents * offsetComponents = [[NSDateComponents alloc] init];
            [offsetComponents setDay:1];
            
            // create the first occurence date
            
            NSDate * occurenceDate = [calendar dateFromComponents:components];
            
            // loop through each day between then and today
            
            while ([occurenceDate compare:today] < 0)
            {
                NSString * key = [self.occurencesKeyDateFormatter stringFromDate:occurenceDate];
                NSArray * occurences = [self.primaryMapkep occurancesForDate:occurenceDate];
                
                [self.occurencesByDay addObject:@{ key : occurences }];
                
                if (occurences.count > self.highestOccurenceCountForADay)
                {
                    self.highestOccurenceCountForADay = (int)occurences.count;
                }
                
                // incrementing the date (technically creating a new date and
                // setting it, but you know what I mean)
                
                occurenceDate = [calendar dateByAddingComponents:offsetComponents
                                                           toDate:occurenceDate
                                                          options:0];
            }
        }
        
        // Set the two labels whose values are now known (and will remain unchanged)
        
        self.historyMaxValueLabel.text = [NSString stringWithFormat:@"%d", self.highestOccurenceCountForADay];
        
        self.historyMidValueLabel.text = [NSString stringWithFormat:@"%.01f", (float)self.highestOccurenceCountForADay / 2.0f];
    }
    
    return _occurencesByDay;
}


#pragma mark -
#pragma mark Then a Right at the Barn

- (void)setAveragesLabels
{
    float dailyAverage = (float)self.primaryMapkep.totalOccurences / (float)self.occurencesByDay.count;
    
    if (isnan(dailyAverage)) dailyAverage = 0;
    
    self.averagePerDayLabel.text = [NSString stringWithFormat:@"%.02f a day", dailyAverage];
    
    self.averagePerWeekLabel.text = [NSString stringWithFormat:@"%.02f a week", dailyAverage * 7.0f];
    
    self.averagePerMonthLabel.text = [NSString stringWithFormat:@"%.02f a month", dailyAverage * 30.0f];
}


#pragma mark -
#pragma mark And A Big Red Button

- (NSInteger)averageSecondsBetween
{
    if (_averageSecondsBetween == 0)
    {
        _averageSecondsBetween = (24 * 60 * 60) / ((float)self.primaryMapkep.totalOccurences / (float)self.occurencesByDay.count);
    }
    
    return _averageSecondsBetween;
}


- (NSInteger)secondsSinceTap
{
    if (_secondsSinceTap == 0)
    {
        _secondsSinceTap = [[[NSDate alloc] init] timeIntervalSinceDate:self.primaryMapkep.lastOccurence.createdAt];
    }
    
    return _secondsSinceTap;
}


- (void)setCountdownText;
{
    self.tapShouldOccurIn--;
    
    if (self.tapShouldOccurIn < 0)
    {
        if (self.secondsSinceTap > 0)
        {
            self.countdownLabel.text = [NSString stringWithFormat:@"wow, it's been %.02f days since your last tap", ((self.secondsSinceTap / 60.0f) / 60.0f) / 24.0f];
        }
        else
        {
            self.countdownLabel.text = @"perhaps... soon?";
        }
    }
    else
    {
        int days = (int)self.tapShouldOccurIn / 86400; // 86400 = 60 * 60 * 24
        int hours = (self.tapShouldOccurIn % 86400) / 3600; // 3600 = 60 * 60
        int minutes = ((self.tapShouldOccurIn % 86400) % 3600) / 60;
        int seconds = ((self.tapShouldOccurIn % 86400) % 3600) % 60;
        
        NSString * daysString =  days > 0 ? [NSString stringWithFormat:@"%d days, ", days] : @"";
        NSString * hoursString =  hours > 0 ? [NSString stringWithFormat:@"%d hours, ", hours] : @"";
        NSString * minutesString =  minutes > 0 ? [NSString stringWithFormat:@"%d minutes, ", minutes] : @"";
        NSString * secondsString = [NSString stringWithFormat:@"%d seconds", seconds];
        
        self.countdownLabel.text = [NSString stringWithFormat:@"%@%@%@%@", daysString, hoursString, minutesString, secondsString];
    }
}


- (void)startCountdown;
{
    self.tapShouldOccurIn = self.averageSecondsBetween - self.secondsSinceTap;
    
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                           target:self
                                                         selector:@selector(setCountdownText)
                                                         userInfo:nil
                                                          repeats:YES];
}


- (void)stopCountdown;
{
    [self.countdownTimer invalidate];
    self.averageSecondsBetween = 0;
    self.secondsSinceTap = 0;
}


#pragma mark -
#pragma mark You Can't Touch This

//  See AddMapkepViewControllers's "back" if you're
//  wondering why I'm doing this instead of using a segue.
//
- (IBAction)back:(id)sender
{
    // 88mph
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}


//  no... I've changed my mind
//
- (IBAction)cancelDelete:(id)sender
{
    [UIView animateWithDuration:1.0
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.confirmDeleteContainer.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         self.confirmDeleteContainer.hidden = true;
                     }];
}


//  exterminate?
//
- (IBAction)confirmDelete:(id)sender
{
    self.confirmDeleteContainer.hidden = false;
    
    [UIView animateWithDuration:1.0
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.confirmDeleteContainer.alpha = 1.0f;
                     }
                     completion:nil];
}


//  EXTERMINATE
//
- (IBAction)delete:(id)sender
{
    NSError * error;
    if (![self.primaryMapkep deleteSelf:error])
    {
        AlwaysLog(@"I'm a mog, half man, half dog.  I'm my own best friend!");
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.occurencesByDay.count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // "HistoryCell" is the name set on the prototype cell in the storyboard.
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryCell"
                                                                            forIndexPath:indexPath];
    
    // Grab the occurences for this index
    
    NSDictionary * occurencesHash = self.occurencesByDay[indexPath.row];
    
    NSString * key = occurencesHash.allKeys.firstObject;
    NSArray * occurences = occurencesHash[key];
    
    // Calculate some stuff
    
    float ratio = (float)occurences.count / (float)self.highestOccurenceCountForADay;
    CGFloat yPosition = HISTORY_CELL_BAR_HEIGHT - HISTORY_CELL_BAR_HEIGHT * ratio;
    
    // Grab our fill view (or make it if needed)
    
    UIView * bar = [cell.contentView viewWithTag:HISTORY_CELL_BAR_TAG];
    UIView * fill = [bar viewWithTag:HISTORY_CELL_FILL_TAG];
    
    if (fill == nil)
    {
        fill = [[UIView alloc] init];
        fill.alpha = 0.85;
        fill.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        fill.backgroundColor = [COLOR_1 toUIColor];
        fill.opaque = false;
        fill.tag = HISTORY_CELL_FILL_TAG;
        
        CALayer * fill_layer = [fill layer];
        fill_layer.borderWidth = 1.0f;
        fill_layer.borderColor = [UIColor whiteColor].CGColor;
        
        [bar addSubview:fill];
    }
    
    // Size the fill view
    
    fill.frame = CGRectMake(0.0f, yPosition + 1.0f, 50.0f, HISTORY_CELL_BAR_HEIGHT * ratio);
    
    // Update the text denoting the day of this bar
    
    UILabel * day = (UILabel *)[cell.contentView viewWithTag:HISTORY_CELL_DAY_TAG];
    day.text = [self.historyCellDayFormatter stringFromDate:[self.occurencesKeyDateFormatter dateFromString:key]];
    
    // Update the text denoting the approxiamate Month and Year of
    // the visible bars
    
    self.historyGeneralTimeLabel.text = [self.historyMonthYearFormatter stringFromDate:[self.occurencesKeyDateFormatter dateFromString:key]];
    
    // Always groups of five...
    
    return cell;
}


#pragma mark - 
#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    //  So we just set up the identifier in the storyboard
    //
    //  ahhh.... I just copy-pasted this from somewhere else
    //  read this note while highlighting it to replace it,
    //  and realized 'hah, I need to do that'.
    
    if ([segue.identifier isEqualToString:SEGUE_TO_HISTORY_TABLE])
    {
        // I aim to misbehave
        
        MapkepOccurencesViewController * controller = (MapkepOccurencesViewController *)segue.destinationViewController;
        controller.occurences = [[self.primaryMapkep.has_many_occurances array] mutableCopy];
        controller.primaryMapkep = self.primaryMapkep;
    }
    else if ([segue.identifier isEqualToString:SEGUE_TO_EDIT_PAGE])
    {
        // The next time you decide to stab me in the back,
        // have the guts to do it to my face.
        //
        // ~ Cap'n Mal
        
        EditMapkepViewController * controller = (EditMapkepViewController *)segue.destinationViewController;
        controller.mapkep = self.primaryMapkep;
    }
}


@end
