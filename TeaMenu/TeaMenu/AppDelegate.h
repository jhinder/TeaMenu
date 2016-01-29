//
//  AppDelegate.h
//  TeaMenu
//
//  Created by Jan on 13.11.14.
//  Copyright (c) 2014 dfragment.net. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>
#import "TeaTimerNotification.h"

@class TeaManager, CustomTeaItemViewController, TeaDatabase;
@class TeaEditor;

@interface AppDelegate : NSObject <NSApplicationDelegate, TeaTimerNotification>

@property (assign) IBOutlet NSMenu *appMenu;
@property (assign) NSStatusItem *item;
@property (assign) IBOutlet NSMenuItem *stopTeaItem;
@property (retain) TeaDatabase *database;
@property (retain) NSImage *mug, *mugSteaming;
@property (retain) TeaEditor *editor;
@property (retain) CustomTeaItemViewController *customTeaItem;
@property (retain) TeaManager *teaManager;

- (IBAction)startTimer:(id)sender;
- (IBAction)stopTimer:(id)sender;
- (IBAction)terminate:(id)sender;
- (IBAction)openTeaEditor:(id)sender;

- (void) changeIcons:(bool)steaming;
- (void) copyDefaultTeas;
- (void) showTeaNotification:(bool)showInCenter;

@end
