//
//  LoadingView.m
//  TheBootic
//
//  Created by AppDevelopper on 01.11.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>
#import "Utilities.h"

@interface LoadingView()

- (void)addInViewIntern:(UIView*)aSuperview;

@end

@implementation LoadingView

static LoadingView *sharedLoadingView;


+ (LoadingView*)sharedLoadingView{
	
	
    @synchronized(sharedLoadingView){
        if (sharedLoadingView == nil) {
			//            sharedLoadingView = [[LoadingView alloc ]initWithFrame:CGRectMake(0, 0, 0, 0)];
			//			不能是zero！
			sharedLoadingView = [[LoadingView alloc ]initWithFrame:CGRectMake(0, 0, 1024, 768)];
			sharedLoadingView.opaque = NO;

	
        }
    }
    
    return sharedLoadingView;
}

- (id)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		
		CGFloat width = isPad?1024:480;
		CGFloat height = isPad?768:320;
		float rectWidth = isPad?240:180;
		float rectHeight = isPad?160:120;
		
		// loadingView 不能autoResize
		loadingLabel =[[UILabel alloc] initWithFrame:CGRectMake((width-rectWidth)/2, (height-rectHeight)/2, rectWidth, rectHeight)];
		loadingLabel.textColor = [UIColor whiteColor];
		loadingLabel.textAlignment = UITextAlignmentCenter;
		loadingLabel.numberOfLines = 0;
		loadingLabel.lineBreakMode = UILineBreakModeWordWrap;
		loadingLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
		loadingLabel.backgroundColor = [UIColor blackColor];
		loadingLabel.layer.cornerRadius = isPad?15:10;



		
		activityIndicatorView =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		
		CGRect activityIndicatorRect = activityIndicatorView.frame;
		activityIndicatorRect.origin.x = 0.5 * (frame.size.width - activityIndicatorRect.size.width);
		activityIndicatorRect.origin.y = 0.5*(frame.size.height-activityIndicatorRect.size.height);
		activityIndicatorView.frame = activityIndicatorRect;
		[activityIndicatorView startAnimating];
		activityIndicatorView.autoresizingMask = kAutoResize;
		
		
		[self addSubview:loadingLabel];
		[self addSubview:activityIndicatorView];


	}
	return self;
}

#pragma mark -

- (void)removeView{
	
	UIView *aSuperview = [sharedLoadingView superview];
	
    [sharedLoadingView removeFromSuperview];  
	
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[animation setDuration:.5];
	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
}



- (void)addInView:(UIView*)aSuperview{

	
	[self performSelectorInBackground:@selector(addInViewIntern:) withObject:aSuperview];
}



- (void)addInViewIntern:(UIView*)aSuperview{
//	L();

	loadingLabel.text = @"";
	[activityIndicatorView startAnimating];
	
	[self setSize:aSuperview.bounds.size];
	loadingLabel.center = self.center;
	
    [aSuperview addSubview:self];
 
	
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
	
    [[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];

}

- (void)addTitle:(NSString*)title inView:(UIView*)aSuperview{
	L();
//	loadingLabel.text = title;
//	//	loadingLabel.backgroundColor = [UIColor redColor];
//	[activityIndicatorView stopAnimating];
//	
//	[self setSize:aSuperview.bounds.size];
//	loadingLabel.center = self.center;
//	[aSuperview addSubview:self];
//	
//	//	NSLog(@"loadingLabel:%@",loadingLabel);
//	[self performSelector:@selector(removeView) withObject:nil afterDelay:1];

	[self addTitle:title inView:aSuperview duration:1];
}


- (void)addTitle:(NSString*)title inView:(UIView*)aSuperview duration:(CGFloat)duration{
	loadingLabel.text = title;
	//	loadingLabel.backgroundColor = [UIColor redColor];
	[activityIndicatorView stopAnimating];
	
	[self setSize:aSuperview.bounds.size];
	loadingLabel.center = self.center;
	[aSuperview addSubview:self];
	
	//	NSLog(@"loadingLabel:%@",loadingLabel);
	[self performSelector:@selector(removeView) withObject:nil afterDelay:duration];
}

@end
