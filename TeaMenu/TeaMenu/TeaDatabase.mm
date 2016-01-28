//
//  TeaDatabase.mm
//  TeaMenu
//
//  Created by Jan on 27.03.15.
//  Copyright (c) 2015 dfragment.net. All rights reserved.
//

#import "TeaDatabase.h"

@implementation TeaDatabase

/** Local helper functions **/
BOOL createAppSupport(void);
NSString * getAppSupportFolder(void);

/* Creates a TeaMenu folder in the user's Application Support folder */
BOOL createAppSupport(void)
{
	NSString *directory = [NSString stringWithFormat:@"%@/TeaMenu/", getAppSupportFolder()];
	if (directory == NULL)
		return FALSE;
	BOOL isDir;
	NSFileManager *fileManager= [NSFileManager defaultManager];
	if ((![fileManager fileExistsAtPath:directory isDirectory:&isDir])) {
		return [fileManager createDirectoryAtPath:directory
			   withIntermediateDirectories:YES
								attributes:nil
									 error:NULL];
	} else {
		return isDir;
	}
	return FALSE;
}

/* Gets the Library/Application Support folder for the user */
NSString * getAppSupportFolder(void)
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	return (([paths count] != 0) ? [paths objectAtIndex:0] : NULL);
}

/** Class implementation **/

- (id) init
{
	self = [super init];
    if (self) {
		const char *dbPath = [[NSString stringWithFormat:@"%@/TeaMenu/Teas.db", getAppSupportFolder()] UTF8String];
		if (createAppSupport() && initDB(dbPath) && prepareDB()) {
			// nothing.
		} else {
			NSLog(@"Could not initialize the database.");
			[self release];
			self = nil; // Nothing we can do now...
		}
    }
    return self;
}

/* Returns the number of teas in the database */
- (NSInteger) countTeas
{
	return countTeas();
}

/* Inserts a tea with name and brewing time into the database */
- (bool) insertTeaWithName: (NSString *)name andTime: (int)minutes
{
	return writeTea(minutes, name.UTF8String);
}

/* Deletes a tea with the given name */
- (bool) deleteTeaWithName: (NSString *)name
{
	return removeTea(name.UTF8String);
}

/* Gets all teas and returns them as an NSArray of TeaObject entities */
- (NSArray *) queryTeas
{
	std::vector<TeaNode> teaVector;
	if (!readAllTeas(teaVector)) {
		delete &teaVector;
		return nil;
	}

	NSMutableArray *teaArray = [[[NSMutableArray alloc] init] autorelease];
    for (auto tea : teaVector) {
        TeaObject *nextTea = [[[TeaObject alloc] initWithName:[NSString stringWithUTF8String:tea.getName().c_str()]
                                                  andDuration:tea.getMinutes()] autorelease];
        [teaArray addObject:nextTea];
    }

	teaVector.clear();
	return teaArray;
}

/* Destructor; closes the database connection */
- (void) dealloc
{
	[super dealloc];
	closeDB();
}

@end

@implementation TeaObject

@synthesize teaName;
@synthesize teaDuration;

- (id) initWithName:(NSString *)name andDuration:(NSInteger)duration
{
	self = [super init];
	if (self) {
		teaName = name;
		teaDuration = duration;
	}
	return self;
}

@end
