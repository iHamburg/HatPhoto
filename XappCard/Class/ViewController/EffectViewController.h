//
//  EffectViewController.h
//  HatPhoto
//
//  Created by AppDevelopper on 14.01.13.
//
//

#import <UIKit/UIKit.h>
#import "IHRootViewController.h"
#import "PhotoEditFunctionScrollView.h"
#import "FrameScrollView.h"
#import "GPUImage.h"
#import "SpriteManager.h"

@interface EffectViewController : UIViewController<PhotoEditFunctionScrollViewDelegate, FrameScrollViewDelegate>{
	IHRootViewController *root;
	SpriteManager *spriteManager;

	PhotoEditFunctionScrollView *_functionScrollView;
	FrameScrollView *_frameScrollView;
	
	UIView *_imgContainer, *_buttonContainer, *_scrollViewContainer;  // 获取照片时使用
	UIImageView *_imgV, *_frameV;
	UIBarButtonItem *_shareBB;
	UIButton *_functionB, *_frameB;
	UIImageView *_buttonBGV;
	
	UIImage *_originalImage;
	
//	CGFloat _w,_h;
	int _effectIndex, _frameIndex,_lastIndex;
}

@property (nonatomic, strong) UIImage *img;


- (void)applyFilter;
- (void)applyFrame;

- (void)imageSelectRandomFilter;
- (void)imageSelectRandomFrame;

- (void)imageDidSelectedFilter:(ImageFilter*)filter;
- (void)imageDidSelectedFrame:(id)frame;


- (BOOL)isEffectMode;

//- (void)layoutBanner:(UIView*)banner loaded:(BOOL)loaded;

- (void)toShare;

@end
