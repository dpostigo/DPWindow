//
// Created by Dani Postigo on 1/15/14.
//

#import <Foundation/Foundation.h>
#import <DPWindow/DPStyledWindow.h>

@interface DPHeaderedWindow : DPStyledWindow {
    IBOutlet  NSView *titleBarView;
    IBOutlet  NSView *footerBarView;
}

@property(nonatomic, strong) NSView *titleBarView;
@property(nonatomic, strong) NSView *footerBarView;

@end