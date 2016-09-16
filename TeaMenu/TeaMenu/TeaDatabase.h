//
//  TeaDatabase.h
//  TeaMenu
//
//  Created by Jan on 27.03.15.
//  Copyright (c) 2015 dfragment.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TeaObject; // forward declaration for TeaDatabase

// -- Declaration of TeaDatabase

@interface TeaDatabase : NSObject {
}

- (instancetype) init;

- (NSInteger) countTeas;
- (bool) insertTeaWithName: (NSString *)name andTime: (int)minutes;
- (bool) insertTeaWithObject: (TeaObject *) obj;
- (bool) deleteTeaWithName: (NSString *)name;
- (NSArray *) queryTeas;

@end
