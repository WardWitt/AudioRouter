//
//  PrefController.h
//  AudioRouter
//
//  Created by Ward Witt on 9/24/13.
//
//

#import <Foundation/Foundation.h>

@interface PrefController : NSWindowController
{
    IBOutlet NSTextField *ipAddress;
    IBOutlet NSTextField *slot;
}
@property (assign) IBOutlet NSTextField *ipAddress;
@property (assign) IBOutlet NSTextField *slot;

@end
