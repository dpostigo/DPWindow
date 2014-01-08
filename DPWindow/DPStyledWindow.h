//
// Created by Dani Postigo on 1/6/14.
// Copyright (c) 2014 Dani Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPWindow.h"

@interface DPStyledWindow : DPWindow {
    NSColor *shineColor;

}

@property(nonatomic, strong) NSColor *titleBarColor;
@property(nonatomic, strong) NSColor *footerBarColor;

@property(nonatomic, strong) NSColor *shineColor;
@end