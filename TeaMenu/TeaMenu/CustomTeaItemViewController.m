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
        timerView = (CustomTeaMenuItem *)[self view];
        timerView.model = self.timerModel;
        [self setView:timerView];
    }
    
    return self;
}

- (IBAction)startTimer:(id)sender {
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    // we don't need to go through startTimer:(id) here; we already have the number
    [appDelegate actualTimerStart:(timerModel.minutes * 60)];
}

@end
