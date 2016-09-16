//
//  TeaEditor.h
//  TeaMenu
//
//  Created by Jan on 28.03.15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#ifndef RELOAD_TEAS
#define RELOAD_TEAS @"ReloadTeas"
#endif

@class TeaDatabase;

@interface TeaEditor : NSWindowController <NSTableViewDelegate, NSTableViewDataSource> {
}

// Main window
@property IBOutlet NSTableView *table;

// Sheet view
@property IBOutlet NSWindow *sheetContents;
@property IBOutlet NSTextField *teaName;
@property IBOutlet NSTextField *teaTime;

- (IBAction) addTea:(id)sender;
- (IBAction) removeTea:(id)sender;

- (void) clearSheet;
- (IBAction) cancelSheet:(id)sender;
- (IBAction) submitSheet:(id)sender;

- (void) windowWillClose: (NSNotification *)_;
- (void) cleanup;

@end
