//
// Created by Dani Postigo on 1/2/14.
// Copyright (c) 2014 Dani Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPWindow : NSWindow <NSWindowDelegate> {

    IBOutlet NSView *windowView;

    CGFloat titleBarHeight;
    CALayer *titleBarLayer;

    CGFloat footerBarHeight;
    CALayer *footerBarLayer;
    CALayer *backgroundLayer;

    NSView *contentContentView;

}

@property(nonatomic) CGFloat titleBarHeight;
@property(nonatomic) CGFloat footerBarHeight;

@property(nonatomic, strong) CALayer *titleBarLayer;
@property(nonatomic, strong) CALayer *footerBarLayer;
@property(nonatomic, strong) CALayer *backgroundLayer;

@property(nonatomic, strong) NSView *contentContentView;

- (void) stylize;
- (CGFloat) hackInset;
- (void) updateConstraintsForLayers;
- (NSView *) contentAsView;
- (NSView *) themeFrame;

@end