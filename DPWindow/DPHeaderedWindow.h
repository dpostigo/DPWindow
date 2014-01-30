//
// Created by Dani Postigo on 1/15/14.
//

#import <Foundation/Foundation.h>
#import <DPWindow/DPStyledWindow.h>

@interface DPHeaderedWindow : DPStyledWindow {
    NSView *titleBarView;
    NSView *footerBarView;
}

@property(nonatomic, retain) NSView *titleBarView;
@property(nonatomic, strong) NSView *footerBarView;

@end