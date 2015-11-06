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

- (void) scrollWheel:(NSEvent *) theEvent
{
	double avgDelta = sqrt( pow(theEvent.deltaX, 2.0f)
                          + pow(theEvent.deltaY, 2.0f)
                          + pow(theEvent.deltaZ, 2.0f));
    
	if (abs(avgDelta) < 0.25f)
		return; // too small
	
	bool isNegative = !(theEvent.deltaX < 0 // inversion of (negative to the left OR 
                        || (theEvent.deltaY < 0 // downwards and...
                            && theEvent.deltaX < 0.1f)); // only small x-movement)
	
	int stepDelta = (int)floor(avgDelta * 0.49);
	if (isNegative)
		stepDelta *= (-1);
	
	[model setMinutes:(model.minutes + stepDelta)]; // using the setter also updates the bindings
}

@end

// TeaTime data model
@implementation CustomTeaTimeModel
@synthesize minutes = _minutes;
@synthesize teaNotBrewing;

const int MAX_MINUTES = 10;

- (void) setMinutes:(NSInteger)minutes {
    // Custom setter: restrict values to (0, 10]
    if (minutes > 0 && minutes <= MAX_MINUTES)
        _minutes = minutes;
}

@end
