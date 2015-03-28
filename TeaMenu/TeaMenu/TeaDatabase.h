//
//  TeaDatabase.h
//  TeaMenu
//
//  Created by Jan on 27.03.15.
//  Copyright (c) 2015 dfragment.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "sqlite.hpp"

// -- Declaration of TeaDatabase

@interface TeaDatabase : NSObject {
}

- (id) init;

- (NSInteger) countTeas;
- (bool) insertTeaWithName: (NSString *)name andTime: (int)minutes;
- (bool) deleteTeaWithName: (NSString *)name;
- (bool) resetDatabase;
- (NSArray *) queryTeas;

@end

// -- Declaration of TeaObject

@interface TeaObject : NSObject {
@private
    NSInteger teaDuration;
	NSString *teaName;
}

@property (assign) NSInteger teaDuration;
@property (retain) NSString *teaName;

- (id) initWithName:(NSString *)name andDuration:(NSInteger)duration;

@end