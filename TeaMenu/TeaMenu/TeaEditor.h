//
//  TeaEditor.h
//  TeaMenu
//
//  Created by Jan on 28.03.15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TeaEditor : NSWindowController {
	NSArrayController *arrayController;
}

@property (strong) IBOutlet NSArrayController *arrayController;

@end
