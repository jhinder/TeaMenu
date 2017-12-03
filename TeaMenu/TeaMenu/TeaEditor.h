//
//  TeaEditor.h
//  TeaMenu
//
//  Created by Jan on 28.03.15.
//  Copyright (c) 2015 dfragment.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TeaDatabase;

@interface TeaEditor : NSWindowController

// Main window
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong) IBOutlet NSArrayController *teaArrayController;

// Sheet view
@property IBOutlet NSWindow *sheetContents;
@property IBOutlet NSTextField *teaName;
@property IBOutlet NSTextField *teaTime;

- (IBAction) addTea:(id)sender;

- (void) clearSheet;
- (IBAction) cancelSheet:(id)sender;
- (IBAction) submitSheet:(id)sender;

- (void) windowWillClose: (NSNotification *)_;

@end
