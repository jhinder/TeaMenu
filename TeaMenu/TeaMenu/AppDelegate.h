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

@property (weak) IBOutlet NSMenu *appMenu;
@property  NSStatusItem *item;
@property (weak) IBOutlet NSMenuItem *stopTeaItem;
@property (strong) TeaDatabase *database;
@property (strong) NSImage *mug, *mugSteaming;
@property (strong) TeaEditor *editor;
@property (strong) CustomTeaItemViewController *customTeaItem;
@property (strong) TeaManager *teaManager;

- (IBAction)startTimer:(id)sender;
- (IBAction)stopTimer:(id)sender;
- (IBAction)terminate:(id)sender;
- (IBAction)openTeaEditor:(id)sender;

- (void) changeIcons:(bool)steaming;
- (void) copyDefaultTeas;
- (void) showTeaNotification:(bool)showInCenter;

@end
