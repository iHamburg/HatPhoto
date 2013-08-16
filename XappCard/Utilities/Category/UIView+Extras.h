//
//  UIView+Extras.h
//  XappCard
//
//  Created by  on 27.12.11.
//  Copyright (c) 2011 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extras)

- (void)fadeIn;
- (void)fadeOut;

+ (void)fadeIn:(NSArray*)views withDuration:(CGFloat)duration;
+ (void)fadeOut:(NSArray*)views withDuration:(CGFloat)duration;

- (void)setSize:(CGSize)size;
- (void)setOrigin:(CGPoint)original;
- (void)moveCenter:(CGPoint)away;

- (CGFloat)width;
- (CGFloat)height;


+ (CGSize)sizeForImage:(UIImage*)image withMinSide:(CGFloat)minSide;

- (void)setAntiAliasing;


- (UIImage*)imageScreenshot;
- (UIImage*)imageScreenshotWithFaktor:(int)faktor;

- (void)resetAnchorPoint;
- (void)removeAllSubviews;


- (void)applyShadow;
- (void)applyShadowRasterized:(BOOL)rasterized;

- (void)applyGradientBorder:(unsigned int)edges indent:(CGFloat)indent;
- (void)applyShadowBorder:(unsigned int)edges withColor:(UIColor*)color indent:(CGFloat)indent;

@end
