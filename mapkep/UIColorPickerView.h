//
//  UIColorPickerView.h
//  mapkep
//
//  3
//
//  Created by L Ryan Crews on 1/19/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface UIColorPickerView : UIView


//  The only method I intend to use for the initial realase.
//  It creates the UIColorPickerView used during 'mapkep' creation.
//
- (id)initDefaultUIColorPickerAtYPoint:(CGFloat)y;


//  This is the method that will actually do the work though.
//  In version 1.something I'll probably have the selector view
//  give the option to not show colors already used, so why not
//  lay the ground work for that now?
//
- (id)initWithFrame:(CGRect)frame
       withUIColors:(NSArray *)uicolors;


@end
