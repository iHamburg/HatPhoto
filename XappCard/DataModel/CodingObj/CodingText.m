//
//  CodingText.m
//  InstaMagazine
//
//  Created by AppDevelopper on 29.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "CodingText.h"
#import "TextWidget.h"

@implementation CodingText

@synthesize text,fontColor,fontName;
@synthesize  fontSize,fontSizeFaktor;

@synthesize textAlignment,backgroundColor,strokeColor;

- (id)initWithTextWidget:(TextWidget*)view{
	if (self == [super init]) {
		
		//		[view resetAnchorPoint];

		bounds = view.bounds;
		anchorPoint = view.layer.anchorPoint;
		transform = view.transform;
		center = view.center;
		
		
		text = view.text;
		fontColor = view.textColor;
		fontSize = view.font.pointSize;
		fontSizeFaktor = view.fontSizeFaktor;
		fontName = view.fontName;
		
		textAlignment = view.textAlignment;
		backgroundColor = view.bgColor;
		strokeColor = view.strokeColor;

	
	}
	return self;
}


- (void)load{
	keys = [NSMutableArray arrayWithObjects:@"text",@"fontColor",@"fontName",@"backgroundColor",@"strokeColor",nil];
	
}

- (void)loadOthers:(NSCoder *)aDecoder withEmptyKeys:(NSArray *)emptyKeys{
	
	
	bounds = [aDecoder decodeCGRectForKey:@"bounds"];
	transform = [aDecoder decodeCGAffineTransformForKey:@"transform"];
	anchorPoint = [aDecoder decodeCGPointForKey:@"anchorPoint" ];
	center = [aDecoder decodeCGPointForKey:@"center"];
	fontSize = [aDecoder decodeFloatForKey:@"fontSize"];
	if ([aDecoder decodeFloatForKey:@"fontSizeFaktor"]> DBL_MAX) {
		NSLog(@"fontSizeFatkor is inf");
	}else{
		fontSizeFaktor = [aDecoder decodeFloatForKey:@"fontSizeFaktor"];
	}
	
	textAlignment = [aDecoder decodeIntForKey:@"textAlignment"];

	
}

- (void)saveOthers:(NSCoder *)coder{
	
	
	[coder encodeCGRect:bounds forKey:@"bounds"];
	[coder encodeCGAffineTransform:transform forKey:@"transform"];
	[coder encodeCGPoint:center forKey:@"center"];
	[coder encodeCGPoint:anchorPoint forKey:@"anchorPoint"];
	[coder encodeFloat:fontSize forKey:@"fontSize"];
	
	if (fontSizeFaktor>DBL_MAX) {
		NSLog(@"fontSizeFatkor is inf");
	}else{
		[coder encodeFloat:fontSizeFaktor forKey:@"fontSizeFaktor"];
	}
	
	
	[coder encodeInt:textAlignment forKey:@"textAlignment"];
	
}
//
- (id)decodedObject{

	return [[TextWidget alloc]initWithCodingText:self];
}

@end
