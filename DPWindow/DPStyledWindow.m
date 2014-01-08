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

@implementation DPStyledWindow {

}

- (void) stylize {
    [super stylize];

    CALayer *superlayer = backgroundLayer.superlayer;
    superlayer.delegate = self;
    [superlayer makeSuperlayer];

    [self stylizeTitleBarLayer];

    CALayer *contentLayer = contentContentView.layer;
    contentLayer.delegate = self;
    contentLayer.backgroundColor = [NSColor controlColor].CGColor;

    //    CALayer *roundedBg = [CALayer layer];
    //    [contentLayer insertSublayer: roundedBg atIndex: 0];
    //    [roundedBg superConstrain];
    //    roundedBg.backgroundColor = [NSColor controlColor].CGColor;
    //    roundedBg.delegate = self;

}

- (void) stylizeTitleBarLayer {

    [backgroundLayer setGeometryFlipped: YES];

    CARoundedShapeLayer *roundedLayer2 = [CARoundedShapeLayer layer];
    roundedLayer2.corners = AFCornerLowerLeft | AFCornerLowerRight;
    roundedLayer2.radius = 4.5;
    [titleBarLayer addSublayer: roundedLayer2];
    [roundedLayer2 superConstrain];
    titleBarLayer.mask = roundedLayer2;

    titleBarLayer.backgroundColor = [NSColor colorWithWhite: 0.15 alpha: 1.0].CGColor;
    titleBarLayer.backgroundColor = [NSColor colorWithWhite: 0.9 alpha: 1.0].CGColor;
    titleBarLayer.backgroundColor = [NSColor blueColor].CGColor;
    titleBarLayer.borderWidth = 0.5;
    [titleBarLayer makeSuperlayer];

    CAGradientLayer *topShine = self.shineLayer;
    if (topShine == nil) {
        topShine = [CAGradientLayer layer];
        topShine.name = @"shineLayer";
        [titleBarLayer addSublayer: topShine];
        topShine.delegate = self;
        [topShine superConstrain];
    }

    //    topShine.backgroundColor = [NSColor clearColor].CGColor;
    topShine.cornerRadius = backgroundLayer.cornerRadius;
    //    topShine.borderColor = [NSColor darkGrayColor].CGColor;
    //    topShine.borderWidth = 0.5;
    topShine.colors = [NSArray arrayWithObjects:
            (__bridge id) [NSColor colorWithWhite: 1.0 alpha: 0.5].CGColor,
            (__bridge id) [NSColor blueColor].CGColor,
            nil];

    CALayer *rule = self.ruleLayer;
    if (rule == nil) {
        rule = [CALayer layer];
        rule.name = @"rule";
        rule.delegate = self;
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


#pragma mark Colors

- (NSColor *) titleBarColor {
    NSLog(@"self.titleBarLayer = %@", self.titleBarLayer);
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
    footerBarLayer.backgroundColor = footerBarColor.CGColor;
}


- (NSColor *) shineColor {
    if (shineColor == nil) {
        shineColor = [NSColor colorWithWhite: 1.0 alpha: 0.5];
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

    CAGradientLayer *shine = self.shineLayer;
    if (shine) {
        shine.colors = [NSArray arrayWithObjects:
                (__bridge id) self.shineColor.CGColor,
                (__bridge id) titleBarLayer.backgroundColor,
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

- (CAGradientLayer *) shineLayer {
    CAGradientLayer *ret = (CAGradientLayer *) [titleBarLayer sublayerWithName: @"shineLayer"];
    if (ret == nil) {
        ret = [CAGradientLayer layer];
        ret.name = @"shineLayer";
        [titleBarLayer addSublayer: ret];
        [ret superConstrain];
        ret.delegate = self;
    }
    return ret;
}


- (CALayer *) ruleLayer {
    CALayer *superlayer = backgroundLayer.superlayer;

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