//
// Created by Dani Postigo on 1/30/14.
//

#import <DPWindow/DPHeaderedWindow.h>
#import "NSWindowController+DPWindow.h"

@implementation NSWindowController (DPWindow)

- (DPHeaderedWindow *) headeredWindow {
    return (DPHeaderedWindow *) ([self.window isKindOfClass: [DPHeaderedWindow class]] ? self.window : nil);
}

@end