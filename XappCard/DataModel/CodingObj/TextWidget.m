//
//  TextWidget.m
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 24.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "TextWidget.h"
#import "CodingText.h"
#import "SpriteManager.h"
//#import "CardTextView.h"

#define kTextFontOriginalSize 30

@implementation TextWidget

@synthesize fontSizeFaktor,fontName, bgColor, strokeColor;


/**
 
 */
- (id)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		[self firstLoad];
		[self load];
	
	}
	return self;
}

- (void)firstLoad{
	self.font = [UIFont fontWithName:@"Chalkboard SE" size:kTextFontOriginalSize];
	self.fontName = @"Chalkboard SE";
	self.textColor = [UIColor redColor];
	fontSizeFaktor = self.font.pointSize/self.bounds.size.width;
	strokeColor = [UIColor whiteColor];
}

- (void)load{
	
	self.userInteractionEnabled = YES;
	self.backgroundColor = [UIColor clearColor];
	self.numberOfLines = 0;

	widgetComp = [[WidgetComponent alloc]init];

	if (!fontName) {
		fontName = @"Chalkboard SE";
	}
	
}

- (id)initWithCodingText:(CodingText*)v{

	if (self == [super initWithFrame:v.bounds]) {

		[self load];
		
		self.layer.anchorPoint = v.anchorPoint;
		self.transform = v.transform;
		self.center = v.center;

		self.text = v.text;
		self.textColor = v.fontColor;
		self.fontSizeFaktor = v.fontSizeFaktor;
		self.fontName = v.fontName;
		self.font = [UIFont fontWithName:fontName size:v.fontSize];
		
		self.textAlignment = v.textAlignment;
		bgColor = v.backgroundColor;
		strokeColor = v.strokeColor;
//		NSLog(@"fontname:%@,self.fontSize:%f, fontSize:%f,load with coding text:%@",fontName, self.fontSize,fontSize,self.font);
	}
	return self;
}


#pragma mark - Widget, save
- (id)encodedObject{

	// 保存前
	if (self.superview) {
		[self resetAnchorPoint];

	}
	
	return [[CodingText alloc]initWithTextWidget:self];
}

- (NSArray*)menuItems{
	
	
	NSArray *menuItems;
	
	if (widgetComp.lockFlag) {
		menuItems = @[[WidgetComponent unlockItem],[WidgetComponent editItem]];
	}
	else{
		menuItems = @[[WidgetComponent lockItem],[WidgetComponent editItem]];
	}
	
	return menuItems;
	
}

- (void)setLockFlag:(BOOL)_lockFlag{
	widgetComp.lockFlag = _lockFlag;
	
}
- (BOOL)lockFlag{
	
	return widgetComp.lockFlag;
}


#pragma mark - Adjust


- (void)applyScale:(float)scale{
	
	CGSize size = self.bounds.size;
	
	self.bounds = CGRectMake(0, 0, size.width*scale, size.height*scale);
	
	[self adjustFontSize];
}

// 在scale 的时候会调用，
- (void)adjustFontSize{
	
	float aFontSize = self.bounds.size.width * fontSizeFaktor;
	
	self.font = [UIFont fontWithName:fontName size:aFontSize];
	
	
}



#pragma mark -
- (void)drawRect:(CGRect)rect{
	//	L();
	//	[super drawRect:rect];
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	CGContextSetLineJoin(context, kCGLineJoinRound);
	

	
	// ---
	CGContextSetFillColorWithColor(context, self.textColor.CGColor);
	
	
	if (strokeColor) {
		
		CGContextSetRGBStrokeColor(context, 1, 1, 1, 1.0);
		float strokeWidth = round(0.03*self.font.pointSize);
		//		NSLog(@"stroke width # %f",strokeWidth);
		CGContextSetLineWidth(context, round(strokeWidth));
		CGContextSetTextDrawingMode(context, kCGTextFillStroke);
		
	}
	else {
		CGContextSetTextDrawingMode(context, kCGTextFill);
	}
	
	[self.text drawInRect:self.bounds withFont:self.font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
	
	
	CGContextRestoreGState(context);
	
}
@end
