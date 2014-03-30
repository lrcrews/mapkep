//
//  MapkepButton.m
//  mapkep
//
//  Created by L Ryan Crews on 2/22/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//

#import "MapkepButton.h"


@implementation MapkepButton


- (id)initWithFrame:(CGRect)frame
              color:(UIColor *)color;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = color;
        
        self.layer.cornerRadius = BUTTON_CORNER_RADIUS;
        self.layer.borderColor = UIColor.darkGrayColor.CGColor;
        self.layer.borderWidth = 1.0f;
    }
    return self;
}


@end
