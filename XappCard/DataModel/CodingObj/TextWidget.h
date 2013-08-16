//
//  TextWidget.h
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 24.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"
#import "WidgetComponent.h"

#define kTextWidgetInitFrame CGRectMake(0,0,480,300)

@interface TextWidget : UILabel<WidgetDelegate>{
	
	float fontSizeFaktor; // fontsize = width*faktor, 在firstload的时候就确定下来
	WidgetComponent *widgetComp;

}


@property (nonatomic, strong) NSString *fontName; //
@property (nonatomic, assign) float fontSizeFaktor;
@property (nonatomic, strong) UIColor *bgColor, *strokeColor;


- (id)initWithCodingText:(id)codingText;

- (void)firstLoad;
- (void)load;

- (void)applyScale:(float)scale;
- (void)adjustFontSize;

//- (id)initWithTextLabel:(id)textLabel;
@end
