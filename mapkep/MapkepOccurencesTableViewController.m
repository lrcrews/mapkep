//
//  MapkepOccurencesTableViewController.m
//  mapkep
//
//  Created by L Ryan Crews on 5/4/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import "MapkepOccurencesTableViewController.h"

#import "Constants.h"
#import "Occurance.h"


//  Tag values for elements in the storyboard
//
static int tag_occurence_time = 1337;


@interface MapkepOccurencesTableViewController ()
@end


@implementation MapkepOccurencesTableViewController


#pragma mark -
#pragma mark You Can't Touch This

//  See AddMapkepViewControllers's "cancel" if you're
//  wondering why I'm doing this instead of using a segue.
//
- (void)backToStatDetail
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
    
    Occurance * occurence = self.occurences[ indexPath.row ];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d, yyyy - h:mm a"];
    
    UILabel * occurence_time_label = (UILabel *)[cell viewWithTag:tag_occurence_time];
    occurence_time_label.text = [dateFormatter stringFromDate:occurence.createdAt];
    
    return cell;
}


-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self backToStatDetail];
}


@end
