//
//  CatScrollView.h
//  HatPhoto
//
//  Created by AppDevelopper on 14.01.13.
//
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface HatScrollView : UIScrollView{
	CGFloat w,h,margin,wImgV;
	UIButton *_categoryB;
	
	int _lastIndex;
}

@property (nonatomic, unsafe_unretained) MainViewController *parent;
@property (nonatomic, strong) HatCategory *category;
@property (nonatomic, assign) int index;

- (id)initWithFrame:(CGRect)frame parent:(id)_parent;

- (NSString*)randomImgName;
- (void)scrollToImg:(NSString*)imgName;

@end
