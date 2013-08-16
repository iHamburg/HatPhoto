//
//  FrameScrollView.h
//  HatPhoto
//
//  Created by AppDevelopper on 19.01.13.
//
//

#import <UIKit/UIKit.h>
#import "Frame.h"

@protocol FrameScrollViewDelegate;

@interface FrameScrollView : UIScrollView{
	
	NSMutableArray *frames;
	NSMutableArray *imgVs;
	
	CGFloat w,h;
	
}

@property (nonatomic, unsafe_unretained) id<FrameScrollViewDelegate> viewDelegate;
@property (nonatomic, strong) NSMutableArray *frames;
@property (nonatomic, assign) int imageIndex; // 0: normal


- (void)selectRandom;
@end


@protocol FrameScrollViewDelegate <NSObject>

- (void)frameScrollViewDidSelectedFrame:(id)frame;


@end