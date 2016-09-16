//
//  TeaDatabase.mm
//  TeaMenu
//
//  Created by Jan on 27.03.15.
//  Copyright (c) 2015 dfragment.net. All rights reserved.
//

#import "TeaDatabase.h"

@implementation TeaDatabase

/** Class implementation **/

- (instancetype) init
{
	self = [super init];
    if (self) {
    }
    return self;
}

/* Returns the number of teas in the database */
- (NSInteger) countTeas
{
    return 0;
}

/* Inserts a tea with name and brewing time into the database */
- (bool) insertTeaWithName: (NSString *)name andTime: (int)minutes
{
    return false;
}

- (bool) insertTeaWithObject: (TeaObject *)obj
{
    return false;
}

/* Deletes a tea with the given name */
- (bool) deleteTeaWithName: (NSString *)name
{
    return false;
}

/* Gets all teas and returns them as an NSArray of TeaObject entities */
- (NSArray *) queryTeas
{
    return nil;
}

/* Destructor; closes the database connection */
- (void) dealloc
{
    ;
}

@end
