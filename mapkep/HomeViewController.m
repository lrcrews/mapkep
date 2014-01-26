//
//  HomeViewController.m
//  mapkep
//
//  Created by L Ryan Crews on 1/18/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import "HomeViewController.h"

#import "UIColorPickerView.h"

#import "NSString+utils.h"

#import "Constants.h"


@interface HomeViewController ()

@property (nonatomic, strong) UIColorPickerView * uicolorPickerView;

@end


@implementation HomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [BACKGROUND_MAIN toUIColor];
    
    [self setUicolorPickerView:[[UIColorPickerView alloc] initDefaultUIColorPickerAtYPoint:100.0f]];
    [self.view addSubview:self.uicolorPickerView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
