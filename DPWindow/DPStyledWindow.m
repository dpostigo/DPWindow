//
// Created by Dani Postigo on 1/6/14.
// Copyright (c) 2014 Dani Postigo. All rights reserved.
//

#import <CALayer-DPUtils/CALayer+ConstraintUtils.h>
#import <CALayer-DPUtils/CALayer+SublayerUtils.h>
#import <CALayer-DPUtils/CALayer+FrameUtils.h>
#import "DPStyledWindow.h"
#import "CARoundedShapeLayer.h"
#import "NSColor+BlendingUtils.h"
#import "DPLayerDelegate.h"

@implementation DPStyledWindow {

}

- (void) stylize {
    [super stylize];

    CALayer *superlayer = backgroundLayer.superlayer;
    superlayer.delegate = [DPLayerDelegate sharedDelegate];
    [superlayer makeSuperlayer];

    [self stylizeTitleBarLayer];

    CALayer *contentLayer = contentContentView.layer;
    contentLayer.delegate = [DPLayerDelegate sharedDelegate];;
    contentLayer.backgroundColor = [NSColor controlColor].CGColor;

}

- (void) stylizeFooterBarLayer {


    CARoundedShapeLayer *roundedLayer2 = [CARoundedShapeLayer layer];
    roundedLayer2.corners = AFCornerLowerLeft | AFCornerLowerRight;
    roundedLayer2.radius = 4.5;
    [self.footerBarLayer addSublayer: roundedLayer2];
    [roundedLayer2 superConstrain];
    footerBarLayer.mask = roundedLayer2;

    CAGradientLayer *topShine = self.titleShineLayer;
    if (topShine == nil) {
        topShine = [CAGradientLayer layer];
        topShine.name = @"titleShineLayer";
        [titleBarLayer addSublayer: topShine];
        topShine.delegate = [DPLayerDelegate sharedDelegate];;
        [topShine superConstrain];
    }

    topShine.cornerRadius = backgroundLayer.cornerRadius;
    topShine.colors = [NSArray arrayWithObjects:
            (__bridge id) [NSColor colorWithDeviceWhite: 1.0 alpha: 0.5].CGColor,
            (__bridge id) [NSColor blueColor].CGColor,
            nil];

}

- (void) stylizeTitleBarLayer {

    [backgroundLayer setGeometryFlipped: YES];

    CARoundedShapeLayer *roundedLayer2 = [CARoundedShapeLayer layer];
    roundedLayer2.corners = AFCornerLowerLeft | AFCornerLowerRight;
    roundedLayer2.radius = 4.5;
    [titleBarLayer addSublayer: roundedLayer2];
    [roundedLayer2 superConstrain];
    titleBarLayer.mask = roundedLayer2;

    titleBarLayer.backgroundColor = [NSColor colorWithDeviceWhite: 0.15 alpha: 1.0].CGColor;
    titleBarLayer.backgroundColor = [NSColor colorWithDeviceWhite: 0.9 alpha: 1.0].CGColor;
    titleBarLayer.backgroundColor = [NSColor blueColor].CGColor;
    titleBarLayer.borderWidth = 0.5;
    [titleBarLayer makeSuperlayer];

    CAGradientLayer *topShine = self.titleShineLayer;
    if (topShine == nil) {
        topShine = [CAGradientLayer layer];
        topShine.name = @"titleShineLayer";
        [titleBarLayer addSublayer: topShine];
        topShine.delegate = [DPLayerDelegate sharedDelegate];;
        [topShine superConstrain];
    }

    //    topShine.backgroundColor = [NSColor clearColor].CGColor;
    topShine.cornerRadius = backgroundLayer.cornerRadius;
    //    topShine.borderColor = [NSColor darkGrayColor].CGColor;
    //    topShine.borderWidth = 0.5;
    topShine.colors = [NSArray arrayWithObjects:
            (__bridge id) [NSColor colorWithDeviceWhite: 1.0 alpha: 0.5].CGColor,
            (__bridge id) [NSColor blueColor].CGColor,
            nil];

    CALayer *rule = self.ruleLayer;
    if (rule == nil) {
        rule = [CALayer layer];
        rule.name = @"rule";
        rule.delegate = [DPLayerDelegate sharedDelegate];
        [backgroundLayer.superlayer addSublayer: rule];
        [rule superConstrainEdgesH: 0];
        [rule superConstrainBottomEdge: -titleBarHeight];

    }
    rule.backgroundColor = [NSColor blackColor].CGColor;
    rule.height = 1;
    rule.shadowColor = [NSColor whiteColor].CGColor;
    rule.shadowRadius = 0.5;
    rule.shadowOffset = CGSizeMake(0, 0.5);
    rule.shadowOpacity = 0.5;

    self.titleBarColor = [NSColor lightGrayColor];
}

- (void) setFooterBarHeight: (CGFloat) footerBarHeight1 {
    if (footerBarHeight1 > 0) {
        [self stylizeFooterBarLayer];
    }
    [super setFooterBarHeight: footerBarHeight1];
}



#pragma mark Colors

- (NSColor *) titleBarColor {
    return [NSColor colorWithCGColor: self.titleBarLayer.backgroundColor];
}

- (void) setTitleBarColor: (NSColor *) titleBarColor {
    titleBarLayer.backgroundColor = titleBarColor.CGColor;
    [self updateColors];
}

- (NSColor *) footerBarColor {
    return [NSColor colorWithCGColor: footerBarLayer.backgroundColor];
}

- (void) setFooterBarColor: (NSColor *) footerBarColor {
    self.footerBarLayer.backgroundColor = footerBarColor.CGColor;
}


- (NSColor *) shineColor {
    if (shineColor == nil) {
        shineColor = [NSColor colorWithDeviceWhite: 1.0 alpha: 0.5];
    }
    return shineColor;
}

- (void) setShineColor: (NSColor *) shineColor1 {
    shineColor = shineColor1;
    [self updateColors];
}



#pragma mark Update

- (void) updateColors {

    NSColor *color = self.titleBarColor;

    titleBarLayer.borderColor = [NSColor darken: color amount: 0.1].CGColor;

    if (self.titleShineLayer) {
        self.titleShineLayer.colors = [NSArray arrayWithObjects:
                (__bridge id) self.shineColor.CGColor,
                (__bridge id) titleBarLayer.backgroundColor,
                nil];

    }

    if (self.footerShineLayer) {
        self.footerShineLayer.colors = [NSArray arrayWithObjects:
                (__bridge id) self.shineColor.CGColor,
                (__bridge id) footerBarLayer.backgroundColor,
                nil];
    }

}



#pragma mark Constraints

- (void) updateConstraintsForLayers {
    [super updateConstraintsForLayers];

    CALayer *rule = self.ruleLayer;
    if (rule) {
        [rule removeConstraints];
        [rule superConstrainEdgesH: 0];
        [rule superConstrainBottomEdge: -titleBarHeight];
    }

}


#pragma mark Layer getters

- (CAGradientLayer *) titleShineLayer {
    CAGradientLayer *ret = (CAGradientLayer *) [titleBarLayer sublayerWithName: @"titleShineLayer"];
    if (ret == nil) {
        ret = [CAGradientLayer layer];
        ret.name = @"titleShineLayer";
        [titleBarLayer addSublayer: ret];
        [ret superConstrain];
        ret.delegate = [DPLayerDelegate sharedDelegate];
    }
    return ret;
}

- (CAGradientLayer *) footerShineLayer {
    CAGradientLayer *ret = (CAGradientLayer *) [footerBarLayer sublayerWithName: @"footerShineLayer"];
    if (ret == nil) {
        ret = [CAGradientLayer layer];
        ret.name = @"footerShineLayer";
        [self.footerBarLayer addSublayer: ret];
        [ret superConstrain];
        ret.delegate = [DPLayerDelegate sharedDelegate];
    }
    return ret;
}


- (CALayer *) ruleLayer {
    //    CALayer *superlayer = backgroundLayer.superlayer;

    //    if (ret == nil) {
    //        ret = [CALayer layer];
    //        ret.name = @"rule";
    //        ret.backgroundColor = [NSColor blackColor].CGColor;
    //        ret.delegate = self;
    //        ret.height = 1;
    //        ret.shadowColor = [NSColor whiteColor].CGColor;
    //        ret.shadowRadius = 0.5;
    //        ret.shadowOffset = CGSizeMake(0, 0.5);
    //        ret.shadowOpacity = 0.5;
    //    }
    return [backgroundLayer.superlayer sublayerWithName: @"rule"];
}


@end