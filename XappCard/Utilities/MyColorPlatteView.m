//
//  ColorPlatteView.m
//  XappCard
//
//  Created by  on 06.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "MyColorPlatteView.h"
#import <QuartzCore/QuartzCore.h>


@implementation MyColorPlatteView

@synthesize delegate;


NSString* myColorPalette[6][4] = {
	
	@"000000",@"575757",@"b5b5b5",@"ffffff", //black and white
	@"c8ebb1",@"9bcc94",@"689864",@"405e0d", //green
	@"ed1f24",@"ff6501",@"993303",@"673303", 
	@"c7ddf5",@"91ceff",@"669acc",@"336799", //blue
	@"fff7ce",@"ffff66",@"ce9834",@"9a660d", //yellow
	@"8abcb9",@"fdc975",@"319ea1",@"ff945a", //other
	
};

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
		// Initialization code
		if (frame.size.width>frame.size.height) {
			landscape = YES;
		}
		else
			landscape = NO;
		[self initSubviews];
	}
    return self;
}

- (void)awakeFromNib{
	CGSize size = self.bounds.size;
	if (size.width>size.height) {
		landscape = YES;
	}
	else{
		landscape = NO;
	}
	
	[self initSubviews];
}

- (void)dealloc{

	L();
		
}

- (void)initSubviews{
	self.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
	self.layer.cornerRadius = 10;
	
	w = CGRectGetWidth(self.bounds);
	h = CGRectGetHeight(self.bounds);
	
	if (landscape) {
	
		
		CGFloat margin = 10;
		CGFloat wB = (w - 7*margin)/6;
		CGFloat hB = (h - 5*margin)/4;
		
			for (int i = 0; i< 6; i++) {
				for (int j = 0; j<4; j++) {
					
					UIView *v = [[UIView alloc] initWithFrame:CGRectMake(margin+(wB+margin)*i, margin+ (hB+margin)*j, wB, hB)];
					v.layer.cornerRadius = 10;
					v.layer.masksToBounds = YES;
					
					[v addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
					NSString *colorStr = myColorPalette[i][j];
					v.backgroundColor = [colorStr colorFromHex];
					v.autoresizingMask = kAutoResize;
					[self addSubview:v];
				}
			}

	}
	else{
		CGFloat width = self.bounds.size.width/5;
		CGFloat height = self.bounds.size.height/7;
		
		for (int i = 0; i< 6; i++) {
			for (int j = 0; j<4; j++) {
				
				UIView *v = [[UIView alloc] initWithFrame:CGRectMake(width/2+width*j, height/2+height*i, width-10, height-10)];
				v.layer.cornerRadius = 10;
				v.layer.masksToBounds = YES;
				
				[v addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
				NSString *colorStr = myColorPalette[i][j];
				v.backgroundColor = [colorStr colorFromHex];
				v.autoresizingMask = kAutoResize;
				[self addSubview:v];
			}
		}
	}
	
	
}


- (void)handleTap:(UITapGestureRecognizer*)gesture{
	L();
	UIView *v = gesture.view;
	UIColor *color = v.backgroundColor;

	[delegate colorPlatte:self didTapColor:color];
}




@end
