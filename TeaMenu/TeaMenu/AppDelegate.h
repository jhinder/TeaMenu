//
//  AppDelegate.h
//  TeaMenu
//
//  Created by Jan on 13.11.14.
//  Copyright (c) 2014 dfragment.net. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
	NSMenu *_appMenu;
	NSStatusItem *_item;
	NSMutableArray *userTeas;
	NSMenuItem *stopTimerItem;
}

@property (assign) IBOutlet NSMenu *appMenu;
@property (assign) NSStatusItem *item;
@property (retain) NSMutableArray *userTeaArray;
@property (assign) IBOutlet NSMenuItem *stopTeaItem;

- (IBAction)showCustomTimer:(id)sender;
- (IBAction)startTimer:(id)sender;
- (IBAction)stopTimer:(id)sender;
- (IBAction)terminate:(id)sender;

- (void) actualTimerStart: (NSInteger) seconds;
- (void) haltTimer;
- (void) changeIcons:(bool)steaming;
- (void) preparePreferences;
- (void) timerUp;

@end
