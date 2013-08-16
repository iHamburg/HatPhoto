//
//  PhotoEditFunctionScrollView.h
//  InstaMagazine
//
//  Created by XC  on 10/25/12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageFilter.h"

@protocol PhotoEditFunctionScrollViewDelegate;

/*
 
 正方形的thumb image，再加label
 
 */

@interface PhotoEditFunctionScrollView : UIScrollView{

    UIImageView *selectedIcon;

	NSMutableArray *colorFilters;
	
	CGFloat w,h;
}


@property (nonatomic, unsafe_unretained) id<PhotoEditFunctionScrollViewDelegate>viewDelegate;

@property (nonatomic, strong) NSMutableArray *colorFilters;

@property (nonatomic, assign) int imageIndex; // 0: normal

- (void)selectRandom;

@end

@protocol PhotoEditFunctionScrollViewDelegate <NSObject>

- (IBAction)photoEditFunctionScrollViewDidSelected:(id)filter;

@end
