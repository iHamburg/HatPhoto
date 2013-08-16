//
//  LoadingView.h
//  TheBootic
//
//  Created by AppDevelopper on 01.11.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView {
	
	UILabel *loadingLabel;
	UIActivityIndicatorView *activityIndicatorView;

}

+ (LoadingView*)sharedLoadingView;

- (void)addInView:(UIView*)aSuperview; // async 异步显示
- (void)removeView;

- (void)addTitle:(NSString*)title inView:(UIView*)aSuperview; //不用异步
- (void)addTitle:(NSString*)title inView:(UIView*)aSuperview duration:(CGFloat)duration;

@end
