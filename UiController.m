//
//  UiController.m
//  AudioRouter
//
//  Created by Ward Witt on 11/9/07.
//  Copyright 2009 The Filmworkers Club. All rights reserved.
//

#import "UiController.h"
#import "PrefController.h"

@implementation UiController
static NSDictionary * network;
static NSDictionary * OIDStrings;
static NSString * slot;

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:
(NSApplication *)AudioRouter {
    return YES;
}

- (void)awakeFromNib{
	defaults = [NSUserDefaults standardUserDefaults];
	[[statusField window]setFrameAutosaveName:@"controllerWindow"];	// save and restore the location of the window
    
    NSString *slotPrefix = @".";
    NSString *slotNumber = [defaults objectForKey:@"slot"];
    if (slotNumber == nil) {
        if (!prefController) {
            prefController = [[PrefController alloc] init];
        }
        [prefController showWindow:self];
    }
    slot = [slotPrefix stringByAppendingString:slotNumber];

	network = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath]
														  stringByAppendingString:@"/Contents/Resources/Network.plist"]];
	if (network == nil)
	{
        NSLog (@"Error unable to open Network.plist");
        [network release];
    } 
	else 
	{
		[network retain];
	}
	
	OIDStrings = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath]
															 stringByAppendingString:@"/Contents/Resources/OIDStrings.plist"]];
	if (OIDStrings == nil)
	{
        NSLog (@"Error unable to open OIDStrings.plist");
        [OIDStrings release];
    } 
	else 
	{
		[OIDStrings retain];
	}
//	slot = [OIDStrings objectForKey:@"slotNumber"];
	
	NSArray * inputs = ([NSArray arrayWithObjects:@"Ch 1", @"Ch 2", @"Ch 3", @"Ch 4",
						 @"Ch 5", @"Ch 6", @"Ch 7", @"Ch 8", NULL]);
	[inputs retain];
	
	[statusField setStringValue:@""];
	[leftPopUp removeAllItems];
	[leftPopUp addItemsWithTitles:inputs];
	[centerPopUp removeAllItems];
	[centerPopUp addItemsWithTitles:inputs];
	[rightPopUp removeAllItems];
	[rightPopUp addItemsWithTitles:inputs];
	[leftSurroundPopUp removeAllItems];
	[leftSurroundPopUp addItemsWithTitles:inputs];
	[rightSurroundPopUp removeAllItems];
	[rightSurroundPopUp addItemsWithTitles:inputs];
	[subWooferPopUp removeAllItems];
	[subWooferPopUp addItemsWithTitles:inputs];
	[leftTotalPopUp removeAllItems];
	[leftTotalPopUp addItemsWithTitles:inputs];
	[rightTotalPopUp removeAllItems];
	[rightTotalPopUp addItemsWithTitles:inputs];
	
	NSString *community = [network objectForKey:@"community"];
//	NSString *host = [network objectForKey:@"host"];
    NSString *host = [defaults objectForKey:@"ipAddress"];
    
	[session release];
	session = [[SnmpSession alloc] initWithHost:host
									  community:community];
	if (nil == session)
	{
		[statusField setStringValue:@"Not Connected"];
		NSLog(@"Not connected");
	}else{
		[leftPopUp setEnabled:YES];
		[rightPopUp setEnabled:YES];
		[centerPopUp setEnabled:YES];
		[subWooferPopUp setEnabled:YES];
		[leftSurroundPopUp setEnabled:YES];
		[rightSurroundPopUp setEnabled:YES];
		[leftTotalPopUp setEnabled:YES];
		[rightTotalPopUp setEnabled:YES];
		[self update];
	}
}


- (void)update{
	if (nil == session)
	{
		NSLog(@"NULL session in update");
		return;
	}
	[leftPopUp selectItemAtIndex:[[session stringForOid:[[OIDStrings objectForKey:@"ch1ARouteOID"] stringByAppendingString:slot]] intValue]-3];
	[rightPopUp selectItemAtIndex:[[session stringForOid:[[OIDStrings objectForKey:@"ch1BRouteOID"] stringByAppendingString:slot]] intValue]-3];
	[centerPopUp selectItemAtIndex:[[session stringForOid:[[OIDStrings objectForKey:@"ch2ARouteOID"] stringByAppendingString:slot]] intValue]-3];
	[subWooferPopUp selectItemAtIndex:[[session stringForOid:[[OIDStrings objectForKey:@"ch2BRouteOID"] stringByAppendingString:slot]] intValue]-3];
	[leftSurroundPopUp selectItemAtIndex:[[session stringForOid:[[OIDStrings objectForKey:@"ch3ARouteOID"] stringByAppendingString:slot]] intValue]-3];
	[rightSurroundPopUp selectItemAtIndex:[[session stringForOid:[[OIDStrings objectForKey:@"ch3BRouteOID"] stringByAppendingString:slot]] intValue]-3];
	[leftTotalPopUp selectItemAtIndex:[[session stringForOid:[[OIDStrings objectForKey:@"ch4ARouteOID"] stringByAppendingString:slot]] intValue]-3];
	[rightTotalPopUp selectItemAtIndex:[[session stringForOid:[[OIDStrings objectForKey:@"ch4BRouteOID"] stringByAppendingString:slot]] intValue]-3];
	[aDelayCheckBox setIntValue:[[session stringForOid:[[OIDStrings objectForKey:@"ch1ADelayOID"] stringByAppendingString:slot]] intValue]];
	int vd  = [[session stringForOid:[[OIDStrings objectForKey:@"videoDelayOID"] stringByAppendingString:slot]] intValue];
	if (vd <= 0 || vd < 2)
		[vDelayPopUp selectItemAtIndex:vd];
}

- (IBAction)left:(id)sender{
	[session setOidIntValue:[[OIDStrings objectForKey:@"ch1ARouteOID"] stringByAppendingString:slot]
					  value:[sender indexOfSelectedItem] + 3];
}
- (IBAction)center:(id)sender{
	[session setOidIntValue:[[OIDStrings objectForKey:@"ch2ARouteOID"] stringByAppendingString:slot]
					  value:[sender indexOfSelectedItem] + 3];
}

- (IBAction)right:(id)sender{
	[session setOidIntValue:[[OIDStrings objectForKey:@"ch1BRouteOID"] stringByAppendingString:slot]
					  value:[sender indexOfSelectedItem] + 3];
}

- (IBAction)leftSurround:(id)sender{
	[session setOidIntValue:[[OIDStrings objectForKey:@"ch3ARouteOID"] stringByAppendingString:slot]
					  value:[sender indexOfSelectedItem] + 3];
}

- (IBAction)rightSurround:(id)sender{
	[session setOidIntValue:[[OIDStrings objectForKey:@"ch3BRouteOID"] stringByAppendingString:slot]
					  value:[sender indexOfSelectedItem] + 3];
}

- (IBAction)leftTotal:(id)sender{
	[session setOidIntValue:[[OIDStrings objectForKey:@"ch4ARouteOID"] stringByAppendingString:slot]
					  value:[sender indexOfSelectedItem] + 3];
}

- (IBAction)rightTotal:(id)sender{
	[session setOidIntValue:[[OIDStrings objectForKey:@"ch4BRouteOID"] stringByAppendingString:slot]
					  value:[sender indexOfSelectedItem] + 3];
}

- (IBAction)subWoofer:(id)sender{
	[session setOidIntValue:[[OIDStrings objectForKey:@"ch2BRouteOID"] stringByAppendingString:slot]
					  value:[sender indexOfSelectedItem] + 3];
}

- (IBAction)aDelay:(id)sender{
	if(1 == [sender intValue])
	{
		// Ch 1A delay in ms
		[session setOidIntValue:[[OIDStrings objectForKey:@"ch1ADelayOID"] stringByAppendingString:slot]
						  value:[[OIDStrings objectForKey:@"msDelay"]intValue]];
		// Ch 1B delay in ms
		[session setOidIntValue:[[OIDStrings objectForKey:@"ch1BDelayOID"] stringByAppendingString:slot]
						  value:[[OIDStrings objectForKey:@"msDelay"]intValue]];
		// Ch 2A delay in ms
		[session setOidIntValue:[[OIDStrings objectForKey:@"ch2ADelayOID"] stringByAppendingString:slot]
						  value:[[OIDStrings objectForKey:@"msDelay"]intValue]];
		// Ch 2B delay in ms
		[session setOidIntValue:[[OIDStrings objectForKey:@"ch2BDelayOID"] stringByAppendingString:slot]
						  value:[[OIDStrings objectForKey:@"msDelay"]intValue]];
		// Ch 3A delay in ms
		[session setOidIntValue:[[OIDStrings objectForKey:@"ch3ADelayOID"] stringByAppendingString:slot]
						  value:[[OIDStrings objectForKey:@"msDelay"]intValue]];
		// Ch 3B delay in ms
		[session setOidIntValue:[[OIDStrings objectForKey:@"ch3BDelayOID"] stringByAppendingString:slot]
						  value:[[OIDStrings objectForKey:@"msDelay"]intValue]];
		// Ch 4A delay in ms
		[session setOidIntValue:[[OIDStrings objectForKey:@"ch4ADelayOID"] stringByAppendingString:slot]
						  value:[[OIDStrings objectForKey:@"msDelay"]intValue]];
		// Ch 4B delay in ms
		[session setOidIntValue:[[OIDStrings objectForKey:@"ch4BDelayOID"] stringByAppendingString:slot]
						  value:[[OIDStrings objectForKey:@"msDelay"]intValue]];
	}
	else
	{
		// Ch 1A delay in ms
		[session setOidIntValue:[[OIDStrings objectForKey:@"ch1ADelayOID"] stringByAppendingString:slot] value:0];
		// Ch 1B delay in ms
		[session setOidIntValue:[[OIDStrings objectForKey:@"ch1BDelayOID"] stringByAppendingString:slot] value:0];
		// Ch 2A delay in ms
		[session setOidIntValue:[[OIDStrings objectForKey:@"ch2ADelayOID"] stringByAppendingString:slot] value:0];
		// Ch 2B delay in ms
		[session setOidIntValue:[[OIDStrings objectForKey:@"ch2BDelayOID"] stringByAppendingString:slot] value:0];
		// Ch 3A delay in ms
		[session setOidIntValue:[[OIDStrings objectForKey:@"ch3ADelayOID"] stringByAppendingString:slot] value:0];
		// Ch 3B delay in ms
		[session setOidIntValue:[[OIDStrings objectForKey:@"ch3BDelayOID"] stringByAppendingString:slot] value:0];
		// Ch 4A delay in ms
		[session setOidIntValue:[[OIDStrings objectForKey:@"ch4ADelayOID"] stringByAppendingString:slot] value:0];
		// Ch 4B delay in ms
		[session setOidIntValue:[[OIDStrings objectForKey:@"ch4BDelayOID"] stringByAppendingString:slot] value:0];
	}		
	
}

- (IBAction)vDelay:(id)sender{
	[session setOidIntValue:[[OIDStrings objectForKey:@"videoDelayOID"] stringByAppendingString:slot]
					  value:[sender indexOfSelectedItem]];
	
}

#pragma mark -
#pragma mark Menu Methods

- (IBAction)showPreferencePanel:(id)sender
{
	if (!prefController) {
		prefController = [[PrefController alloc] init];
	}
	[prefController showWindow:self];
}

@end
