//
//  AppDelegate.h
//  TeaMenu
//
//  Created by Jan on 13.11.14.
//  Copyright (c) 2014 dfragment.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
	NSMenu *_appMenu;
	NSStatusItem *_item;
	NSMutableArray *userTeas;
}

@property (assign) IBOutlet NSMenu *appMenu;
@property (assign) NSStatusItem *item;
@property (retain) NSMutableArray *userTeaArray;

- (IBAction)showCustomTimer:(id)sender;
- (IBAction)startTimer:(id)sender;
- (IBAction)terminate:(id)sender;

- (void) actualTimerStart: (NSInteger) seconds;
- (void) changeIcons:(bool)steaming;
- (void) preparePreferences;
- (void) timerUp;

@end
