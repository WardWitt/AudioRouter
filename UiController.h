//
//  UiController.h
//  AudioRouter
//
//  Created by Ward Witt on 11/9/07.
//  Copyright 2009 The Filmworkers Club. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import	"SnmpSession.h"

@class PrefController;

@interface UiController : NSObject {
	
	NSUserDefaults *defaults;
    IBOutlet id statusField;
	IBOutlet id leftPopUp;
	IBOutlet id rightPopUp;
	IBOutlet id centerPopUp;
	IBOutlet id subWooferPopUp;
	IBOutlet id leftSurroundPopUp;
	IBOutlet id rightSurroundPopUp;
	IBOutlet id leftTotalPopUp;
	IBOutlet id rightTotalPopUp;
	IBOutlet id aDelayCheckBox;
	IBOutlet id vDelayPopUp;
	SnmpSession *session;
    PrefController *prefController;
}

- (IBAction)center:(id)sender;
- (IBAction)left:(id)sender;
- (IBAction)leftSurround:(id)sender;
- (IBAction)leftTotal:(id)sender;
- (IBAction)right:(id)sender;
- (IBAction)rightSurround:(id)sender;
- (IBAction)rightTotal:(id)sender;
- (IBAction)subWoofer:(id)sender;
- (IBAction)aDelay:(id)sender;
- (IBAction)vDelay:(id)sender;

-(IBAction)showPreferencePanel:(id)sender;

- (void)update;

@end
