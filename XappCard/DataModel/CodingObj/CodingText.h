//
//  CodingText.h
//  InstaMagazine
//
//  Created by AppDevelopper on 29.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "CodingObj.h"

@interface CodingText : CodingObj

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, strong) UIColor *fontColor;
@property (nonatomic, assign) float fontSize;
@property (nonatomic, assign) float fontSizeFaktor;

// since 2.8
@property (nonatomic, assign) int textAlignment;
@property (nonatomic, strong) UIColor *backgroundColor, *strokeColor;
- (id)initWithTextWidget:(id)textWidget;
@end
