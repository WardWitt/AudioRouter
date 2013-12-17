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
    IBOutlet NSTextField *__weak ipAddress;
    IBOutlet NSTextField *__weak slot;
    IBOutlet NSTextField *__weak aDelay;
}
@property (weak) IBOutlet NSTextField *ipAddress;
@property (weak) IBOutlet NSTextField *slot;
@property (weak) IBOutlet NSTextField *aDelay;

@end
