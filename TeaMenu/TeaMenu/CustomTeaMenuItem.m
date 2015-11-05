//
//  CustomTeaMenuItem.m
//  TeaMenu
//
//  Created by Jan on 03.11.15.
//  Copyright (c) 2015 dfragment.net. All rights reserved.
//

#import "CustomTeaMenuItem.h"
#import "AppDelegate.h"

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

// TeaTime data model
@implementation CustomTeaTimeModel
@synthesize minutes, teaNotBrewing;
@end
