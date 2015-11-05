//
//  CustomTeaItemViewController.m
//  TeaMenu
//
//  Created by Jan on 03.11.15.
//  Copyright (c) 2015 dfragment.net. All rights reserved.
//

#import "CustomTeaItemViewController.h"
#import "AppDelegate.h"

@implementation CustomTeaItemViewController

@synthesize timerModel, timerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        timerModel = [[CustomTeaTimeModel alloc] init];
        timerModel.minutes = 3; // default value
        timerModel.teaNotBrewing = YES; // app start: no tea brewing
        timerView = (CustomTeaMenuItem *)[self view];
        timerView.model = self.timerModel;
        [self setView:timerView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(startTeaNotification:)
                                                     name:START_TEA_NOTIFICATION
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stopTeaNotification:)
                                                     name:STOP_TEA_NOTIFICATION
                                                   object:nil];
    }
    
    return self;
}

- (IBAction)startTimer:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StartTea"
                                                        object:[NSNumber numberWithInteger:timerModel.minutes]];
}

// These notification recipients are only responsible for toggling timeModel.teaNotBrewing
// The actual starting/stopping is done by AppDelegate's recipients.

- (void) startTeaNotification: (NSNotification *) notification
{
    timerModel.teaNotBrewing = NO;
}

- (void) stopTeaNotification: (NSNotification *) notification
{
    timerModel.teaNotBrewing = YES;
}

- (void) dealloc
{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
