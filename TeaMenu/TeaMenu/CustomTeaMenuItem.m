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

- (instancetype) initWithFrame:(CGRect)frame
{
    // no custom constructor needed
    return (self = [super initWithFrame:frame]);
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

- (void) scrollWheel:(NSEvent *) theEvent
{
    int inversionFactor = (theEvent.isDirectionInvertedFromDevice ? -1 : 1);
    double dx = theEvent.deltaX * inversionFactor;
    double dy = theEvent.deltaY * inversionFactor;
    
    double avgDelta = sqrt((dx * dx) + (dy * dy));
    
	if (avgDelta < 0.25)
		return; // too small
	
	bool isNegative = !(dx < 0 // inversion of (negative to the left OR
                        || (dy < 0 // downwards and...
                            && dx < 0.1)); // only small x-movement)
	
    int stepDelta = (int)avgDelta;
	if (isNegative)
		stepDelta = -stepDelta;
    
	[model setMinutes:(model.minutes + stepDelta)]; // using the setter also updates the bindings
}

@end

// TeaTime data model
@implementation CustomTeaTimeModel
@synthesize minutes = _minutes;
@synthesize teaNotBrewing;

static const int MAX_MINUTES = 10;

- (void) setMinutes:(NSInteger)minutes
{
    // Custom setter: restrict values to (0, 10]
    if (minutes > 0 && minutes <= MAX_MINUTES)
        _minutes = minutes;
}

@end
