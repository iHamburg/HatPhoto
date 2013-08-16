//
//  HatCatScrollView.h
//  HatPhoto
//
//  Created by AppDevelopper on 14.01.13.
//
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface HatCatScrollView : UIScrollView{
	
	CGFloat w,h;
}

@property (nonatomic, unsafe_unretained) MainViewController *parent;

- (id)initWithFrame:(CGRect)frame parent:(id)parent;

@end
