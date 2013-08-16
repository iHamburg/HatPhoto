//
//  PhotoEditFunctionScrollView.m
//  InstaMagazine
//
//  Created by XC  on 10/25/12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "PhotoEditFunctionScrollView.h"
#import "Utilities.h"
#import "ImageFilter.h"

@implementation PhotoEditFunctionScrollView

@synthesize viewDelegate,colorFilters,imageIndex = _imageIndex;


- (void)setImageIndex:(int)imageIndex{
	
	UIView *oldV = [self viewWithTag:_imageIndex+1];
	oldV.layer.borderWidth = 0;
	_imageIndex = imageIndex;
	
	UIView *newV = [self viewWithTag:_imageIndex+1];
	newV.layer.borderColor = kRedColor.CGColor;
	newV.layer.borderWidth = 3;
	

}

/*
 h: iPad: 100, iphone: 50
 
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		
//		self.backgroundColor = [UIColor viewFlipsideBackgroundColor];
		
		w = frame.size.width;
		h = frame.size.height;
		
        CGFloat imgW = isPad?50:50;
//        CGFloat margin = isPad?20:10;
		CGFloat hMargin = isPad?20:10;
		CGFloat wMargin = 10;
		CGFloat hLabel = isPad?20:18;
		self.showsHorizontalScrollIndicator = NO;

	
		// ImageFilter
		NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ImageFilter" ofType:@"plist"];

		NSArray *colorFilterArray = [NSArray arrayWithContentsOfFile:plistPath];
		colorFilters = [NSMutableArray array];
		for (NSDictionary *dict in colorFilterArray) {
			ImageFilter *filter = [[ImageFilter alloc]initWithType:ImageFilterTypeColorAdjusting dict:dict];
			[colorFilters addObject:filter];
			
		}

       
        for (int i = 0; i<[colorFilters count]; i++) {
		  ImageFilter *filter = colorFilters[i];
			
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(wMargin+ (imgW+wMargin) *i, hMargin, imgW, imgW)];
            imgV.tag = i+1;
            imgV.userInteractionEnabled = YES;
			imgV.image = [UIImage imageNamed:[filter.name stringByAppendingPathExtension:@"png"]];
            [imgV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleColorFilter:)]];
			imgV.layer.cornerRadius = isPad?10:5;
			imgV.layer.masksToBounds = YES;
            
            UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgV.frame), isPad?CGRectGetMaxY(imgV.frame):h-hLabel-5, imgW, hLabel)];
            l.textColor = [UIColor whiteColor];
            l.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
			l.font = [UIFont boldSystemFontOfSize:isPad?12:10];
            l.textAlignment = NSTextAlignmentCenter;
			l.text = filter.name;
         
            [self addSubview:imgV];
			[self addSubview:l];
			
			self.contentSize = CGSizeMake(CGRectGetMaxX(imgV.frame)+50, 0);

        }
        
      
		[self applyShadowBorder:kCALayerTopEdge withColor:[UIColor blackColor] indent:5];
    }
    return self;
}



- (void)handleColorFilter:(UITapGestureRecognizer*)tap{
    
    UIView *v = [tap view];

    int colorFilterIndex = v.tag - 1;
    ImageFilter *filter =colorFilters[colorFilterIndex];;

	[viewDelegate photoEditFunctionScrollViewDidSelected:filter];
	
	// 改变UI
	self.imageIndex = colorFilterIndex;
}



- (void)selectRandom{
	
	int randomIndex = arc4random()%[colorFilters count];
	while (randomIndex == _imageIndex) {
		randomIndex = arc4random()%[colorFilters count];
		
	}


	[viewDelegate photoEditFunctionScrollViewDidSelected:colorFilters[randomIndex]];
	
	self.imageIndex = randomIndex;
	
	UIView *v = [self viewWithTag:randomIndex+1];
	[self setContentOffset:CGPointMake(v.frame.origin.x-100, 0) animated:YES];

	
}
@end
