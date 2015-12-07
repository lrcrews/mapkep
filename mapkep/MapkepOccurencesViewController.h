//
//  MapkepOccurencesViewController.h
//  mapkep
//
//  Created by L Ryan Crews on 5/4/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Mapkep;

@interface MapkepOccurencesViewController : UIViewController

@property (nonatomic, strong) NSMutableArray * occurences;
@property (nonatomic, strong) Mapkep * primaryMapkep;

@end
