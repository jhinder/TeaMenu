//
//  TeaEditor.m
//  TeaMenu
//
//  Created by Jan on 28.03.15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "TeaEditor.h"
#import "TeaDatabase.h"

@implementation TeaEditor

@synthesize db;
@synthesize table;
@synthesize teaCache;

@synthesize sheetContents;
@synthesize teaName, teaTime;

bool dirty = false;

- (void) clearSheet
{
    teaName.stringValue = @"";
    teaTime.stringValue = @"";
}

- (instancetype) initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        db = [[TeaDatabase alloc] init];
        teaCache = [NSMutableArray arrayWithArray:[db queryTeas]];
        [self clearSheet];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowWillClose:)
                                                     name:NSWindowWillCloseNotification
                                                   object:self.window];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void) cleanup
{
    if (dirty) // Send notification to reload the bar menu
        [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_TEAS object:nil];
}

// Invoked when hitting the ESC key
- (void) cancelOperation:(id)sender
{
    [self close]; // This will send the "closing" notification we registered for
}

- (void) windowWillClose:(NSNotification *)_
{
    [self cleanup];
}

- (IBAction) addTea:(id)sender
{
    [sheetContents makeFirstResponder:teaName];
    [self.window beginSheet:sheetContents completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSModalResponseOK) {
            TeaObject *obj = [[TeaObject alloc] initWithName:self->teaName.stringValue
                                                 andDuration:self->teaTime.intValue];
            [teaCache addObject:obj];
            [db insertTeaWithObject:obj];
            dirty = true;
            [self->table reloadData];
        }
        [self clearSheet];
    }];
}

- (IBAction) removeTea:(id)sender
{
    if (table.selectedRow == -1) // no tea selected
        return;
    
    NSInteger toDelete = table.selectedRow;
    
    NSString *deleteKey = ((TeaObject *)teaCache[toDelete]).teaName;
    [db deleteTeaWithName:deleteKey];
    [teaCache removeObjectAtIndex:toDelete];
    
    dirty = true;
    
    [table reloadData];
}

// Sheet actions

#define DISMISS(action) [self.sheetContents.sheetParent endSheet:self.sheetContents returnCode:action]

- (IBAction) cancelSheet:(id)sender
{
    DISMISS(NSModalResponseCancel);
//    [self.sheetContents.sheetParent endSheet:self.sheetContents returnCode:NSModalResponseOK];
}

- (IBAction) submitSheet:(id)sender
{
    DISMISS(NSModalResponseOK);
//    [self.sheetContents.sheetParent endSheet:self.sheetContents returnCode:NSModalResponseOK];
}

#undef DISMISS

// TableView protocols implementation
- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    return teaCache.count;
}

- (NSView *) tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    bool isTeaCell = [tableColumn.identifier isEqual: @"teaCol"];
    NSString *identifier = (isTeaCell) ? @"teaCV" : @"timeCV";
    
    NSTableCellView *result = [tableView makeViewWithIdentifier:identifier owner:self];
    
    TeaObject *tea = (TeaObject *)teaCache[row];
    if (isTeaCell)
        result.textField.stringValue = [NSString stringWithFormat:@"%@", tea.teaName];
    else
        result.textField.stringValue = [NSString stringWithFormat:@"%ld min", tea.teaDuration];
    
    return result;
}


@end
