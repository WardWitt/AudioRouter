//
//  PrefController.m
//  AudioRouter
//
//  Created by Ward Witt on 9/24/13.
//
//

#import "PrefController.h"

@implementation PrefController

@synthesize ipAddress;
@synthesize slot;

#pragma mark -
#pragma mark Startup and Shutdown Methods

- (id)init
{
	self = [super initWithWindowNibName:@"Preferences"];
    
	return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    NSLog(@"Pref window loaded");
  }
@end
