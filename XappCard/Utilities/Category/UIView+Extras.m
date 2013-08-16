//
//  UIView+Extras.m
//  XappCard
//
//  Created by  on 27.12.11.
//  Copyright (c) 2011 Xappsoft. All rights reserved.
//

#import "UIView+Extras.h"
#import <QuartzCore/QuartzCore.h>
#import "Macros.h"

@implementation UIView (Extras)

- (UIImage*)imageScreenshot{
	CGSize imageSize = self.bounds.size;

    UIGraphicsBeginImageContext(imageSize);
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
	
    [self.layer renderInContext: imageContext];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
    return viewImage;
}

- (UIImage*)imageScreenshotWithFaktor:(int)faktor{
	CGSize originSize = self.bounds.size;
	CGSize newSize = CGSizeMake(originSize.width * faktor, originSize.height * faktor);
	
	UIGraphicsBeginImageContext(newSize);
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
	
	
	// mirroring context
	//	CGContextTranslateCTM(imageContext, 0.0, imageSize.height);
	
	CGContextScaleCTM(imageContext, faktor, faktor);
	
	
    [self.layer renderInContext: imageContext];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
    return viewImage;

	
}

- (void)setImage:(UIImage *)image{
}


- (void)fadeIn {
	if (self.alpha == 1.0) {
		return;
	}
	
	[UIView beginAnimations:@"fadeIn" context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	
	self.alpha = 1.0;
	
	[UIView commitAnimations];
}

- (void)fadeOut {
//	if (self.alpha == 0.0) {
//		return;
//	}
//	
//	[UIView beginAnimations:@"fadeOut" context:nil];
//	[UIView setAnimationDuration:0.5];
//	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//	
//	self.alpha = 0.0;
//	
//	[UIView commitAnimations];

//	NSLog(@"fade out");
	[UIView animateWithDuration:1.0 animations:^{
		
//		[self removeFromSuperview];
		self.alpha = 0.0;
	}];
}

+ (void)fadeIn:(NSArray*)views withDuration:(CGFloat)duration {
	[UIView beginAnimations:@"fadeIn" context:nil];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	
	for (UIView* view in views) {
		[view setAlpha:1.0f];
	}
	[UIView commitAnimations];
}

+ (void)fadeOut:(NSArray*)views withDuration:(CGFloat)duration {
	[UIView beginAnimations:@"fadeOut" context:nil];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	
	for (UIView* view in views) {
		[view setAlpha:0.0f];
	}
	[UIView commitAnimations];
}

#pragma mark - Size
- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setOrigin:(CGPoint)original{
	CGRect frame = self.frame;
	frame.origin = original;
	self.frame = frame;
}


- (void)moveCenter:(CGPoint)away{
	self.center = CGPointMake(self.center.x + away.x, self.center.y + away.y);
}

- (CGFloat)width{
	return self.bounds.size.width;
}
- (CGFloat)height{
	return self.bounds.size.height;
}

+ (CGSize)sizeForImage:(UIImage*)image withMinSide:(CGFloat)minSide{
	CGFloat width = image.size.width;
	CGFloat height = image.size.height;
	CGSize size;
	
	if (width>height) {
		size = CGSizeMake( width/height*minSide, minSide);
	}
	else{
		size = CGSizeMake( minSide, height/width*minSide);
	}
	return size;
}

- (void)setAntiAliasing{
	
	
	self.layer.shouldRasterize = YES; 
	self.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
	self.clipsToBounds = NO; 
	self.layer.masksToBounds = NO;
	
}


- (void)resetAnchorPoint{
	CGPoint locationInSuperview = [self convertPoint:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)) toView:[self superview]];
	
	[[self layer] setAnchorPoint:CGPointMake(0.5, 0.5)];
	[self setCenter:locationInSuperview];
}


- (void)removeAllSubviews{
	NSArray *subviews = self.subviews;
	for (UIView *v in subviews) {
		[v removeFromSuperview];
	}
}



#pragma mark - Gradient & Shadow

- (void)applyShadow{
	self.layer.shadowColor = [UIColor colorWithWhite:0.2 alpha:0.8].CGColor;
	self.layer.shadowOpacity = 1;
	self.layer.shadowOffset = isPad?CGSizeMake(2, 2):CGSizeMake(1, 1);
	self.layer.shouldRasterize = YES;
}

- (void)applyShadowRasterized:(BOOL)rasterized{
	self.layer.shadowColor = [UIColor colorWithWhite:0.2 alpha:0.8].CGColor;
	self.layer.shadowOpacity = 1;
	self.layer.shadowOffset = isPad?CGSizeMake(2, 2):CGSizeMake(1, 1);
	self.layer.shouldRasterize = rasterized;

}
- (void)applyGradientBorder:(unsigned int)edges indent:(CGFloat)indent {
	
	//apply gradient mask
	CALayer* maskLayer = [CALayer layer];
	CGRect frame = self.bounds;
	
	maskLayer.frame = frame;
	
	if (self.layer.borderWidth && self.layer.borderColor) {
		frame = CGRectInset(frame, self.layer.borderWidth, self.layer.borderWidth);
	}
	
	if (edges & kCALayerTopEdge) {
		CAGradientLayer* topGradientLayer = [CAGradientLayer layer];
		topGradientLayer.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), indent);
		
		topGradientLayer.colors = [NSArray arrayWithObjects:
								   (id)[[UIColor clearColor] CGColor],
								   (id)[[UIColor blackColor] CGColor],
								   nil];
		topGradientLayer.startPoint = CGPointMake(0.5,0.0);
		topGradientLayer.endPoint = CGPointMake(0.5,1.0);
		[maskLayer addSublayer:topGradientLayer];
		
		frame.origin.y = indent;
		frame.size.height -= indent;
	}
	
	if (edges & kCALayerBottomEdge) {
		CAGradientLayer* bottomGradientLayer = [CAGradientLayer layer];
		bottomGradientLayer.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMaxY(frame) - indent, CGRectGetWidth(frame), indent);
		
		bottomGradientLayer.colors = [NSArray arrayWithObjects:
									  (id)[[UIColor blackColor] CGColor],
									  (id)[[UIColor clearColor] CGColor],
									  nil];
		
		bottomGradientLayer.startPoint = CGPointMake(0.5,0.0);
		bottomGradientLayer.endPoint = CGPointMake(0.5,1.0);
		[maskLayer addSublayer:bottomGradientLayer];
		
		frame.size.height -= indent;
	}
	
	if (edges & kCALayerLeftEdge) {
		CAGradientLayer* leftGradientLayer = [CAGradientLayer layer];
		leftGradientLayer.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), indent, CGRectGetHeight(frame));
		
		leftGradientLayer.colors = [NSArray arrayWithObjects:
									(id)[[UIColor clearColor] CGColor],
									(id)[[UIColor blackColor] CGColor],
									nil];
		
		leftGradientLayer.startPoint = CGPointMake(0.0,0.5);
		leftGradientLayer.endPoint = CGPointMake(1.0,0.5);
		[maskLayer addSublayer:leftGradientLayer];
		
		frame.origin.x = indent;
		frame.size.width -= indent;
	}
	
	if (edges & kCALayerRightEdge) {
		CAGradientLayer* rightGradientLayer = [CAGradientLayer layer];
		rightGradientLayer.frame = CGRectMake(CGRectGetMaxX(frame) - indent, CGRectGetMinY(frame), indent, CGRectGetHeight(frame));
		
		rightGradientLayer.colors = [NSArray arrayWithObjects:
									 (id)[[UIColor blackColor] CGColor],
									 (id)[[UIColor clearColor] CGColor],
									 nil];
		
		rightGradientLayer.startPoint = CGPointMake(0.0,0.5);
		rightGradientLayer.endPoint = CGPointMake(1.0,0.5);
		[maskLayer addSublayer:rightGradientLayer];
		
		frame.size.width -= indent;
	}
	
	//at least the middle
	CALayer* middleLayer = [CALayer layer];
	middleLayer.backgroundColor = [UIColor blackColor].CGColor;
	middleLayer.frame = frame;
	[maskLayer addSublayer:middleLayer];
	
	if (self.layer.borderWidth && self.layer.borderColor) {
		CALayer* borderLayer = [CALayer layer];
		borderLayer.frame = self.bounds;
		borderLayer.borderColor = self.layer.borderColor;
		borderLayer.borderWidth = self.layer.borderWidth;
		[maskLayer addSublayer:borderLayer];
	}
	
	self.layer.mask = maskLayer;
}

- (void)applyShadowBorder:(unsigned int)edges withColor:(UIColor*)color indent:(CGFloat)indent {
	UIColor* shadowColor = (color)? color: [UIColor blackColor];
	CGRect frame = self.bounds;
	
	if (edges & kCALayerTopEdge) {
		CAGradientLayer* topGradientLayer = [CAGradientLayer layer];
		if ([self isKindOfClass:[UIScrollView class]]) {
			topGradientLayer.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame)+[(UIScrollView*)self contentSize].width, indent);
			
		}
		else
			topGradientLayer.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), indent);
		
		
//		NSLog(@"topLayer # %@",NSStringFromCGRect(topGradientLayer.frame));
		topGradientLayer.colors = [NSArray arrayWithObjects:
								   (id)shadowColor.CGColor,
								   (id)[[UIColor clearColor] CGColor],
								   nil];
		topGradientLayer.startPoint = CGPointMake(0.5,0.0);
		topGradientLayer.endPoint = CGPointMake(0.5,1.0);
		[self.layer addSublayer:topGradientLayer];
	}
	
	if (edges & kCALayerBottomEdge) {
		CAGradientLayer* bottomGradientLayer = [CAGradientLayer layer];
		if ([self isKindOfClass:[UIScrollView class]]) {
			bottomGradientLayer.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame)+[(UIScrollView*)self contentSize].width, indent);
			
		}
		else
			bottomGradientLayer.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMaxY(frame) - indent, CGRectGetWidth(frame), indent);
		
		bottomGradientLayer.colors = [NSArray arrayWithObjects:
									  (id)[[UIColor clearColor] CGColor],
									  (id)shadowColor.CGColor,
									  nil];
		
		bottomGradientLayer.startPoint = CGPointMake(0.5,0.0);
		bottomGradientLayer.endPoint = CGPointMake(0.5,1.0);
		[self.layer addSublayer:bottomGradientLayer];
	}
	
	if (edges & kCALayerLeftEdge) {
		CAGradientLayer* leftGradientLayer = [CAGradientLayer layer];
		if ([self isKindOfClass:[UIScrollView class]]) {
			leftGradientLayer.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame),indent, CGRectGetHeight(frame)+[(UIScrollView*)self contentSize].height);
			
		}
		else
		
			leftGradientLayer.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), indent, CGRectGetHeight(frame));
		
		leftGradientLayer.colors = [NSArray arrayWithObjects:
									(id)shadowColor.CGColor,
									(id)[[UIColor clearColor] CGColor],
									nil];
		
		leftGradientLayer.startPoint = CGPointMake(0.0,0.5);
		leftGradientLayer.endPoint = CGPointMake(1.0,0.5);
		[self.layer addSublayer:leftGradientLayer];
	}
	
	if (edges & kCALayerRightEdge) {
		CAGradientLayer* rightGradientLayer = [CAGradientLayer layer];
		
		if ([self isKindOfClass:[UIScrollView class]]) {
			rightGradientLayer.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame),indent, CGRectGetHeight(frame)+[(UIScrollView*)self contentSize].height);
			
		}
		else
			
			rightGradientLayer.frame = CGRectMake(CGRectGetMaxX(frame) - indent, CGRectGetMinY(frame), indent, CGRectGetHeight(frame));
		
		rightGradientLayer.colors = [NSArray arrayWithObjects:
									 (id)[[UIColor clearColor] CGColor],
									 (id)shadowColor.CGColor,
									 nil];
		
		rightGradientLayer.startPoint = CGPointMake(0.0,0.5);
		rightGradientLayer.endPoint = CGPointMake(1.0,0.5);
		[self.layer addSublayer:rightGradientLayer];
	}
}

@end
