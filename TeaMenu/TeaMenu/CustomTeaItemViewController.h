//
//  CustomTeaItemViewController.h
//  TeaMenu
//
//  Created by Jan on 03.11.15.
//  Copyright (c) 2015 dfragment.net. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "TeaTimerNotification.h"

@class CustomTeaTimeModel, CustomTeaMenuItem;

@interface CustomTeaItemViewController : NSViewController <TeaTimerNotification> {
}

@property (strong) CustomTeaTimeModel *timerModel;
@property (strong) CustomTeaMenuItem *timerView;

- (IBAction)startTimer:(id)sender;

@end
