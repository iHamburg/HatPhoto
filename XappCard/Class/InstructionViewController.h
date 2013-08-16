//
//  InstructionViewController.h
//  XappCard
//
//  Created by  on 03.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Controller.h"

@protocol InstructionDelegate;

@interface InstructionViewController : UIViewController <UIScrollViewDelegate>{

	UIScrollView *scrollView;
	UIPageControl *pageControl;
	int pageNum;
	float width;
}

@property (nonatomic, unsafe_unretained) id<InstructionDelegate> delegate;
- (IBAction)quit:(id)sender;



@end

@protocol InstructionDelegate <NSObject>

- (void)closeInstruction:(InstructionViewController*)vc;

@end