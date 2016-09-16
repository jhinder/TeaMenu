//
//  TeaEditor.m
//  TeaMenu
//
//  Created by Jan on 28.03.15.
//  Copyright (c) 2015 dfragment.net. All rights reserved.
//

#import "TeaEditor.h"
#import "TeaObject.h"

@implementation TeaEditor

@synthesize sheetContents;
@synthesize teaName, teaTime;
@synthesize teaArrayController;

- (void) clearSheet
{
    teaName.stringValue = @"";
    teaTime.stringValue = @"";
}

- (instancetype) initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        [self clearSheet];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowWillClose:)
                                                     name:NSWindowWillCloseNotification
                                                   object:self.window];
    }
    
    return self;
}

// Invoked when hitting the ESC key
- (void) cancelOperation:(id)sender
{
    [self close]; // This will send the "closing" notification we registered for
}

- (void) windowWillClose:(NSNotification *)_
{
    // Save the data. This will also send a CoreData
    // didSave notification, triggering menu reloading.
    NSError *err = nil;
    if (![self.managedObjectContext save:&err]) {
        NSLog(@"Could not save!\n%@", err);
    }
}

- (IBAction) addTea:(id)sender
{
    [sheetContents makeFirstResponder:teaName];
    [self.window beginSheet:sheetContents completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSModalResponseOK) {
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tea"
                                                      inManagedObjectContext:self.managedObjectContext];
            TeaObject *t = [[TeaObject alloc] initWithEntity:entity
                              insertIntoManagedObjectContext:self.managedObjectContext];
            t.name = teaName.stringValue;
            t.time = @(teaTime.integerValue);
            [teaArrayController addObject:t];
        }
        [self clearSheet];
    }];
}

#pragma mark - Sheet actions

- (IBAction) cancelSheet:(id)sender
{
    [sheetContents.sheetParent endSheet:sheetContents returnCode:NSModalResponseCancel];
}

- (IBAction) submitSheet:(id)sender
{
    [sheetContents.sheetParent endSheet:sheetContents returnCode:NSModalResponseOK];
}

@end
