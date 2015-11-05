//
//  AppDelegate+Extensions.h
//  TeaMenu
//
//  Created by Jan on 03.11.15.
//  Copyright (c) 2015 dfragment.net. All rights reserved.
//

/* All ivars and properties are found here because some of the used headers
 * are C++ headers. If you use a C++ header in an ObjC file, it must become
 * ObjC++. And because I don't want to turn *everything* into ObjC++ just because
 * the database layer is written in C++, I put all ivars (including those that
 * reference a C++ class) in a category; that way I can use the regular header
 * for inclusion in ObjC files (see: CustomTeaItemViewController).
 */

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "TeaDatabase.h"
#import "TeaEditor.h"
#import "CustomTeaItemViewController.h"
#import "TeaManager.h"

@interface AppDelegate () {
    
}

@property (assign) IBOutlet NSMenu *appMenu;
@property (assign) NSStatusItem *item;
@property (assign) IBOutlet NSMenuItem *stopTeaItem;
@property (retain) TeaDatabase *database;
@property (retain) NSImage *mug, *mugSteaming;
@property (retain) TeaEditor *editor;
@property (retain) CustomTeaItemViewController *customTeaItem;
@property (retain) TeaManager *teaManager;

@end
