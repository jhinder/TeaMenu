//
//  CustomTeaMenuItem.m
//  TeaMenu
//
//  Created by Jan on 03.11.15.
//  Copyright (c) 2015 dfragment.net. All rights reserved.
//

#import "CustomTeaMenuItem.h"

@implementation CustomTeaMenuItem

@synthesize model;

- (id)initWithFrame:(CGRect)frame
{
    // no custom constructor needed
    return [super initWithFrame:frame];
}

// Overrides to allow for touch & scroll events
- (BOOL) acceptsFirstResponder
{
	return YES;
}

- (BOOL) acceptsTouchEvents
{
	return YES;
}

@end

// Implementation for CustomTeaTimeModel -- literally three lines long.
@implementation CustomTeaTimeModel
@synthesize minutes;
@end
