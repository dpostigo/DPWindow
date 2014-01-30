//
// Created by Dani Postigo on 1/15/14.
//

#import "DPHeaderedWindow.h"
#import "NSView+SuperConstraints.h"
#import "NSView+ConstraintGetters.h"
#import "NSView+SiblingConstraints.h"

@implementation DPHeaderedWindow

@synthesize titleBarView;
@synthesize footerBarView;

- (void) awakeFromNib {
    [super awakeFromNib];
}


- (void) setTitleBarView: (NSView *) titleBarView1 {
    if (titleBarView && titleBarView.superview) {
        [titleBarView removeFromSuperview];
    }
    titleBarView = titleBarView1;

    if (titleBarView) {

        [self.themeFrame addSubview: titleBarView];

        titleBarView.translatesAutoresizingMaskIntoConstraints = NO;

        //
        //        [titleBarView superConstrain: NSLayoutAttributeLeft constant: self.hackInset];
        //        [titleBarView superConstrain: NSLayoutAttributeRight constant: -self.hackInset];
        //
        //        //        [headerView superConstrain: NSLayoutAttributeTop constant: self.hackInset];
        //        [titleBarView superConstrain: NSLayoutAttributeTop constant: self.hackInset];


        //        [titleBarView superConstrain: NSLayoutAttributeTop constant: 0];
        [titleBarView superConstrain: NSLayoutAttributeTop constant: self.hackInset];
        //        [contentContentView superConstrain: NSLayoutAttributeBottom constant: -self.hackInset];
        [titleBarView superConstrain: NSLayoutAttributeLeft constant: self.hackInset];
        [titleBarView selfConstrain: NSLayoutAttributeHeight constant: self.titleBarHeight];
        [titleBarView superConstrain: NSLayoutAttributeRight constant: -self.hackInset];

        //        [titleBarView superConstrainEdgesV: 0];
        [self updateConstraintsForViews];

    }
}


- (void) setFooterBarView: (NSView *) footerBarView1 {
    if (footerBarView && footerBarView.superview) {
        [footerBarView removeFromSuperview];
    }

    footerBarView = footerBarView1;

    if (footerBarView) {

        [self.themeFrame addSubview: footerBarView];

        footerBarView.translatesAutoresizingMaskIntoConstraints = NO;

        [footerBarView superConstrain: NSLayoutAttributeLeft constant: self.hackInset];
        [footerBarView superConstrain: NSLayoutAttributeRight constant: -self.hackInset];
        [footerBarView selfConstrain: NSLayoutAttributeHeight constant: self.footerBarHeight];
        [footerBarView superConstrain: NSLayoutAttributeBottom constant: self.hackInset];

    }
}


- (void) updateConstraintsForViews {
    [super updateConstraintsForViews];

    if (titleBarView) {

        NSLayoutConstraint *topConstraint = [self.themeFrame topConstraintForItem: titleBarView];
        topConstraint.constant = self.hackInset;
        //
        //        NSLayoutConstraint *bottomConstraint = [self.themeFrame bottomConstraintForItem: titleBarView];
        //        bottomConstraint.constant = -self.footerBarHeight + self.hackInset;
        //
        NSLayoutConstraint *leftConstraint = [self.themeFrame leftConstraintForItem: titleBarView];
        leftConstraint.constant = self.hackInset;
        //
        NSLayoutConstraint *rightConstraint = [self.themeFrame rightConstraintForItem: titleBarView];
        rightConstraint.constant = -self.hackInset;

        NSLayoutConstraint *heightConstraint = [titleBarView staticHeightConstraint];
        heightConstraint.constant = self.titleBarHeight;

        if (heightConstraint == nil) {
            NSLog(@"NO HEIGHT CONSTRAINT");
        }

    }

    if (footerBarView) {

        NSLayoutConstraint *bottomConstraint = [self.themeFrame bottomConstraintForItem: footerBarView];
        bottomConstraint.constant = self.hackInset;
        //
        //        NSLayoutConstraint *bottomConstraint = [self.themeFrame bottomConstraintForItem: titleBarView];
        //        bottomConstraint.constant = -self.footerBarHeight + self.hackInset;
        //
        NSLayoutConstraint *leftConstraint = [self.themeFrame leftConstraintForItem: footerBarView];
        leftConstraint.constant = self.hackInset;
        //
        NSLayoutConstraint *rightConstraint = [self.themeFrame rightConstraintForItem: footerBarView];
        rightConstraint.constant = -self.hackInset;

        NSLayoutConstraint *heightConstraint = [footerBarView staticHeightConstraint];
        heightConstraint.constant = self.footerBarHeight;

    }
}




@end