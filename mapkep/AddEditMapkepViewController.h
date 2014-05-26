//
//  AddEditMapkepViewController.h
//  mapkep
//
//  Created by L Ryan Crews on 2/15/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Mapkep;

@interface AddEditMapkepViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton * addButton;
@property (nonatomic, strong) IBOutlet UITextField * nameTextField;

// If we're editing one it'll be passed in as...
@property (nonatomic, strong) Mapkep * mapkep;

@end
