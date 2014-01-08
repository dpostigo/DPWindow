//
// Created by Dani Postigo on 1/2/14.
// Copyright (c) 2014 Dani Postigo. All rights reserved.
//


#import "DPWindow.h"
#import "CALayer+FrameUtils.h"
#import "CALayer+ConstraintUtils.h"
#import "NSView+ConstraintGetters.h"
#import "NSView+SuperConstraints.h"
#import "TestView.h"
#import "NSView+ConstraintModifiers.h"

@implementation DPWindow

@synthesize titleBarHeight;
@synthesize footerBarHeight;

@synthesize footerBarLayer;
@synthesize backgroundLayer;

@synthesize contentContentView;

- (id) initWithContentRect: (NSRect) contentRect styleMask: (NSUInteger) aStyle backing: (NSBackingStoreType) bufferingType defer: (BOOL) flag {
    self = [super initWithContentRect: contentRect styleMask: NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask | NSTitledWindowMask | NSTexturedBackgroundWindowMask backing: bufferingType defer: flag];
    if (self) {
        titleBarHeight = 38;
        footerBarHeight = 0;
        //        footerBarHeight = 38;
    }

    return self;
}


- (void) awakeFromNib {
    [super awakeFromNib];

    [self setBackgroundColor: [NSColor clearColor]];
    //    [self setOpaque: NO];

    if (windowView == nil) windowView = self.contentAsView;
    windowView.wantsLayer = YES;

    CALayer *themeLayer = self.themeFrame.layer;
    themeLayer.borderWidth = 0;
    [themeLayer makeSuperlayer];
    [themeLayer insertSublayer: self.backgroundLayer atIndex: 0];
    [backgroundLayer superConstrainEdgesV: 0];
    [backgroundLayer superConstrainEdgesH: 0.25];
    //    themeLayer.backgroundColor = [NSColor clearColor].CGColor;
    themeLayer.delegate = self;

    [self transferViews];

    contentContentView.wantsLayer = YES;
    [contentContentView.layer makeSuperlayer];

    [self stylize];

}


- (void) stylize {

}


- (CGFloat) layerInset {
    return 0.0;
}

- (void) transferViews {

    NSArray *subviews = [NSArray arrayWithArray: windowView.subviews];
    NSArray *constraints = [NSArray arrayWithArray: windowView.constraints];


    TestView *contentView = [[TestView alloc] init];
    contentView.wantsLayer = YES;
    contentView.layer.delegate = self;

    self.contentContentView = contentView;

    for (NSView *view in subviews) [contentContentView addSubview: view];

    NSArray *newConstraints = [windowView constraintsModifiedToItem: contentContentView constraints: constraints];
    [windowView removeConstraints: constraints];
    [contentContentView addConstraints: newConstraints];

}


- (NSColor *) windowBackgroundColor {
    return [NSColor colorWithWhite: 0.1 alpha: 1.0];
    //    return [NSColor colorWithWhite: 0.2 alpha: 1.0];
}

#pragma mark Setters


- (void) setTitleBarHeight: (CGFloat) titleBarHeight1 {
    titleBarHeight = titleBarHeight1;
    [self updateConstraints];
}

- (void) setFooterBarHeight: (CGFloat) footerBarHeight1 {
    footerBarHeight = footerBarHeight1;
    [self updateConstraints];
}


- (void) setContentContentView: (NSView *) contentContentView1 {
    if (contentContentView && contentContentView.superview) {
        [contentContentView removeFromSuperview];
    }

    contentContentView = contentContentView1;

    if (contentContentView) {
        contentContentView.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
        [windowView addSubview: contentContentView];
        contentContentView.translatesAutoresizingMaskIntoConstraints = NO;
        [contentContentView superConstrain: NSLayoutAttributeTop constant: self.hackInset];
        [contentContentView superConstrain: NSLayoutAttributeBottom constant: -self.hackInset];
        [contentContentView superConstrain: NSLayoutAttributeLeft constant: self.hackInset];
        [contentContentView superConstrain: NSLayoutAttributeRight constant: -self.hackInset];
        [self updateConstraints];
    }
}

- (CGFloat) hackInset {
    return 0.5;
}


#pragma mark Constraints

- (void) updateConstraints {
    if (contentContentView) {
        NSLayoutConstraint *topConstraint = [windowView topConstraintForItem: contentContentView];
        topConstraint.constant = self.titleBarHeight - self.existingTitleBarHeight;

        NSLayoutConstraint *bottomConstraint = [windowView bottomConstraintForItem: contentContentView];
        bottomConstraint.constant = -self.footerBarHeight + self.hackInset;

        NSLayoutConstraint *leftConstraint = [windowView leftConstraintForItem: contentContentView];
        leftConstraint.constant = -self.hackInset;

        NSLayoutConstraint *rightConstraint = [windowView rightConstraintForItem: contentContentView];
        rightConstraint.constant = self.hackInset;
    }

    [self updateConstraintsForLayers];
    [self updateConstraintsForWindowButtons];

}


- (void) updateConstraintsForLayers {
    //
    //    CAConstraint *titleConstraint = [titleBarLayer superConstraintWithAttribute: kCAConstraintMaxY attribute: kCAConstraintMinY];
    //    [titleBarLayer removeConstraint: titleConstraint];

    [self.titleBarLayer removeConstraints];
    [titleBarLayer superConstrainEdgesH];
    [titleBarLayer superConstrainTopEdge];
    [titleBarLayer superConstrain: kCAConstraintMaxY to: kCAConstraintMinY offset: self.titleBarHeight];

    [self.footerBarLayer removeConstraints];
    [footerBarLayer superConstrainEdgesH];
    [footerBarLayer superConstrainBottomEdge: 0];
    footerBarLayer.height = self.footerBarHeight;
}

- (void) updateConstraintsForWindowButtons {

    CGFloat buttonSpacing = 20.0;
    NSView *superview = self.themeFrame;
    NSArray *views = [NSArray arrayWithObjects: [self.themeFrame viewWithTag: 0], [self.themeFrame viewWithTag: 1], [self.themeFrame viewWithTag: 2], nil];

    NSView *previousView = nil;
    for (int j = 0; j < [views count]; j++) {
        NSView *view = [self.themeFrame viewWithTag: j];
        view.translatesAutoresizingMaskIntoConstraints = NO;

        NSLayoutConstraint *topConstraint = [superview constraintForAttribute: NSLayoutAttributeTop item: view attribute: NSLayoutAttributeTop];
        if (topConstraint == nil) {
            topConstraint = [NSLayoutConstraint constraintWithItem: view attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: view.superview attribute: NSLayoutAttributeTop multiplier: 1.0 constant: (self.titleBarHeight - view.frame.size.height) / 2];
            [superview addConstraint: topConstraint];
        }
        topConstraint.constant = (self.titleBarHeight - view.frame.size.height) / 2;

        NSLayoutConstraint *leftConstraint = [superview constraintForAttribute: NSLayoutAttributeLeading item: view attribute: NSLayoutAttributeLeading];

        if (previousView) {
            if (leftConstraint == nil) {
                leftConstraint = [NSLayoutConstraint constraintWithItem: view attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: previousView attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: buttonSpacing];
                [superview addConstraint: leftConstraint];
            }
            leftConstraint.constant = buttonSpacing;
        } else {
            if (leftConstraint == nil) {
                leftConstraint = [NSLayoutConstraint constraintWithItem: view attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: view.superview attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: buttonSpacing * 0.5];
                [superview addConstraint: leftConstraint];
            }
            leftConstraint.constant = buttonSpacing * 0.5;
        }

        previousView = view;
    }

}







#pragma mark Background



- (CGFloat) existingTitleBarHeight {
    NSRect frame = self.frame;
    NSRect contentRect = [NSWindow contentRectForFrameRect: frame styleMask: self.styleMask];
    return frame.size.height - contentRect.size.height;
}




#pragma mark CALayerDelegate

- (id <CAAction>) actionForLayer: (CALayer *) layer forKey: (NSString *) event {
    return (id) [NSNull null]; // disable all implicit animations
}



#pragma mark Layer getters

- (void) setTitleBarLayer: (CALayer *) titleBarLayer1 {
    if (titleBarLayer && titleBarLayer.superlayer) {
        [titleBarLayer removeFromSuperlayer];
    }
    titleBarLayer = titleBarLayer1;

    if (titleBarLayer) {
        titleBarLayer.delegate = self;
        [backgroundLayer insertSublayer: titleBarLayer1 atIndex: 0];
        [self updateConstraintsForLayers];
    }
}


- (CALayer *) titleBarLayer {
    if (titleBarLayer == nil) {
        titleBarLayer = [CALayer layer];
        titleBarLayer.delegate = self;
        titleBarLayer.backgroundColor = [NSColor clearColor].CGColor;
    }
    return titleBarLayer;
}


- (CALayer *) footerBarLayer {
    if (footerBarLayer == nil) {
        footerBarLayer = [CALayer layer];
        //        footerBarLayer.backgroundColor = [NSColor redColor].CGColor;
        footerBarLayer.delegate = self;
        footerBarLayer.backgroundColor = [NSColor clearColor].CGColor;
    }
    return footerBarLayer;
}


- (CALayer *) backgroundLayer {
    if (backgroundLayer == nil) {
        backgroundLayer = [CALayer new];
        backgroundLayer.width = 30;
        backgroundLayer.height = 30;
        backgroundLayer.backgroundColor = [NSColor clearColor].CGColor;
        backgroundLayer.borderColor = [NSColor blackColor].CGColor;
        backgroundLayer.delegate = self;
        [backgroundLayer makeSuperlayer];

        [backgroundLayer addSublayer: self.titleBarLayer];
        [backgroundLayer addSublayer: self.footerBarLayer];

    }
    return backgroundLayer;
}





#pragma mark Utility Getters


- (NSView *) contentAsView {
    return ((NSView *) self.contentView);
}

- (NSView *) themeFrame {
    return self.contentAsView.superview;
}


@end